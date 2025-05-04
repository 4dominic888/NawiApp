import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:nawiapp/data/local/tables/hidden_register_book_table.dart';
import 'package:nawiapp/data/local/tables/hidden_student_table.dart';
import 'package:nawiapp/data/local/tables/register_book_table.dart';
import 'package:nawiapp/data/local/tables/student_register_book_table.dart';
import 'package:nawiapp/data/local/tables/student_table.dart';
import 'package:nawiapp/data/local/views/register_book_view.dart';
import 'package:nawiapp/data/local/views/student_view.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/domain/daos/register_book_dao.dart';
import 'package:nawiapp/domain/daos/student_register_book_dao.dart';
import 'package:nawiapp/domain/daos/student_dao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

//* Important dependecies for database_connection.g.dart
import 'package:nawiapp/utils/nawi_general_utils.dart';

part 'drift_connection.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final folder = await getApplicationDocumentsDirectory();
    final file = File(p.join(folder.path, 'nawidb.sqlite'));

    // if(await file.exists()) await file.delete();; //! Resetea la base de datos

    if(Platform.isAndroid) await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

    sqlite3.tempDirectory = (await getTemporaryDirectory()).path;
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(
  tables: [StudentTable, RegisterBookTable, StudentRegisterBookTable, HiddenStudentTable, HiddenRegisterBookTable],
  daos: [StudentRepository, RegisterBookRepository, StudentRegisterBookRepository],
  views: [StudentViewSummaryVersion, HiddenStudentViewSummaryVersion, RegisterBookViewSummaryVersion, HiddenRegisterBookViewSummaryVersion]
)
class NawiDatabase extends _$NawiDatabase {
  NawiDatabase([QueryExecutor? e]) : super(e ?? _openConnection());
  
  @override
  int get schemaVersion => 1;
  
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => await m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}