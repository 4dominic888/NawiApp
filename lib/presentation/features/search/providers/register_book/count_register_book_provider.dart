import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/classes/stat_summary/register_book_stat.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';

final _auxRegisterBookProvider = FutureProvider.family.autoDispose<Stream<int>, (RegisterBookFilter, String?)>((ref, args) async {
  final service = GetIt.I<RegisterBookServiceBase>();
  return await service.getAllCount(args.$1.copyWith(classroomId: args.$2));
});

final countRegisterBookProvider = StreamProvider.family.autoDispose<int, (RegisterBookFilter, String?)>((ref, args) {
  final streamCountNotifier = ref.watch(_auxRegisterBookProvider(args));

  return streamCountNotifier.when(
    data: (data) => data,
    error: (_, __) => const Stream.empty(),
    loading: () => const Stream.empty()
  );
});

final registerBookStatProvider = StreamProvider.family.autoDispose<RegisterBookStat, String>((ref, classroomId) {
  final service = GetIt.I<RegisterBookServiceBase>();
  return service.getRegisterBookStat(classroomId);
});