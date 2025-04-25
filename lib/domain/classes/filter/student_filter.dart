import 'package:equatable/equatable.dart';
import 'package:nawiapp/domain/interfaces/filter_data.dart';
import 'package:nawiapp/data/local/views/student_view.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

class StudentFilter extends FilterData with EquatableMixin {
  /// Tipo de ordenamiento
  final StudentViewOrderByType orderBy;

  /// Filtro por edad 1
  final StudentAge? ageEnumIndex1;

  /// Filtro por edad 2
  final StudentAge? ageEnumIndex2;

  /// Filtro por nombre
  final String? nameLike;

  StudentFilter({
    super.pageSize, super.currentPage,
    this.orderBy = StudentViewOrderByType.timestampRecently,
    this.ageEnumIndex1, this.ageEnumIndex2,
    String? nameLike, super.showHidden
  }) : nameLike = NawiGeneralUtils.clearSpaces(nameLike ?? '');

  Set<StudentAge> get selectedAges {
    final bool noneSelected = ageEnumIndex1 == null && ageEnumIndex2 == null;
    if(noneSelected) return {};
    
    final bool allSelected = ageEnumIndex1 != null && ageEnumIndex2 != null;
    if(allSelected) return { ageEnumIndex1!, ageEnumIndex2! };
    
    final selected = [ageEnumIndex1, ageEnumIndex2].firstWhere((ageEnum) => ageEnum != null)!;
    return { selected };
  }

  @override
  Map<String, dynamic> toMap() => {
    "orderBy": orderBy,
    "ageEnumIndex1": ageEnumIndex1,
    "ageEnumIndex2": ageEnumIndex2,
    "nameLike": nameLike
  }..addAll(super.toMap());
  
  /// Colocar [StudentAge.custom] en [ageEnumIndex1] o [ageEnumIndex2] hará que el valor quede como null
  @override
  StudentFilter copyWith({
    int? pageSize, int? currentPage,
    bool? showHidden, String? nameLike,
    StudentAge? ageEnumIndex1, StudentAge? ageEnumIndex2,
    StudentViewOrderByType? orderBy
  }) => StudentFilter(
    orderBy: orderBy ?? this.orderBy,
    ageEnumIndex1: (ageEnumIndex1 != StudentAge.custom) ? ageEnumIndex1 ?? this.ageEnumIndex1 : null,
    ageEnumIndex2: (ageEnumIndex2 != StudentAge.custom) ? ageEnumIndex2 ?? this.ageEnumIndex2 : null,
    nameLike: nameLike ?? this.nameLike,
    pageSize: pageSize ?? super.pageSize,
    currentPage: currentPage ?? this.currentPage,
    showHidden: showHidden ?? this.showHidden
  );

  @override
  List<Object?> get props => [orderBy, ageEnumIndex1, ageEnumIndex2, nameLike, pageSize, currentPage, showHidden];
}