import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/classes/stat_summary/student_stat.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';

final countStudentProvider = StreamProvider.family.autoDispose<int, (StudentFilter, String?)>((ref, args) {
  final service = GetIt.I<StudentServiceBase>();
  return service.getAllCount(args.$1.copyWith(classroomId: args.$2));
});

final studentStatProvider = StreamProvider.family.autoDispose<StudentStat, String>((ref, classroomId) {
  final service = GetIt.I<StudentServiceBase>();
  return service.getStudentStat(classroomId);
});