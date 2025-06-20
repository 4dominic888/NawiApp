import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:uuid/uuid.dart';

/// Utilidades generales de la aplicación
class NawiGeneralUtils {
  static Uuid uuid = Uuid();

  /// Limpia los espacios de más, incluyendo los de en medio del texto
  static String clearSpaces(String text) => text.trim().replaceAll(RegExp(r'\s+'), ' ');

  static Iterable<StudentAge> get studentAges => StudentAge.values.where((type) => type != StudentAge.custom);

  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  static String getFormattedDate(DateTime date) {
    final day = DateFormat('d', 'es').format(date);
    final month = DateFormat('MMMM', 'es').format(date);
    final year = DateFormat('y', 'es').format(date);
    final weekDay = DateFormat('EEEE', 'es').format(date);

    return '$weekDay, $day de $month de $year';
  }

  static double getPercent(int partialValue, int total) {
    if (total == 0) return 0;
    return (partialValue / total) * 100;
  }
}

