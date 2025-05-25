import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';

final countStudentProvider = StreamProvider.family.autoDispose<int, String>((ref, classroomId) {
  final service = GetIt.I<StudentServiceBase>();
  return service.getAllCount(StudentFilter(
    classroomId: classroomId
  ));
});