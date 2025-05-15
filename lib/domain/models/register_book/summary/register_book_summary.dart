import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';

part 'register_book_summary.freezed.dart';

@freezed
class RegisterBookSummary with _$RegisterBookSummary {
  @override
  final String id;

  @override
  final DateTime createdAt;

  @override
  final RegisterBookType type;

  @override
  final Iterable<StudentSummary> mentions;

  @override
  final String action;

  @override
  final String classroomId;
  
  const RegisterBookSummary({
    required this.id, required this.action,
    required this.createdAt,
    required this.type, required this.mentions,
    this.classroomId = '*'
  });
}
