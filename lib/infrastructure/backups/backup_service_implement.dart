import 'dart:io';
import 'dart:isolate';

import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/services/backup_service_base.dart';
import 'package:nawiapp/infrastructure/backups/backup_crypto_aes_256.dart';
import 'package:nawiapp/locator.dart';

interface class BackupServiceImplement extends BackupServiceBase {
  
  BackupServiceImplement() : super(cryptoStrategy: BackupCryptoAes256());

  @override
  Future<void> backupDatabase() async {
    try {
      final dbFile = await getDatabaseFile;
      if (!await dbFile.exists()) throw Exception('El archivo de la base de datos no existe');

      final dbBytes = await dbFile.readAsBytes();
      final encryptedBytes = cryptoStrategy.encrypt(dbBytes);

      String? selectedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Guardar backup como',
        fileName: 'backup_${DateTime.now().toIso8601String()}.nwdb',
        type: FileType.custom,
        allowedExtensions: ['nwdb'],
      );

      if (selectedPath == null) return;

      final backupFile = File(selectedPath);
      await backupFile.writeAsBytes(encryptedBytes, flush: true);
    } catch (e) {
      Logger().e('Error al crear el backup: $e');
    }
  }

  @override
  Future<void> restoreDatabase() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Selecciona un archivo de backup para restaurar',
        type: FileType.custom,
        allowedExtensions: ['nwdb'],
      );

      if (result == null || result.files.single.path == null) return;

      final backupFile = File(result.files.single.path!);
      final encryptedBytes = await backupFile.readAsBytes();

      await Isolate.run(() async{
        final decryptedBytes = cryptoStrategy.decrypt(encryptedBytes);

        await GetIt.I<NawiDatabase>().close();
        unregisterDatabaseStuffsLocator();

        final dbFile = await getDatabaseFile;
        await dbFile.writeAsBytes(decryptedBytes, flush: true);

        setupDatabaseStuffsLocator();
      }); 


    } catch (e) {
      Logger().e('Error al restaurar el backup: $e');
    }
  }
}