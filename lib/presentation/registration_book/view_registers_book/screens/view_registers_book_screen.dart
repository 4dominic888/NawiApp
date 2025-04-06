import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_grouped_list/infinite_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/domain/classes/register_book_filter.dart';
import 'package:nawiapp/domain/models/register_book.dart';
import 'package:nawiapp/domain/records/button_controller_with_process.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/presentation/registration_book/view_registers_book/widgets/register_book_element.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class ViewRegistersBookScreen extends StatefulWidget {
  const ViewRegistersBookScreen({super.key});

  @override
  State<ViewRegistersBookScreen> createState() => _ViewRegistersBookScreenState();
}

class _ViewRegistersBookScreenState extends State<ViewRegistersBookScreen> {

  final _registerBookService = GetIt.I<RegisterBookServiceBase>();
  final _paggingController = InfiniteGroupedListController<RegisterBookDAO, DateTime, String>(limit: 5);
  final _btnDeleteElementController = RoundedLoadingButtonController();
  final _btnArchiveElementController = RoundedLoadingButtonController();
  final _btnUnarchiveElementController = RoundedLoadingButtonController();

  Future<List<RegisterBookDAO>> _fetchPage(PaginationInfo paginationInfo) async {
    final result = await _registerBookService.getAllPaginated(
      currentPage: paginationInfo.page,
      pageSize: paginationInfo.limit,
      params: RegisterBookFilter()
    );

    return result.getValue?.data.toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    quitPopup() { if(context.mounted) Navigator.of(context).pop(); _paggingController.refresh(); }

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
          itemBuilder: (item) => RegisterBookElement(
            item: item,
            delete: defaulVoidResultAction(
              result: (() => _registerBookService.deleteOne(item.id)),
              buttonController: _btnDeleteElementController,
              onAction: quitPopup
            ),
            archive: defaulVoidResultAction(
              result: (() => _registerBookService.archiveOne(item.id)),
              buttonController: _btnArchiveElementController,
              onAction: quitPopup
            ),
            unarchive: defaulVoidResultAction(
              result: (() => _registerBookService.unarchiveOne(item.id)),
              buttonController: _btnUnarchiveElementController,
              onAction: quitPopup
            ),
          ),
          onLoadMore: _fetchPage,
          groupCreator: (date) => '${date.year}-${date.month}-${date.day}',
          loadingWidget: const Center(child: CircularProgressIndicator()),
          showRefreshIndicator: true,
          stickyGroups: false,
        )
      ),
    );
  }
}