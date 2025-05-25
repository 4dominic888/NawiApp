import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';

final _auxRegisterBookProvider = FutureProvider.family.autoDispose<Stream<int>, String>((ref, classroomId) async {
  final service = GetIt.I<RegisterBookServiceBase>();
  return await service.getAllCount(RegisterBookFilter(
    classroomId: classroomId
  ));
});

final countRegisterBookProvider = StreamProvider.family.autoDispose<int, String>((ref, classroomId) {
  final streamCountNotifier = ref.watch(_auxRegisterBookProvider(classroomId));

  return streamCountNotifier.when(
    data: (data) => data,
    error: (_, __) => const Stream.empty(),
    loading: () => const Stream.empty()
  );
});