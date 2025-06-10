import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';

@freezed
class Student with _$Student {

  Student({
    this.id = '*',
    required this.name, required this.age,
    this.classroomId = '*', DateTime? timestamp
  }) : timestamp = timestamp ?? DateTime.now();

  Student.empty() : this(name: '', age: StudentAge.threeYears);

  @override
  final String id;

  @override
  final String name;

  @override
  final StudentAge age;

  @override
  final DateTime timestamp;

  @override
  final String classroomId;

  @override
  int get hashCode => name.hashCode ^ age.hashCode ^ classroomId.hashCode;

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;
    return (other is Student) &&
    other.name == name && other.age == age && other.id == id && other.classroomId == classroomId;
  }  
}