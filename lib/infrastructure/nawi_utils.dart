import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:nawiapp/data/database_connection.dart';
import 'package:nawiapp/domain/models/models_views/register_book_view.dart';
import 'package:nawiapp/domain/models/models_views/student_view.dart';
import 'package:nawiapp/domain/models/register_book.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';
import 'package:nawiapp/domain/classes/result.dart';

/// Utilidades generales de la aplicación
class NawiTools {
  static Uuid uuid = Uuid();
  /// Parsea bien el texto en caso halla excepciones en la variable [e], caso contrario, devuelve un [String] = 'Error inesperado'
  static String errorTextParser(Object e) => e is Exception ? e.toString() : "Error inesperado";

  /// Limpia los espacios de más, incluyendo los de en medio del texto
  static String clearSpacesOnText(String text) => text.trim().replaceAll(RegExp(r'\s+'), ' ');

  static NawiError<T> errorParser<T>(Result result) => NawiError(message: result.message, stackTrace: (result as NawiError).stackTrace, origin: result.origin);

  static String formatActionText(String text) {
    final buffer = StringBuffer();
    for (String word in text.split(' ')) {
      if(word.startsWith('@')) word = word.replaceFirst('@', '').replaceAll('_', ' ').titleCase;
      buffer.write(word);
      buffer.write(' ');
    }
    return clearSpacesOnText(buffer.toString());
  }

  /// Devuelve un [Result], el cual [E] es el tipo original y se desea parsear a un tipo [T]
  static Result<T> resultConverter<T, E>(Result<E> result, T Function(E value) converter, {NawiErrorOrigin? origin}) {
    if(result is Success) {
      return Success<T>(data: converter(result.getValue as E), message: result.message);
    }
    final error = result as NawiError<E>;
    return NawiError<T>(message: error.message, stackTrace: error.stackTrace, origin: origin ?? result.origin);
  }
}

class NawiServiceTools{  
  static NawiError<T> onCatch<T>(Object e) {
    if(e is NawiError<T>) return e;
    return NawiError.onService(message: NawiTools.errorTextParser(e));
  }

  static StudentTableCompanion toStudentTableCompanion(Student data, {bool withId = false}) => StudentTableCompanion(
    id: withId ? Value(data.id) : Value.absent(),
    age: Value(data.age),
    name: Value(data.name),
    notes: Value(data.notes),
    timestamp: Value(data.timestamp)
  );

  static RegisterBookTableCompanion toRegisterBookTableCompanion(RegisterBook data, {bool withId = false}) => RegisterBookTableCompanion(
    id: withId ? Value(data.id) : Value.absent(),
    action: Value(data.action),
    createdAt: Value(data.timestamp),
    notes: Value(data.notes),
    type: Value(data.type)
  );
}

/// Utilidades para los repositorios, que en resumen son cosas de filtros y detalles extras
class NawiRepositoryTools {
  static StudentViewDAOVersionData studentHiddenToPublic(HiddenStudentViewDAOVersionData data) => StudentViewDAOVersionData(
    id: data.id,
    name: data.name,
    age: data.age,
    timestamp: data.timestamp
  );

  static RegisterBookViewDAOVersionData registerBookHiddenToPublic(HiddenRegisterBookViewDAOVersionData data) => RegisterBookViewDAOVersionData(
    id: data.id,
    action: data.action,
    createdAt: data.createdAt,
    type: data.type,
    hourCreatedAt: data.hourCreatedAt
  );

  static NawiError<T> onCatch<T>(Object e) {
    if(e is NawiError<T>) return e;
    return NawiError.onRepository(message: NawiTools.errorTextParser(e));
  }
  
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