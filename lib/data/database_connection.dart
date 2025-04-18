import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:nawiapp/domain/models/models_table/hidden_register_book_table.dart';
import 'package:nawiapp/domain/models/models_table/hidden_student_table.dart';
import 'package:nawiapp/domain/models/models_table/register_book_table.dart';
import 'package:nawiapp/domain/models/models_table/student_register_book_table.dart';
import 'package:nawiapp/domain/models/models_table/student_table.dart';
import 'package:nawiapp/domain/models/models_views/register_book_view.dart';
import 'package:nawiapp/domain/models/models_views/student_view.dart';
import 'package:nawiapp/domain/repositories/register_book_repository.dart';
import 'package:nawiapp/domain/repositories/student_register_book_repository.dart';
import 'package:nawiapp/domain/repositories/student_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

//* Important dependecies for database_connection.g.dart
import 'package:nawiapp/infrastructure/nawi_utils.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/domain/models/register_book.dart';

part 'database_connection.g.dart';

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
  views: [StudentViewDAOVersion, HiddenStudentViewDAOVersion, RegisterBookViewDAOVersion, HiddenRegisterBookViewDAOVersion]
)
class NawiDatabase extends _$NawiDatabase {
  NawiDatabase([QueryExecutor? e]) : super(e ?? _openConnection());
  
  @override
  int get schemaVersion => 1;
  
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => await m.createAll(),
    // onUpgrade: stepByStep(
    //   from2To3: (m, schema) async => await m.createView(hiddenStudentViewDAOVersion),
    // ),
    // onUpgrade: (m, from, to) async {
    //   if(from < 2) await m.createTable(hiddenStudentTable);
    //   if(from < 3) await m.createView(hiddenStudentViewDAOVersion);
    // },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}