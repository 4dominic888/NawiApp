import 'package:flutter/material.dart';
import 'package:nawiapp/presentation/features/backups/screens/backup_screen.dart';
import 'package:nawiapp/presentation/features/tutorial/screens/tutorial_screen.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({ super.key });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menú',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Respaldos de datos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const BackupScreen()));
              },
            ),
            //? Algun dia se tendrán opciones
            // ListTile(
            //   leading: const Icon(Icons.settings),
            //   title: const Text('Configuraciones'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     // Agrega tu lógica aquí
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Volver a ver el tutorial'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TutorialScreen(reviewMode: true)));
              },
            ),
            // TODO: Algun dia implementar esto xddddddddddddd
            // ListTile(
            //   leading: const Icon(Icons.lock_reset),
            //   title: const Text('Reestablecer PIN'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     // Agrega tu lógica aquí
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}