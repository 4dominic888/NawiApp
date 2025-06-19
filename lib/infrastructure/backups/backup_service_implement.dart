import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/services/backup_service_base.dart';
import 'package:nawiapp/locator.dart';

interface class BackupServiceImplement extends BackupServiceBase {
  
  BackupServiceImplement({required super.cryptoStrategy});

  @override
  Future<Result<File>> backupDatabase(String path) async {
    try {
      final dbFile = await getDatabaseFile;
      if (!await dbFile.exists()) throw Exception('El archivo de la base de datos no existe');

      final dbBytes = await dbFile.readAsBytes();
      final encryptedBytes = cryptoStrategy.encrypt(dbBytes);

      // String? selectedPath = await FilePicker.platform.saveFile(
      //   dialogTitle: 'Guardar backup como',
      //   fileName: 'backup_${DateTime.now().toIso8601String()}.nwdb',
      //   type: FileType.custom,
      //   allowedExtensions: ['nwdb'],
      // );

      // if (selectedPath == null) throw Exception('No se ha seleccionado ningún archivo');

      final backupFile = File(path);
      await backupFile.writeAsBytes(encryptedBytes, flush: true);
      
      return Success(data: backupFile, message: 'Se ha creado el backup correctamente');
    } catch (e) {
      return NawiError.onService(message: 'Error al crear el backup: $e');
    }
  }

  @override
  Future<Result<void>> restoreDatabase(String backupPath) async {
    try {
      // final result = await FilePicker.platform.pickFiles(
      //   dialogTitle: 'Selecciona un archivo de backup para restaurar',
      //   type: FileType.custom,
      //   allowedExtensions: ['nwdb'],
      // );

      // if (result == null || result.files.single.path == null) throw Exception('No se ha seleccionado ningún archivo');

      // final backupFile = File(result.files.single.path!);

      final backupFile = File(backupPath);
      final encryptedBytes = await backupFile.readAsBytes();

      final decryptedBytes = cryptoStrategy.decrypt(encryptedBytes);

      await GetIt.I<NawiDatabase>().close();
      unregisterDatabaseStuffsLocator();

      final dbFile = await getDatabaseFile;
      await dbFile.writeAsBytes(decryptedBytes, flush: true);

      setupDatabaseStuffsLocator(dbFolderPath: 'test/backup_test_output');

      return Success(data: null, message: 'Se ha restaurado el backup correctamente');

    } catch (e) {
      return NawiError.onService(message: 'Error al crear el backup: $e');
    }
  }
}