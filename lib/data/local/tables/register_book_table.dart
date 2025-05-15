import 'package:drift/drift.dart';
import 'package:nawiapp/data/local/tables/classroom_table.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

@TableIndex(name: 'created_at', columns: {#createdAt})
@TableIndex(name: 'type', columns: {#type})
class RegisterBookTable extends Table{
  late final id = text().clientDefault(() => NawiGeneralUtils.uuid.v4())();
  late final action = text().withLength(min: 2)();
  late final type = intEnum<RegisterBookType>()();
  late final notes = text().nullable()();
  late final createdAt = dateTime().named("created_at")();
  late final classroom = text().references(ClassroomTable, #id)();

  @override Set<Column<Object>>? get primaryKey => {id};

  @override String? get tableName => 'register_book';
}