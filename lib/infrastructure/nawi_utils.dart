import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/data/local/views/register_book_view.dart';
import 'package:nawiapp/data/local/views/student_view.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:uuid/uuid.dart';
import 'package:nawiapp/domain/classes/result.dart';

/// Utilidades generales de la aplicación
class NawiTools {
  static Uuid uuid = Uuid();

  /// Limpia los espacios de más, incluyendo los de en medio del texto
  static String clearSpaces(String text) => text.trim().replaceAll(RegExp(r'\s+'), ' ');
}

/// Utilidades para la capa de servicio
class NawiServiceTools{  
  
  /// [NawiError] por defecto en bloques try catch
  static NawiError<T> onCatch<T>(Object e) {
    if(e is NawiError<T>) return e;
    return NawiError.onService(message: e.toString());
  }
}

/// Utilidades para los repositorios, que en resumen son cosas de filtros y detalles extras
class NawiRepositoryTools {

  /// Para convertir un [HiddenStudentViewSummaryVersionData] a un [StudentViewSummaryVersionData]
  static StudentViewSummaryVersionData studentHiddenToPublic(HiddenStudentViewSummaryVersionData data) => StudentViewSummaryVersionData(
    id: data.id,
    name: data.name,
    age: data.age,
    timestamp: data.timestamp
  );

  /// Para convertir un [HiddenRegisterBookViewSummaryVersionData] a un [RegisterBookViewSummaryVersionData]
  static RegisterBookViewSummaryVersionData registerBookHiddenToPublic(HiddenRegisterBookViewSummaryVersionData data) => RegisterBookViewSummaryVersionData(
    id: data.id,
    action: data.action,
    createdAt: data.createdAt,
    type: data.type,
    hourCreatedAt: data.hourCreatedAt
  );

  /// [NawiError] por defecto en bloques try catch
  static NawiError<T> onCatch<T>(Object e) {
    if(e is NawiError<T>) return e;
    return NawiError.onRepository(message: e.toString());
  }
  
  /// Para aplicar scroll infinito
  /// 
  /// Tambien sirve para paginado normal
  static SimpleSelectStatement<T, R> infiniteScrollFilter<T extends HasResultSet, R>({required dynamic query, int? pageSize, int? currentPage}) {
    if(pageSize != null && currentPage != null) {
      query = query..limit(pageSize, offset: (currentPage - 1) * pageSize);
    }
    return query;
  }

  /// Solo para la tabla `students` donde se filtra por nombre
  static void nameStudentFilter({required List<Expression<bool>> expressions, String? textLike, required dynamic table}) {
    if(textLike != null && textLike.isNotEmpty) {
      expressions.add((table.name as GeneratedColumn<String>).contains(textLike));
    }
  }

  /// Solo para la tabla `register_book`, donde se filtra por accion
  static void actionFilter({required List<Expression<bool>> expressions, String? textLike, required dynamic table}) {
    if(textLike != null && textLike.isNotEmpty) {
      expressions.add((table.action as GeneratedColumn<String>).contains(textLike));
    }
  }

  static void timestampRangeFilter({required List<Expression<bool>> expressions, DateTimeRange? range, required dynamic table}) {
    if(range != null) {
      expressions.add((table.createdAt as GeneratedColumn<DateTime>).isBetweenValues(range.start, range.end));
    }
  }

  /// Solo para la tabla `student`, donde se ordena en base a ciertos criterios
  static SimpleSelectStatement<T, R> orderByStudent<T extends HasResultSet, R>({required dynamic query, required StudentViewOrderByType orderBy}) {
    query = switch (orderBy) {
      StudentViewOrderByType.timestampRecently => query..orderBy([(u) => OrderingTerm.desc(u.timestamp)]),
      StudentViewOrderByType.timestampOldy => query..orderBy([(u) => OrderingTerm.asc(u.timestamp)]),
      StudentViewOrderByType.nameAsc => query..orderBy([(u) => OrderingTerm.asc(u.name)]),
      StudentViewOrderByType.nameDesc => query..orderBy([(u) => OrderingTerm.desc(u.name)]),
    };
    return query;
  }

  /// Solo para la tabla `register_book`, donde se ordena en base a ciertos criterios
  static SimpleSelectStatement<T, R> orderByAction<T extends HasResultSet, R>({required dynamic query, required RegisterBookViewOrderByType orderBy}) {
    query = switch (orderBy) {
      RegisterBookViewOrderByType.timestampRecently => query..orderBy([(u) => OrderingTerm.desc(u.createdAt)]),
      RegisterBookViewOrderByType.timestampOldy => query..orderBy([(u) => OrderingTerm.asc(u.createdAt)]),
      RegisterBookViewOrderByType.actionAsc => query..orderBy([(u) => OrderingTerm.asc(u.action)]),
      RegisterBookViewOrderByType.actionDesc => query..orderBy([(u) => OrderingTerm.desc(u.action)]),
    };
    return query;
  }

  /// Solo para la tabla `student`, donde se filtra por edad
  static void ageFilter({required List<Expression<bool>> expressions, int? ageEnumIndex1, int? ageEnumIndex2, required dynamic table}) {
    final List<Expression<bool>> orExpression = [];
    if(ageEnumIndex1 != null) orExpression.add((table.age as GeneratedColumnWithTypeConverter<StudentAge, int>).equals(ageEnumIndex1));
    if(ageEnumIndex2 != null) orExpression.add((table.age as GeneratedColumnWithTypeConverter<StudentAge, int>).equals(ageEnumIndex2));
    if(orExpression.isNotEmpty) expressions.add(Expression.or(orExpression));
  }
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