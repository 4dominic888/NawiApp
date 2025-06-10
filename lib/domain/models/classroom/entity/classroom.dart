import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom_status.dart';

part 'classroom.freezed.dart';

@freezed
class Classroom with _$Classroom {
  
  @override
  final String id;

  @override
  final String name;

  @override
  final ClassroomStatus status;

  @override 
  final int iconCode;

  @override
  final DateTime createdAt;

  Classroom({
    this.id = '*',
    required this.name,
    this.status = ClassroomStatus.notStarted,
    this.iconCode = 0xe559,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Classroom.empty() : this(name: '');

  @override
  int get hashCode => name.hashCode ^ iconCode.hashCode;

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;
    return (other is Classroom) && other.name == name && iconCode == iconCode;
  }
}