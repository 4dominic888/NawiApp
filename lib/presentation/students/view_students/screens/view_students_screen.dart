import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/presentation/students/view_students/widgets/student_element.dart';

//* lista de datos de prueba

class ViewStudentsScreen extends StatefulWidget {
  const ViewStudentsScreen({super.key});

  @override
  State<ViewStudentsScreen> createState() => _ViewStudentsScreenState();
}

class _ViewStudentsScreenState extends State<ViewStudentsScreen> {

  final _studentService = GetIt.I<StudentServiceBase>();
  final _pagingController = PagingController<int, StudentDAO>(firstPageKey: 0);
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
  }

  Future<void> _fetchPage(int pageKey) async {
    final result = await _studentService.getAllPaginated(curretPage: pageKey, pageSize: _pageSize, params: {}).first;

    result.onValue(
      onError: (_, message) => _pagingController.error = message,
      onSuccessfully: (data, message) {
        final items = data.data;
        if(items.length < _pageSize) { _pagingController.appendLastPage(items); }
        else { _pagingController.appendPage(items, pageKey+1); }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _pagingController.value = PagingState();
          _pagingController.refresh();
          await _fetchPage(0);
        },
        child: PagedListView(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<StudentDAO>(
            itemBuilder: (context, item, index) => StudentElement(context: context, item: item, index: index),
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