import 'package:flutter/material.dart';

/// Clase para seleccionar colores recurrentes en la aplicación Ñawi
class NawiColorUtils {

  const NawiColorUtils._();

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

  static const Color primaryColor = Color(0xFF65558F);
  static const Color secondaryColor = Color(0xFFDECFE8);
  static const Color buttonColor = Color(0xFFECE6F0);
  static const Color hoverColor = Color(0xFFE1DAE8);
  static const Color textColor = Color(0xFF1D1B20);
  static const Color titlesColor = Color(0xFF5F5D5D);
  static const Color successColor = Color(0xFF558F57);
  static const Color errorColor = Color(0xFFBC6E6E);  
}