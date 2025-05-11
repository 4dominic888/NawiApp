import 'package:drift/drift.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/utils/nawi_mapper_utils.dart';

extension StudentMapper on Student {
  static Student fromTableData(StudentTableData data) {
    return Student(id: data.id, name: data.name,age: data.age, notes: data.notes, timestamp: data.timestamp);
  }

  StudentSummary get toStudentSummary => StudentSummary(id: id, name: name, age: age);  

  String get mentionLabel => MapperUtils.mentionLabel(name);

  StudentTableData get toTableData => StudentTableData(
    id: id,
    name: name,
    age: age,
    timestamp: timestamp,
    notes: notes
  );

  StudentTableCompanion toTableCompanion({bool withId = false}) => StudentTableCompanion(
    id: withId ? Value(id) : Value.absent(),
    age: Value(age),
    name: Value(name),
    notes: Value(notes),
    timestamp: Value(timestamp)
  );

  String get initalsName => MapperUtils.initialName(name);
}



extension StudentSummaryMapper on StudentSummary {

  static StudentSummary fromSummaryView(StudentViewSummaryVersionData data) => StudentSummary(id: data.id, name: data.name, age: data.age);

  String get mentionLabel => MapperUtils.mentionLabel(name);
  
  String get initalsName => MapperUtils.initialName(name);
}