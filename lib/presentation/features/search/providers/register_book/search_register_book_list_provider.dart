import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_grouped_list/infinite_grouped_list.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';

final registerBookFilterProvider = StateProvider<RegisterBookFilter>((ref) => RegisterBookFilter());

final registerBookSummarySearchProvider = NotifierProvider<RegisterBookSummarySearchNotifier, int>(() {
  return RegisterBookSummarySearchNotifier();
});

class RegisterBookSummarySearchNotifier extends Notifier<int> {

  final service = GetIt.I<RegisterBookServiceBase>();
  final controller = InfiniteGroupedListController<RegisterBookSummary, DateTime, String>(limit: 5);

  Timer? _timer;

  @override
  int build() {
    _timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      final currentCount = controller.getItems().length;
      if (state != currentCount) {
        state = currentCount;
      }
    });
    ref.onDispose(() => _timer?.cancel());
    return 0;
  }

  Future<List<RegisterBookSummary>> fetchPage(PaginationInfo paginationInfo) async {
    final paginatedResult = await service.getAllPaginated(
      pageSize: paginationInfo.limit,
      currentPage: paginationInfo.page,
      params: ref.read(registerBookFilterProvider)
    );

    state = controller.getItems().length;
    return paginatedResult.getValue?.data.toList() ?? [];
  }

  Future<void> refresh() => controller.refresh();
}