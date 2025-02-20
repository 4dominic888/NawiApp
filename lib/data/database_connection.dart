import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:nawiapp/domain/models_table/register_book_table.dart';
import 'package:nawiapp/domain/models_table/student_register_book_table.dart';
import 'package:nawiapp/domain/models_table/student_table.dart';
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
    final file = File(p.join(folder.path, 'db.sqlite'));

    if(Platform.isAndroid) await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

    sqlite3.tempDirectory = (await getTemporaryDirectory()).path;
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [StudentTable, RegisterBookTable, StudentRegisterBookTable])
class NawiDatabase extends _$NawiDatabase {
  NawiDatabase() : super(_openConnection());
  
  @override
  int get schemaVersion => 1;
  
  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}