import 'dart:io';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/services/backup_crypto_strategy.dart';
import 'package:path/path.dart' as path;

abstract class BackupServiceBase {

  BackupServiceBase({required this.cryptoStrategy});

  final BackupCryptoStrategy cryptoStrategy;

  Future<File> get getDatabaseFile async {
    final dbPath = path.join(await NawiDatabase.folderPath(isTest: true), 'nawidb2.sqlite');
    return File(dbPath);
  }

  Future<Result<File>> backupDatabase(String path);
  Future<Result<void>> restoreDatabase(String backupPath);
}