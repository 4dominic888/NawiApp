import 'dart:io';
import 'package:nawiapp/domain/services/backup_crypto_strategy.dart';
import 'package:path/path.dart' as path;

abstract class BackupServiceBase {

  BackupServiceBase({required this.cryptoStrategy});

  BackupCryptoStrategy cryptoStrategy;

  Future<File> get getDatabaseFile async {
    final dbPath = path.join(Directory.current.path, 'nawidb2.sqlite');
    return File(dbPath);
  }

  Future<void> backupDatabase();
  Future<void> restoreDatabase();
}