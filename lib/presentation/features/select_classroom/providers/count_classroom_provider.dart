import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/filter/classroom_filter.dart';
import 'package:nawiapp/domain/services/classroom_service_base.dart';

final countClassroomProvider = StreamProvider.family.autoDispose<int, ClassroomFilter>((ref, filter) {
  final service = GetIt.I<ClassroomServiceBase>();
  return service.getAllCount(filter);
});