import 'package:drift/drift.dart';
import 'package:nawiapp/domain/models/models_table/register_book_table.dart';

class HiddenRegisterBookTable extends Table {
  late final hiddenRegisterBookId = text().named('hidden_register_book_id').references(RegisterBookTable, #id)();

  @override
  String? get tableName => "hidden_register_book_table";
}