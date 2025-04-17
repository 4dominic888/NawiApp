import 'package:uuid/uuid.dart';

/// Utilidades generales de la aplicación
class NawiGeneralUtils {
  static Uuid uuid = Uuid();

  /// Limpia los espacios de más, incluyendo los de en medio del texto
  static String clearSpaces(String text) => text.trim().replaceAll(RegExp(r'\s+'), ' ');
}

