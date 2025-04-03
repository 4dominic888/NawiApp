import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/domain/classes/register_book_filter.dart';
import 'package:nawiapp/domain/models/register_book.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/presentation/registration_book/view_registers_book/widgets/register_book_element.dart';

class ViewRegistersBookScreen extends StatefulWidget {
  const ViewRegistersBookScreen({super.key});

  @override
  State<ViewRegistersBookScreen> createState() => _ViewRegistersBookScreenState();
}

class _ViewRegistersBookScreenState extends State<ViewRegistersBookScreen> {

  final _registerBookService = GetIt.I<RegisterBookServiceBase>();
  final _pagingController = PagingController<int, RegisterBookDAO>(firstPageKey: 0);
  bool _isLoadingStarted = false;
  late final bool _paggingStatusCondition;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _paggingStatusCondition = (
          _pagingController.value.status == PagingStatus.loadingFirstPage ||
          _pagingController.value.status == PagingStatus.ongoing
    ) && _isLoadingStarted;

    _pagingController.addPageRequestListener((pageKey) {
      if(_paggingStatusCondition) return; 
      _isLoadingStarted = true;
      _fetchPage(pageKey);
    });    
  }

  Future<void> _fetchPage(int pageKey) async {
    final result = await _registerBookService.getAllPaginated(
      currentPage: pageKey,
      pageSize: _pageSize,
      params: RegisterBookFilter()
    );

    result.onValue(
      withPopup: false,
      onError: (_, message) => _pagingController.error = message,
      onSuccessfully: (data, message) {
        final items = data.data;
        if(items.length < _pageSize) { _pagingController.appendLastPage(items.toList()); }
        else { _pagingController.appendPage(items.toList(), pageKey+1); }
      }
    );
  }

  Future<void> _refresh() async {
    if(_paggingStatusCondition) return;
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {

    // final groupedList = groupBy(registersBook, (e) => DateTime((e["date"] as DateTime).year, (e["date"] as DateTime).month, (e["date"] as DateTime).day));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: PagedListView(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<RegisterBookDAO>(
              itemBuilder: (context, item, index) {
                final isFirstOnGroup = index == 0 || item.createdAt != _pagingController.itemList![index - 1].createdAt;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* Separador de dia
                    if(isFirstOnGroup) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(DateFormat('EEEE, d MMM y').format(item.createdAt), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    RegisterBookElement(data: item, index: index)
                  ],
                );
              },
              firstPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
              newPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
              noItemsFoundIndicatorBuilder: (_) => const Center(child: Text("No hay cuadernos de registros ingresados")),
              noMoreItemsIndicatorBuilder: (_) => const Center(child: Text("No más elementos a cargar")),
              firstPageErrorIndicatorBuilder: (_) => const Center(child: Text("Ha ocurrido un error al cargar la información")),
              newPageErrorIndicatorBuilder: (_) => const Center(child: Text("Ha ocurrido un error al cargar la información"))
            )
          )
        )
      ),
    );
  }
}