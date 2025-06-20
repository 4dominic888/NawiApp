import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/backups/providers/backup_controller_provider.dart';
import 'package:nawiapp/presentation/features/select_classroom/screens/select_classroom_screen.dart';
import 'package:nawiapp/presentation/widgets/restart_widget.dart';
import 'package:restart_app/restart_app.dart';

class BackupScreen extends ConsumerWidget {
  const BackupScreen({super.key});

  Future<bool?> showRestartDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // No se puede cerrar tocando fuera
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text('Reiniciar aplicación'),
            content: Text('Para aplicar el respaldo de datos, es necesario reiniciar la aplicación. ¿Desea continuar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Reiniciar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(backupControllerProvider);

    final isProcessing = controller.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Respaldo y Restauración')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            ElevatedButton.icon(
              onPressed: isProcessing ? null: () => ref.read(backupControllerProvider.notifier).createBackup(),
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text('Crear respaldo'),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: isProcessing? null : () => ref.read(backupControllerProvider.notifier).restoreBackup(
                before: () async => await showRestartDialog(context),
                onRestored: () {
                  if(Platform.isAndroid) {
                    Restart.restartApp(
                      notificationTitle: "La aplicación se reiniciará para aplicar los cambios",
                      notificationBody: "Presiona el botón para abrir la aplicación",
                    );
                  }
                  else {
                    fullAppRestart();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SelectClassroomScreen()));
                  }
                }
              ),
              icon: const Icon(Icons.upload_file, color: Colors.white),
              label: const Text('Cargar respaldo'),
            ),

            if (isProcessing) const Padding(
              padding: EdgeInsets.only(top: 24), child: CircularProgressIndicator()
            ),
          ],
        ),
      ),
    );
  }
}