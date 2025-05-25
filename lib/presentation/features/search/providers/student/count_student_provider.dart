import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';

final countStudentProvider = FutureProvider.family<int, StudentFilter>((ref, filter) async {
  final service = GetIt.I<StudentServiceBase>();
  final result = await service.getAllCount(filter);
  return result.getValue ?? 0;
});