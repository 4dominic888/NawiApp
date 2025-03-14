import 'package:drift/drift.dart';
import 'package:nawiapp/domain/models/models_table/student_table.dart';

class HiddenStudentTable extends Table  {
  late final hiddenId = text().named('hidden_id').references(StudentTable, #id)();

  @override
  String? get tableName => "hidden_student_table";
}