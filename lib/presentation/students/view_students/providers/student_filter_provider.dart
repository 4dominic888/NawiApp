import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';

class StudentFilterNotifier extends StateNotifier<StudentFilter> {
  StudentFilterNotifier() : super(StudentFilter());
  
  void clear() => state = StudentFilter();
  void setConfig(StudentFilter data) => state = data;
}

final deprecatedStudentFilterProvider = StateProvider<StudentFilter>((ref) => StudentFilter());