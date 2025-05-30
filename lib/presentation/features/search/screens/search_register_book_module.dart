import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_grouped_list/infinite_grouped_list.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/infrastructure/export/export_report_manager.dart';
import 'package:nawiapp/infrastructure/export/register_book_export.dart';
import 'package:nawiapp/infrastructure/in_memory_storage.dart';
import 'package:nawiapp/presentation/features/export/providers/initial_pdf_bytes_data_provider.dart';
import 'package:nawiapp/presentation/features/home/extra/menu_tabs.dart';
import 'package:nawiapp/presentation/features/home/providers/tab_index_provider.dart';
import 'package:nawiapp/presentation/features/home/providers/general_loading_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/register_book/count_register_book_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/register_book/search_register_book_list_provider.dart';
import 'package:nawiapp/presentation/features/search/screens/modals/advanced_register_book_filter_modal.dart';
import 'package:nawiapp/presentation/widgets/notification_message.dart';
import 'package:nawiapp/presentation/widgets/register_book_element.dart';
import 'package:nawiapp/presentation/features/search/widgets/search_filter_field.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

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
    final registerBookCountNotifier = ref.watch(
      countRegisterBookProvider((filterWatcher, GetIt.I<InMemoryStorage>().currentClassroom?.id))
    );

    return Scaffold(
      appBar: SearchFilterField(
        hintTextField: 'Acción',
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
            onPressed: registerBookCountNotifier.when(
              data: (data) => data == 0,
              error: (_, __) => true,
              loading: () => true
            ) ? null : () async {
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
                    child: const Text('Por estudiante'),
                  )
                ]
              );
    
              if(optionToExport != null) {
                final documentResult = await optionToExport.generate(filterNotifier.state.withouPagination);
    
                documentResult.onValue(
                  withPopup: false,
                  onError: (error, message) => NotificationMessage.showErrorNotification(message),
                  onSuccessfully: (data, message) async {
                    //* Provider de cargado
                    final loading = ref.read(generalLoadingProvider.notifier);
                    loading.state = true;
    
                    //* Cargando PDF a exportar en memoria
                    final pdfData = await optionToExport.getBytes(data);
                    ref.read(initialPdfBytesDataProvider.notifier).state = pdfData;
                    loading.state = false;
    
                    //* Diriengose al tab de exportar
                    ref.read(tabMenuProvider.notifier).goTo(NawiMenuTabs.export);
                  },
                );
    
              }
            },
          ),
        ]
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Cantidad de registros: ${registerBookCountNotifier.when(
              data: (count) => count.toString(),
              error: (error, stack) => 'Error al cargar',
              loading: () => 'Cargando...'
            )}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: InfiniteGroupedList(
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
                  child: Text(NawiGeneralUtils.getFormattedDate(groupBy), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                ),
                itemBuilder: (item) => RegisterBookElement(item: item, isPreview: false),
              ),
            ),
          ),
        ],
      )
    );
  }
}