import 'package:drift/drift.dart';
import 'package:nawiapp/domain/models/models_table/register_book_table.dart';
import 'package:nawiapp/domain/models/models_table/student_table.dart';

//* Many to many
class StudentRegisterBookTable extends Table {

  late final student = text().references(StudentTable, #id)();
  late final registerBook = text().named('register_book').references(RegisterBookTable, #id)();

  @override
  String? get tableName => "student_register_book";  
}