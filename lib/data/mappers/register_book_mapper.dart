import 'package:drift/drift.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/utils/mapper_utils.dart';

extension RegisterBookMapper on RegisterBook {
  static RegisterBook fromTableData(RegisterBookTableData data, Iterable<StudentSummary> mentions) => RegisterBook(
    id: data.id,
    action: data.action,
    mentions: mentions,
    notes: data.notes,
    timestamp: data.createdAt,
    type: data.type
  );

  static RegisterBook empty() => RegisterBook(action: "");

  RegisterBookTableData get toTable => RegisterBookTableData(
    id: id,
    action: action,
    type: type,
    createdAt: createdAt,
    notes: notes
  );

  RegisterBookTableCompanion toTableCompanion({bool withId = false}) => RegisterBookTableCompanion(
    id: withId ? Value(id) : Value.absent(),
    action: Value(action),
    createdAt: Value(createdAt),
    notes: Value(notes),
    type: Value(type)
  );

  String get actionUnslug => MapperUtils.toSlug(action);
}



extension RegisterBookSummaryMapper on RegisterBookSummary {
  String get actionUnslug => MapperUtils.toSlug(action);

  static RegisterBookSummary fromSummaryView({required RegisterBookViewSummaryVersionData data, required Iterable<StudentSummary> mentions}) => 
    RegisterBookSummary(
      id: data.id,
      action: data.action,
      createdAt: data.createdAt,
      hourCreatedAt: data.hourCreatedAt ?? "hour error",
      type: data.type,
      mentions: mentions
    );  
}