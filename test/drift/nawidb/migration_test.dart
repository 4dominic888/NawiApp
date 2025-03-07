// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:nawiapp/data/database_connection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'generated/schema.dart';

import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = NawiDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  // The following template shows how to write tests ensuring your migrations
  // preserve existing data.
  // Testing this can be useful for migrations that change existing columns
  // (e.g. by alterating their type or constraints). Migrations that only add
  // tables or columns typically don't need these advanced tests. For more
  // information, see https://drift.simonbinder.eu/migrations/tests/#verifying-data-integrity
  // TODO: This generated template shows how these tests could be written. Adopt
  // it to your own needs when testing migrations with data integrity.
  test('migration from v2 to v3 does not corrupt data', () async {
    // Add data to insert into the old database, and the expected rows after the
    // migration.
    // TODO: Fill these lists
    final oldStudentData = <v2.StudentData>[];
    final expectedNewStudentData = <v3.StudentData>[];

    final oldRegisterBookData = <v2.RegisterBookData>[];
    final expectedNewRegisterBookData = <v3.RegisterBookData>[];

    final oldStudentRegisterBookData = <v2.StudentRegisterBookData>[];
    final expectedNewStudentRegisterBookData = <v3.StudentRegisterBookData>[];

    final oldHiddenStudentTableData = <v2.HiddenStudentTableData>[];
    final expectedNewHiddenStudentTableData = <v3.HiddenStudentTableData>[];

    await verifier.testWithDataIntegrity(
      oldVersion: 2,
      newVersion: 3,
      createOld: v2.DatabaseAtV2.new,
      createNew: v3.DatabaseAtV3.new,
      openTestedDatabase: NawiDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.student, oldStudentData);
        batch.insertAll(oldDb.registerBook, oldRegisterBookData);
        batch.insertAll(oldDb.studentRegisterBook, oldStudentRegisterBookData);
        batch.insertAll(oldDb.hiddenStudentTable, oldHiddenStudentTableData);
      },
      validateItems: (newDb) async {
        expect(expectedNewStudentData, await newDb.select(newDb.student).get());
        expect(expectedNewRegisterBookData,
            await newDb.select(newDb.registerBook).get());
        expect(expectedNewStudentRegisterBookData,
            await newDb.select(newDb.studentRegisterBook).get());
        expect(expectedNewHiddenStudentTableData,
            await newDb.select(newDb.hiddenStudentTable).get());
      },
    );
  });
}
