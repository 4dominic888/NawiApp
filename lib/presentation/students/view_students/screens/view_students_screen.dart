import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/infrastructure/providers/filter_provider.dart';
import 'package:nawiapp/presentation/students/view_students/widgets/student_element.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

//* lista de datos de prueba

class ViewStudentsScreen extends ConsumerStatefulWidget {
  const ViewStudentsScreen({super.key});

  @override
  ConsumerState<ViewStudentsScreen> createState() => _ViewStudentsScreenState();
}

class _ViewStudentsScreenState extends ConsumerState<ViewStudentsScreen> {

  final _studentService = GetIt.I<StudentServiceBase>();
  final _pagingController = PagingController<int, StudentDAO>(firstPageKey: 0);
  final _btnDeleteElementController = RoundedLoadingButtonController();
  final _btnArchiveElementController = RoundedLoadingButtonController();
  final _btnUnarchiveElementController = RoundedLoadingButtonController();

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
    final result = await _studentService.getAllPaginated(
      currentPage: pageKey,
      pageSize: _pageSize,
      params: ref.read(studentFilterProvider)
    );

    result.onValue(
      withPopup: false,
      onError: (_, message) => _pagingController.error = message,
      onSuccessfully: (data, message) {
        final items = data.data;
        if(items.length < _pageSize) { _pagingController.appendLastPage(items.toList()); }
        else { _pagingController.appendPage(items.toList(), pageKey+1); }
      },
    );
  }

  Future<void> _refresh() async {
    if(_paggingStatusCondition) return;
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: PagedListView(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<StudentDAO>(
            itemBuilder: (_, item, index) => StudentElement(
              item: item,
              index: index,
              isArchived: ref.watch(studentFilterProvider).showHidden,
              delete: (
                controller: _btnDeleteElementController,
                action: () async {
                  _btnDeleteElementController.start();
                  final result = await _studentService.deleteOne(item.id);
                  result.onValue(
                    onSuccessfully: (data, message) => _btnDeleteElementController.success(),
                    onError: (error, message) => _btnDeleteElementController.error(),
                    withPopup: false
                  );
                  if(context.mounted) Navigator.of(context).pop();
                  _refresh();
                }
              ),
              archive: (
                controller: _btnArchiveElementController,
                action: () async {
                  _btnArchiveElementController.start();
                  final result = await _studentService.archiveOne(item.id);
                  result.onValue(
                    onSuccessfully: (data, message) => _btnArchiveElementController.success(),
                    onError: (error, message) => _btnArchiveElementController.error()
                  );
                  if(context.mounted) Navigator.of(context).pop();
                  _refresh();
                }
              ),
              unarchive: (
                controller: _btnUnarchiveElementController,
                action: () async {
                  _btnUnarchiveElementController.start();
                  final result = await _studentService.unarchiveOne(item.id);
                  result.onValue(
                    onSuccessfully: (data, message) => _btnUnarchiveElementController.success(),
                    onError: (error, message) => _btnUnarchiveElementController.error()
                  );
                  if(context.mounted) Navigator.of(context).pop();
                  _refresh();
                }
              ),
            ),
            firstPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
            newPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
            noItemsFoundIndicatorBuilder: (_) => const Center(child: Text("No hay estudiantes registrados")),
            noMoreItemsIndicatorBuilder: (_) => const Center(child: Text("No más estudiantes a cargar")),
            firstPageErrorIndicatorBuilder: (_) => const Center(child: Text("Ha ocurrido un error al cargar la información")),
            newPageErrorIndicatorBuilder: (_) => const Center(child: Text("Ha ocurrido un error al cargar la información"))
          )
        )
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}