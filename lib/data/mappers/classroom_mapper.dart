import 'package:drift/drift.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';

extension ClassroomMapper on Classroom {
  static Classroom fromTableData(ClassroomTableData data) {
    return Classroom(id: data.id, name: data.name, iconCode: data.iconCode, createdAt: data.timestamp, status: data.status);
  }

  ClassroomTableData get toTableData => ClassroomTableData(
    id: id,
    name: name,
    status: status,
    iconCode: iconCode,
    timestamp: createdAt,
  );

  ClassroomTableCompanion toTableCompanion({bool withId = false}) => ClassroomTableCompanion(
    id: withId ? Value(id) : Value.absent(),
    name: Value(name),
    iconCode: Value(iconCode),
    status: Value(status),
    timestamp: Value(createdAt),
  );
}