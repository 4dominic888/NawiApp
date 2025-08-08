import 'dart:io';
import 'dart:typed_data';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/core/ports/backup/backup_crypto_strategy.dart';
import 'package:path/path.dart' as path;

abstract class BackupServiceBase {

  BackupServiceBase({required this.cryptoStrategy});

  final BackupCryptoStrategy cryptoStrategy;

  Future<File> getDatabaseFile({bool isTest = false}) async {
    final dbPath = path.join(await NawiDatabase.folderPath(isTest: isTest), 'nawidb2.sqlite');
    return File(dbPath);
  }

  Future<Result<File>> backupDatabase(String path, {bool isTest = false});
  Future<Result<Uint8List>> backupDatabaseAndroid(String name);
  Future<Result<void>> restoreDatabase(String backupPath, {bool isTest = false});
}