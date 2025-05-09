import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';

final studentFilterProvider = StateProvider<StudentFilter>((ref) => StudentFilter());

final studentSummarySearchProvider = NotifierProvider<StudentSummarySearchNotifier, void>(() {
  return StudentSummarySearchNotifier();
});

class StudentSummarySearchNotifier extends Notifier<void> {
  late final PagingController<int, StudentSummary> pagingController;
  static const int pageSize = 8;

  bool _isLoadingStarted = false;
  late final bool _paggingStatusCondition;

  final service = GetIt.I<StudentServiceBase>();

  @override
  void build() {
    pagingController = PagingController(firstPageKey: 1);

    _paggingStatusCondition = (
          pagingController.value.status == PagingStatus.loadingFirstPage ||
          pagingController.value.status == PagingStatus.ongoing
    ) && _isLoadingStarted;

    pagingController.addPageRequestListener((pageKey) {
      if(_paggingStatusCondition) return; 
      _isLoadingStarted = true;
      _fetchPage(pageKey);
    });    
  }

  StudentSummarySearchNotifier();

  Future<void> _fetchPage(int pageKey) async {
    final filter = ref.read(studentFilterProvider);
    final result = await service.getAllPaginated(pageSize: pageSize, currentPage: pageKey, params: filter);

    result.onValue(
      withPopup: false,
      onError: (_, message) => pagingController.error = message,
      onSuccessfully: (data, message) {
        final items = data.data;
        if(items.length < pageSize) { pagingController.appendLastPage(items.toList()); }
        else { pagingController.appendPage(items.toList(), pageKey + 1); }
      }
    );
  }

  Future<void> refresh() async {
    if(_paggingStatusCondition) return;
    pagingController.refresh();
  }

  void dispose() {
    pagingController.dispose();
  }

}