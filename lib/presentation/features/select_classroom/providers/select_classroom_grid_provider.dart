import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nawiapp/domain/classes/filter/classroom_filter.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';
import 'package:nawiapp/domain/services/classroom_service_base.dart';

final classroomFilterProvider = StateProvider<ClassroomFilter>((ref) => ClassroomFilter());

final classroomSearchProvider = NotifierProvider<ClassroomSearchNotifier, void>(() => ClassroomSearchNotifier());

class ClassroomSearchNotifier extends Notifier<void> {
  late final PagingController<int, Classroom> pagingController;
  static const int pageSize = 16;

  bool _isLoadingStarted = false;
  late final bool _pagingStatusCondition;

  final service = GetIt.I<ClassroomServiceBase>();

  @override
  void build() {
    pagingController = PagingController(firstPageKey: 1);

    _pagingStatusCondition = (
        pagingController.value.status == PagingStatus.loadingFirstPage ||
        pagingController.value.status == PagingStatus.ongoing
    ) && _isLoadingStarted;

    pagingController.addPageRequestListener((pageKey) {
      if(_pagingStatusCondition) return;
      _isLoadingStarted = true;
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    final filter = ref.read(classroomFilterProvider);
    final result = await service.getAllPaginated(pageSize: pageSize, currentPage: pageKey, params: filter);

    result.onValue(
      withPopup: false,
      onError: (_, message) => pagingController.error = message,
      onSuccessfully: (data, message) {
        final items = data.data;
        if(items.length < pageSize) { pagingController.appendLastPage(items.toList()); }
        else { pagingController.appendPage(items.toList(), pageKey); }
      },
    );
  }

  Future<void> refresh() async {
    if(_pagingStatusCondition) return;
    pagingController.refresh();
  }

  void dispose() => pagingController.dispose();
}