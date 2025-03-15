import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:nawiapp/data/database_connection.dart';
import 'package:nawiapp/domain/models/models_views/register_book_view.dart';
import 'package:nawiapp/domain/models/models_views/student_view.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:uuid/uuid.dart';
import 'package:nawiapp/domain/classes/result.dart';

class NawiTools {
  static Uuid uuid = Uuid();
  static String clearSpacesOnText(String text) => text.trim().replaceAll(RegExp(r'\s+'), ' ');

  static Success<T> resultConverter<T, E>(Result<E> result, T Function(E value) converter) 
    => Success(data: converter(result.getValue as E), message: result.message);
}

class NawiServiceTools{
  static Function defaultErrorFunction = (e, stackTrace) => Error.onService(message: e, stackTrace: stackTrace);

  static StudentTableCompanion toStudentTableCompanion(Student data, {bool withId = false}) => StudentTableCompanion(
    id: withId ? Value(data.id) : Value.absent(),
    age: Value(data.age),
    name: Value(data.name),
    notes: Value(data.notes),
    timestamp: Value(data.timestamp)
  );
}

/// Utilidades para los repositorios, que en resumen son cosas de filtros y detalles extras
class NawiRepositoryTools {
  
  static Function defaultErrorFunction = (e, stackTrace) => Error.onRepository(message: e, stackTrace: stackTrace);

  static StudentViewDAOVersionData hiddenToPublic(HiddenStudentViewDAOVersionData data) => StudentViewDAOVersionData(
    id: data.id,
    name: data.name,
    age: data.age,
    timestamp: data.timestamp
  );
  
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

  static void actionFilter({required List<Expression<bool>> expressions, String? textLike, required dynamic table}) {
    if(textLike != null && textLike.isNotEmpty) {
      expressions.add((table.action as GeneratedColumn<String>).contains(textLike));
    }
  }

  static SimpleSelectStatement<T, R> orderByStudent<T extends HasResultSet, R>({required dynamic query, required StudentViewOrderByType orderBy}) {
    query = switch (orderBy) {
      StudentViewOrderByType.timestampRecently => query..orderBy([(u) => OrderingTerm.desc(u.timestamp)]),
      StudentViewOrderByType.timestampOldy => query..orderBy([(u) => OrderingTerm.asc(u.timestamp)]),
      StudentViewOrderByType.nameAsc => query..orderBy([(u) => OrderingTerm.asc(u.name)]),
      StudentViewOrderByType.nameDesc => query..orderBy([(u) => OrderingTerm.desc(u.name)]),
    };
    return query;
  }

  static SimpleSelectStatement<T, R> orderByAction<T extends HasResultSet, R>({required dynamic query, required RegisterBookViewOrderByType orderBy}) {
    query = switch (orderBy) {
      RegisterBookViewOrderByType.timestampRecently => query..orderBy([(u) => OrderingTerm.desc(u.createdAt)]),
      RegisterBookViewOrderByType.timestampOldy => query..orderBy([(u) => OrderingTerm.asc(u.createdAt)]),
      RegisterBookViewOrderByType.actionAsc => query..orderBy([(u) => OrderingTerm.asc(u.action)]),
      RegisterBookViewOrderByType.actionDesc => query..orderBy([(u) => OrderingTerm.desc(u.action)]),
    };
    return query;
  }

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