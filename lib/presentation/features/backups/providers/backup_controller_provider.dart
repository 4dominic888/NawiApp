import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/core/ports/backup/backup_service_base.dart';
import 'package:nawiapp/presentation/widgets/notification_message.dart';

class BackupController extends AsyncNotifier<void> {

  final backupService = GetIt.I<BackupServiceBase>();

  @override
  Future<void> build() async {}

  Future<void> createBackup() async {
    state = const AsyncLoading();
    final backupResult = await backupService.backupDatabaseAndroid('respaldo.nwdb');
    backupResult.onValue(
      onSuccessfully: (_, __) => state = const AsyncData(null),
      onError: (_, message) {
        state = AsyncError(message, StackTrace.current);
        NotificationMessage.showErrorNotification(message);
      },
      withPopup: false
    );

    final bytes = backupResult.getValue;
    if(bytes == null) return;

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar respaldo como...',
      fileName: 'respaldo.nwdb',
      type: FileType.custom,
      allowedExtensions: ['nwdb'],
      bytes: bytes
    );

    if (path == null) return;

    backupResult.onValue(
      onSuccessfully: (_, __) => state = const AsyncData(null),
      onError: (_, message) => state = AsyncError(message, StackTrace.current),
      withPopup: true
    );
  }

  Future<void> restoreBackup({required void Function() onRestored, Future<bool?> Function()? before}) async {
    final backupFile = await FilePicker.platform.pickFiles();
    final path = backupFile?.files.single.path;
    if (path == null) return;

    final bool shouldRestart = await before?.call() ?? false;
    if(!shouldRestart) return;

    state = const AsyncLoading();
    final restoreResult = await backupService.restoreDatabase(path);
    restoreResult.onValue(
      onSuccessfully: (_, __) {
        state = const AsyncData(null);
        onRestored();
      },
      onError: (_, message) {
        state = AsyncError(message, StackTrace.current);
        NotificationMessage.showErrorNotification(message);
      },
      withPopup: false
    );
  }
}

final backupControllerProvider = AsyncNotifierProvider<BackupController, void>(BackupController.new);