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
  static String clearText(String text) => text.trim().replaceAll(RegExp(r'\s+'), ' ');

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

class NawiRepositoryTools {
  
  static Function defaultErrorFunction = (e, stackTrace) => Error.onRepository(message: e, stackTrace: stackTrace);

  static StudentViewDAOVersionData hiddenToPublic(HiddenStudentViewDAOVersionData data) => StudentViewDAOVersionData(
    id: data.id,
    name: data.name,
    age: data.age,
    timestamp: data.timestamp
  );
  

  static SimpleSelectStatement<T, R> infiniteScrollFilter<T extends HasResultSet, R>(dynamic query, Map<String, dynamic> params) {
    final pageSize = params['pageSize'] as int?;
    final currentPage = params['currentPage'] as int?;
    if(pageSize != null && currentPage != null) { query = query..limit(pageSize, offset: (currentPage - 1) * pageSize); }
    return query;
  }

  static SimpleSelectStatement<T, R> nameStudentFilter<T extends HasResultSet, R>(dynamic query, Map<String, dynamic> params) {
    final nameLike = params['nameLike'] as String?;
    if(nameLike != null && nameLike.isNotEmpty) query = query..where((tbl) => tbl.name.like("%$nameLike%"));
    return query;
  }

  static SimpleSelectStatement<T, R> actionFilter<T extends HasResultSet, R>(dynamic query, Map<String, dynamic> params) {
    final actionLike = params['actionLike'] as String?;
    if(actionLike != null && actionLike.isNotEmpty) query = query..where((tbl) => tbl.action.like("%$actionLike%"));
    return query;
  }

  static SimpleSelectStatement<T, R> orderByStudent<T extends HasResultSet, R>(dynamic query, Map<String, dynamic> params) {
    final orderBy = params['orderByStudent'] as StudentViewOrderByType?;
    query = switch (orderBy) {
      StudentViewOrderByType.timestampRecently => query..orderBy([(u) => OrderingTerm.desc(u.timestamp)]),
      StudentViewOrderByType.timestampOldy => query..orderBy([(u) => OrderingTerm.asc(u.timestamp)]),
      StudentViewOrderByType.nameAsc => query..orderBy([(u) => OrderingTerm.asc(u.name)]),
      StudentViewOrderByType.nameDesc => query..orderBy([(u) => OrderingTerm.desc(u.name)]),
      null => query..orderBy([(u) => OrderingTerm.desc(u.timestamp)])
    };
    return query;
  }

  static SimpleSelectStatement<T, R> orderByAction<T extends HasResultSet, R>(dynamic query, Map<String, dynamic> params) {
    final orderBy = params['orderByAction'] as RegisterBookViewOrderByType?;
    query = switch (orderBy) {
      RegisterBookViewOrderByType.timestampRecently => query..orderBy([(u) => OrderingTerm.desc(u.createdAt)]),
      RegisterBookViewOrderByType.timestampOldy => query..orderBy([(u) => OrderingTerm.asc(u.createdAt)]),
      RegisterBookViewOrderByType.actionAsc => query..orderBy([(u) => OrderingTerm.asc(u.action)]),
      RegisterBookViewOrderByType.actionDesc => query..orderBy([(u) => OrderingTerm.desc(u.action)]),
      null => query..orderBy([(u) => OrderingTerm.desc(u.createdAt)])
    };
    return query;
  }

  static SimpleSelectStatement<T, R> ageFilter<T extends HasResultSet, R>(dynamic query, Map<String, dynamic> params) {
    final ageEnumIndex1 = params['ageEnumIndex1'] as int?;
    final ageEnumIndex2 = params['ageEnumIndex2'] as int?;
    if(ageEnumIndex1 != null) query = query..where((tbl) => tbl.age.equals(ageEnumIndex1));
    if(ageEnumIndex2 != null) query = query..where((tbl) => tbl.age.equals(ageEnumIndex2));
    return query;
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