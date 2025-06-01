import 'package:drift/drift.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';

extension RegisterBookMapper on RegisterBook {
  static RegisterBook fromTableData(RegisterBookTableData data, Iterable<StudentSummary> mentions) => RegisterBook(
    id: data.id,
    action: data.action,
    mentions: mentions,
    createdAt: data.createdAt,
    type: data.type,
    classroomId: data.classroom
  );

  static RegisterBook empty() => RegisterBook(action: "", createdAt: DateTime.now());

  RegisterBookTableData get toTable => RegisterBookTableData(
    id: id,
    action: action,
    type: type,
    createdAt: createdAt,
    classroom: classroomId
  );

  RegisterBookTableCompanion toTableCompanion({bool withId = false}) => RegisterBookTableCompanion(
    id: withId ? Value(id) : Value.absent(),
    action: Value(action),
    createdAt: Value(createdAt),
    type: Value(type),
    classroom: Value(classroomId)
  );
}

extension RegisterBookSummaryMapper on RegisterBookSummary {
  static RegisterBookSummary fromSummaryView({required RegisterBookViewSummaryVersionData data, required Iterable<StudentSummary> mentions}) => 
    RegisterBookSummary(
      id: data.id,
      action: data.action,
      createdAt: data.createdAt,
      type: data.type,
      mentions: mentions,
      classroomId: data.classroom
    );  
}