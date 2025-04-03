import 'package:flutter/material.dart';
import 'package:nawiapp/domain/interfaces/filter_data.dart';
import 'package:nawiapp/domain/models/models_views/register_book_view.dart';
import 'package:nawiapp/domain/models/register_book.dart';

class RegisterBookFilter extends FilterData {

  /// Filtro por nombre de accion
  final String? actionLike;

  /// Filtro por nombre de estudiante
  final String? studentNameLike;

  /// Tipo de ordenamiento
  final RegisterBookViewOrderByType orderBy;

  /// Filtro por lista de ID de estudiantes exactos
  final Iterable<String> searchByStudentsId;

  /// Filtro para buscar por tipo de cuaderno de registro
  final RegisterBookType? searchByType;

  /// Filtro para buscar entre un rango de fechas
  /// 
  /// Valor por defecto, dia de hoy hasta la semana pasada
  final DateTimeRange? timestampRange;

  RegisterBookFilter({
    super.pageSize, super.currentPage,
    this.actionLike, this.studentNameLike,
    this.orderBy = RegisterBookViewOrderByType.timestampRecently,
    this.searchByType,
    this.searchByStudentsId = const [], super.showHidden,
    this.timestampRange
  });

  @override
  Map<String, dynamic> toMap() => {
    "orderBy": orderBy,
    "actionLike": actionLike,
    "studentNameLike": studentNameLike,
    "searchByStudents": searchByStudentsId,
    "searchByType": searchByType,
    "timestampRage" : timestampRange
  }..addAll(super.toMap());
  
  @override
  RegisterBookFilter copyWith({
    int? pageSize, int? currentPage,
    bool? showHidden, String? actionLike,
    String? studentNameLike,
    Iterable<String>? searchByStudentsId,
    RegisterBookType? searchByType,
    RegisterBookViewOrderByType? orderBy,
    DateTimeRange? timestampRange,
  }) =>
    RegisterBookFilter(
      studentNameLike: studentNameLike ?? this.studentNameLike,
      actionLike: actionLike ?? this.actionLike,
      searchByStudentsId: searchByStudentsId ?? this.searchByStudentsId,
      searchByType: searchByType ?? this.searchByType,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      showHidden: showHidden ?? this.showHidden,
      orderBy: orderBy ?? this.orderBy,
      timestampRange: timestampRange ?? this.timestampRange
    );
  
}