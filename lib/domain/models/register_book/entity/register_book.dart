import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';

part 'register_book.freezed.dart';

@freezed
class RegisterBook with _$RegisterBook {

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

  RegisterBook({
    this.id = '*',
    required this.action, this.mentions = const [], this.classroomId = '*',
    this.type = RegisterBookType.register,
    required this.createdAt
  });
}