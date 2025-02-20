import 'package:drift/drift.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';

@TableIndex(name: 'name', columns: {#name})
@TableIndex(name: 'age', columns: {#age})
@TableIndex(name: 'timestamp', columns: {#timestamp})
class StudentTable extends Table {
  late final id = text().clientDefault(() => NawiTools.uuid.v4())();
  late final name = text().withLength(min: 2, max: 50)();
  late final age = intEnum<StudentAge>()();
  late final notes = text().nullable()();
  late final timestamp = dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {id};

  @override
  String? get tableName => 'student';
}