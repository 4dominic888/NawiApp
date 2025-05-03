import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_grouped_list/infinite_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/presentation/features/search/providers/register_book/search_register_book_list_provider.dart';
import 'package:nawiapp/presentation/widgets/another_register_book_element.dart';

class ViewRegistersBookScreen extends ConsumerStatefulWidget {
  const ViewRegistersBookScreen({super.key});

  @override
  ConsumerState<ViewRegistersBookScreen> createState() => _ViewRegistersBookScreenState();
}

class _ViewRegistersBookScreenState extends ConsumerState<ViewRegistersBookScreen> {

  final _paggingController = InfiniteGroupedListController<RegisterBookSummary, DateTime, String>(limit: 5);

  @override
  Widget build(BuildContext context) {
    // quitPopup() { if(context.mounted) Navigator.of(context).pop(); _paggingController.refresh(); }
    final notifier = ref.read(registerBookSummarySearchProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: InfiniteGroupedList(
          groupBy: (item) => item.createdAt,
          controller: _paggingController,
          sortGroupBy: (item) => item.createdAt,
          initialItemsErrorWidget: (error) => Text(error.toString()),
          groupTitleBuilder: (title, groupBy, isPinned, _) => Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(8.0),
            child: Text(DateFormat('EEEE, d MMM y').format(groupBy), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
          ),
          itemBuilder: (item) => AnotherRegisterBookElement(
            isPreview: false,
            item: item
          ),
          // itemBuilder: (item) => RegisterBookElement(
          //   item: item,
          //   delete: defaulVoidResultAction(
          //     result: (() => _registerBookService.deleteOne(item.id)),
          //     buttonController: _btnDeleteElementController,
          //     onAction: quitPopup
          //   ),
          //   archive: defaulVoidResultAction(
          //     result: (() => _registerBookService.archiveOne(item.id)),
          //     buttonController: _btnArchiveElementController,
          //     onAction: quitPopup
          //   ),
          //   unarchive: defaulVoidResultAction(
          //     result: (() => _registerBookService.unarchiveOne(item.id)),
          //     buttonController: _btnUnarchiveElementController,
          //     onAction: quitPopup
          //   ),
          // ),
          onLoadMore: notifier.fetchPage,
          groupCreator: (date) => '${date.year}-${date.month}-${date.day}',
          loadingWidget: const Center(child: CircularProgressIndicator()),
          showRefreshIndicator: true,
          stickyGroups: false,
          noItemsFoundWidget: const Center(child: Text('No hay registros agregados'))
        )
      ),
    );
  }
}