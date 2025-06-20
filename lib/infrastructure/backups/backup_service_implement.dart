import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/services/backup_service_base.dart';
import 'package:nawiapp/locator.dart';

interface class BackupServiceImplement extends BackupServiceBase {
  
  BackupServiceImplement({required super.cryptoStrategy});

  @override
  Future<Result<File>> backupDatabase(String path, {bool isTest = false}) async {
    try {
      final dbFile = await getDatabaseFile(isTest: isTest);
      if (!await dbFile.exists()) throw Exception('El archivo de la base de datos no existe');

      final dbBytes = await dbFile.readAsBytes();
      final encryptedBytes = cryptoStrategy.encrypt(dbBytes);

      final backupFile = File(path);
      await backupFile.writeAsBytes(encryptedBytes, flush: true);
      
      return Success(data: backupFile, message: 'Se ha creado el backup correctamente');
    } catch (e) {
      return NawiError.onService(message: 'Error al crear el backup: $e');
    }
  }

  @override
  Future<Result<void>> restoreDatabase(String backupPath, {bool isTest = false}) async {
    try {
      final backupFile = File(backupPath);
      final encryptedBytes = await backupFile.readAsBytes();

      final decryptedBytes = cryptoStrategy.decrypt(encryptedBytes);

      await GetIt.I<NawiDatabase>().close();
      unregisterDatabaseStuffsLocator();

      final dbFile = await getDatabaseFile(isTest: isTest);
      await dbFile.writeAsBytes(decryptedBytes, flush: true);

      setupDatabaseStuffsLocator(dbFolderPath: isTest ? 'test/backup_test_output' : null);

      return Success(data: null, message: 'Se ha restaurado el backup correctamente');

    } catch (e) {
      return NawiError.onService(message: 'Error al crear el backup: $e');
    }
  }
}