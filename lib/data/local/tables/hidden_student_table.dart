import 'package:drift/drift.dart';
import 'package:nawiapp/data/local/tables/student_table.dart';

class HiddenStudentTable extends Table  {
  late final hiddenId = text().named('hidden_id').references(StudentTable, #id, onDelete: KeyAction.cascade)();

  @override
  String? get tableName => "hidden_student_table";
}