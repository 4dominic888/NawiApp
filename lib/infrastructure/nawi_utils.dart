import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class NawiTools {
  static Uuid uuid = Uuid();
}

/// Clase para seleccionar colores recurrentes en la aplicación Ñawi
class NawiColor {

  /// Colores para estudiantes según su edad
  /// 
  /// Rango entre `3-5`, cualquier otro se colococará uno por defecto
  /// 
  /// `withOpacity` hace que el color sea más pálido, ideal para fondos
  static Color iconColorMap(int age, {bool? withOpacity = false}) {
    final colorMap = {
      3: Colors.blue,
      4: Colors.orange.shade700,
      5: Colors.purple
    }[age] ?? Colors.black;

    return (withOpacity ?? false) ? colorMap.withAlpha(50) : colorMap;
  }
}