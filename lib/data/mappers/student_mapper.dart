import 'package:drift/drift.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/utils/nawi_mapper_utils.dart';

extension StudentMapper on Student {
  static Student fromTableData(StudentTableData data) {
    return Student(id: data.id, name: data.name,age: data.age, timestamp: data.timestamp, classroomId: data.classroom);
  }

  StudentSummary get toStudentSummary => StudentSummary(id: id, name: name, age: age);  

  String get mentionLabel => MapperUtils.mentionLabel(name);

  StudentTableData get toTableData => StudentTableData(
    id: id,
    name: name,
    age: age,
    timestamp: timestamp,
    classroom: classroomId
  );

  StudentTableCompanion toTableCompanion({bool withId = false}) => StudentTableCompanion(
    id: withId ? Value(id) : Value.absent(),
    age: Value(age),
    name: Value(name),
    timestamp: Value(timestamp),
    classroom: Value(classroomId)
  );

  String get initalsName => MapperUtils.initialName(name);
}



extension StudentSummaryMapper on StudentSummary {

  static StudentSummary fromSummaryView(StudentViewSummaryVersionData data) => StudentSummary(id: data.id, name: data.name, age: data.age, classroomId: data.classroom);

  String get mentionLabel => MapperUtils.mentionLabel(name);
  
  String get initalsName => MapperUtils.initialName(name);
}