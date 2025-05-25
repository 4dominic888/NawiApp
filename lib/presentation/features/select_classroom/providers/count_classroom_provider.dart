import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/filter/classroom_filter.dart';
import 'package:nawiapp/domain/services/classroom_service_base.dart';

final countClassroomProvider = FutureProvider.family<int, ClassroomFilter>((ref, filter) async {
  final service = GetIt.I<ClassroomServiceBase>();
  final result = await service.getAllCount(filter);
  return result.getValue ?? 0;
});