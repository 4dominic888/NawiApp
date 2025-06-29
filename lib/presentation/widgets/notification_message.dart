import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationMessage{

  static void showSuccessNotification(description) {
    showSimpleNotification(
      const Text('Exito'),
      position: NotificationPosition.top,
      subtitle: Text(description),
      autoDismiss: true,
      foreground: Colors.white,
      background: Colors.green,
      trailing: const Icon(Icons.check),
      duration: const Duration(seconds: 1),
      slideDismissDirection: DismissDirection.horizontal
    );
  }

  static void showErrorNotification(description) {
    showSimpleNotification(
      const Text('Error'),
      position: NotificationPosition.top,
      subtitle: Text(description),
      autoDismiss: true,
      foreground: Colors.white,
      background: Colors.red,
      trailing: const Icon(Icons.error),
      duration: const Duration(seconds: 5),
      slideDismissDirection: DismissDirection.horizontal
    );
  }
}