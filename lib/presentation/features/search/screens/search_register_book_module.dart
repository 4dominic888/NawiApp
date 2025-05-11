import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_grouped_list/infinite_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/infrastructure/export_report_manager.dart';
import 'package:nawiapp/infrastructure/register_book_export.dart';
import 'package:nawiapp/presentation/features/export/screens/view_pdf.dart';
import 'package:nawiapp/presentation/features/search/providers/register_book/search_register_book_list_provider.dart';
import 'package:nawiapp/presentation/features/search/screens/modals/advanced_register_book_filter_modal.dart';
import 'package:nawiapp/presentation/widgets/notification_message.dart';
import 'package:nawiapp/presentation/widgets/register_book_element.dart';
import 'package:nawiapp/presentation/features/search/widgets/search_filter_field.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class SearchRegisterBookModule extends ConsumerStatefulWidget {
  const SearchRegisterBookModule({
    super.key,
  });

  @override
  ConsumerState<SearchRegisterBookModule> createState() => _SearchRegisterBookModuleState();
}

class _SearchRegisterBookModuleState extends ConsumerState<SearchRegisterBookModule> {

  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final searchNotifier = ref.read(registerBookSummarySearchProvider.notifier);
    final infiniteListController = searchNotifier.controller;
    final filterNotifier = ref.read(registerBookFilterProvider.notifier);
    final RegisterBookFilter filterWatcher = ref.watch(registerBookFilterProvider);
    final int elementCountWatcher = ref.watch(registerBookSummarySearchProvider);

    return Scaffold(
      appBar: SearchFilterField(
        hintTextField: 'Búsqueda por acción',
        filterAction: () async {
          final newFilter = await showDialog<RegisterBookFilter?>(
            context: context,
            builder: (_) => AdvancedRegisterBookFilterModal(currentFilter: filterNotifier.state)
          );

          if(newFilter != null) {
            filterNotifier.state = newFilter;
            searchNotifier.refresh();
          }
        },
        textOnChanged: (text) {
          debounce?.cancel();
          debounce = Timer(const Duration(milliseconds: 500), () {
            final newFilter = filterNotifier.state.copyWith(actionLike: text);
    
            if(filterNotifier.state != newFilter) {
              filterNotifier.state = newFilter;
              searchNotifier.refresh();
            }
          });
        },
        extraWidget: [
          IconButton(
            style: ElevatedButton.styleFrom(backgroundColor: NawiColorUtils.secondaryColor),
            icon: const Icon(Icons.cleaning_services),
            onPressed: filterWatcher.isEmpty ? null : () {
              filterNotifier.state = RegisterBookFilter();
              searchNotifier.refresh();
            }
          ),

          IconButton(
            style: ElevatedButton.styleFrom(backgroundColor: NawiColorUtils.secondaryColor),
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: elementCountWatcher == 0 ? null : () async {
              final optionToExport = await showMenu<ExportReportManager>(
                context: context,
                position: RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem<ExportReportManager>(
                    value: RegisterBookExportByDate(),
                    child: const Text('Por fecha')
                  ),
                  PopupMenuItem<ExportReportManager>(
                    value: RegisterBookExportByStudent(),
                    child: const Text('Por estudiante')
                  )
                ]
              );

              if(optionToExport != null) {
                final documentResult = await optionToExport.generate(filterNotifier.state.withouPagination);

                documentResult.onValue(
                  withPopup: false,
                  onError: (error, message) => NotificationMessage.showErrorNotification(message),
                  onSuccessfully: (data, message) async {
                    final pdfData = await optionToExport.getBytes(data);
                    if(!context.mounted) return;
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ViewPdf(pdfData: pdfData),
                    ));
                  },
                );

              }
            },
          )
        ]
      ),
      body: InfiniteGroupedList(
        controller: infiniteListController,
        onLoadMore: searchNotifier.fetchPage,
        groupBy: (item) => item.createdAt,
        sortGroupBy: (item) => item.createdAt,
        groupCreator: (date) => '${date.year}-${date.month}-${date.day}',
        initialItemsErrorWidget: (error) => Text(error.toString()),
        loadingWidget: const Center(child: CircularProgressIndicator()),
        showRefreshIndicator: true,
        stickyGroups: false,
        noItemsFoundWidget: const Center(child: Text('No hay registros agregados')),
        groupTitleBuilder: (title, groupBy, isPinned, _) => Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.all(8.0),
          child: Text(DateFormat('EEEE, d MMM y').format(groupBy), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ),
        itemBuilder: (item) => RegisterBookElement(item: item, isPreview: false),
      )
    );
  }
}