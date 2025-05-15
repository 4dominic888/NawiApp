import 'package:drift/drift.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom_status.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

@TableIndex(name: 'nameClassroomIndex', columns: {#name})
@TableIndex(name: 'statusClassroomIndex', columns: {#status})
@TableIndex(name: 'timestampClassroomIndex', columns: {#timestamp})
class ClassroomTable extends Table  {
  late final id = text().clientDefault(() => NawiGeneralUtils.uuid.v4())();
  late final name = text().withLength(min: 2, max: 50)();
  late final status = intEnum<ClassroomStatus>()();
  late final description = text().nullable()();
  late final Column<int> iconCode = integer().check(iconCode.isBiggerThanValue(0))();
  late final timestamp = dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {id};

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [{name}];

  @override
  String? get tableName => 'classroom';
}