import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';

@freezed
class Student with _$Student {

  Student({
    this.id = '*',
    required this.name, required this.age,
    this.notes, DateTime? timestamp
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  final String id;

  @override
  final String name;

  @override
  final StudentAge age;

  @override
  final String? notes;

  @override
  final DateTime timestamp;

  @override
  int get hashCode => name.hashCode ^ age.hashCode;

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;
    return (other is Student) &&
    other.name == name && other.age == age && other.id == id;
  }  
}