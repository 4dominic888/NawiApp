import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/classes/student_filter.dart';

class StudentFilterNotifier extends StateNotifier<StudentFilter> {
  StudentFilterNotifier() : super(StudentFilter.none());
  
  void clear() => state = StudentFilter.none();
  void setConfig(StudentFilter data) => state = data;
}

final studentFilterProvider = StateProvider<StudentFilter>((ref) => StudentFilter.none());