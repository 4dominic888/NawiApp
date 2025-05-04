import 'package:drift/drift.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

@TableIndex(name: 'name', columns: {#name})
@TableIndex(name: 'age', columns: {#age})
@TableIndex(name: 'timestamp', columns: {#timestamp})
class StudentTable extends Table {
  late final id = text().clientDefault(() => NawiGeneralUtils.uuid.v4())();
  late final name = text().unique().withLength(min: 2, max: 50)();
  late final age = intEnum<StudentAge>()();
  late final notes = text().nullable()();
  late final timestamp = dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {id};

  @override
  String? get tableName => 'student';
}