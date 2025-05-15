import 'package:drift/drift.dart';
import 'package:nawiapp/data/local/tables/classroom_table.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

@TableIndex(name: 'name', columns: {#name})
@TableIndex(name: 'age', columns: {#age})
@TableIndex(name: 'timestamp', columns: {#timestamp})
class StudentTable extends Table {
  late final id = text().clientDefault(() => NawiGeneralUtils.uuid.v4())();
  late final name = text().withLength(min: 2, max: 50)();
  late final age = intEnum<StudentAge>()();
  late final notes = text().nullable()();
  late final timestamp = dateTime()();
  late final classroom = text().references(ClassroomTable, #id)();

  @override
  Set<Column<Object>>? get primaryKey => {id};

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [{name, age}];

  @override
  String? get tableName => 'student';
}