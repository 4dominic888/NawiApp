import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_summary.freezed.dart';

@freezed
class StudentSummary with _$StudentSummary{
  
  @override
  final String id;

  @override
  final String name;

  @override
  final StudentAge age;

  const StudentSummary({required this.id, required this.name, required this.age, this.classroomId = '*'});

  @override
  int get hashCode => name.hashCode ^ age.hashCode;

  @override
  final String classroomId;  

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;
    return (other is StudentSummary) &&
    other.name == name && other.age == age && other.id == id;
  }  
}
