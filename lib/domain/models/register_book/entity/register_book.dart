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
  final String? notes;

  @override
  final Iterable<StudentSummary> mentions;

  @override
  final String action;

  RegisterBook({
    this.id = '*',
    required this.action, this.mentions = const [],
    this.type = RegisterBookType.register, this.notes,
    DateTime? timestamp
  }) : createdAt = timestamp ?? DateTime.now();
}