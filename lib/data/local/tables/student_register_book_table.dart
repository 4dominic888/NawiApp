import 'package:drift/drift.dart';
import 'package:nawiapp/data/local/tables/register_book_table.dart';
import 'package:nawiapp/data/local/tables/student_table.dart';

//* Many to many
class StudentRegisterBookTable extends Table {

  late final student = text().references(StudentTable, #id, onDelete: KeyAction.cascade)();
  late final registerBook = text().named('register_book').references(RegisterBookTable, #id, onDelete: KeyAction.cascade)();

  @override
  String? get tableName => "student_register_book";  
}