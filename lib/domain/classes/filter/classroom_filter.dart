import 'package:equatable/equatable.dart';
import 'package:nawiapp/domain/interfaces/filter_data.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom_status.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

class ClassroomFilter extends FilterData with EquatableMixin {

  /// Filtro por nombre
  final String? nameLike;

  /// Filtro por status
  final ClassroomStatus? searchByStatus;

  /// Tipo de ordenamiento
  final ClassroomOrderBy orderBy;

  ClassroomFilter({
    super.pageSize, super.currentPage,
    String? nameLike, this.searchByStatus,
    this.orderBy = ClassroomOrderBy.timestampRecently
  }) : nameLike = NawiGeneralUtils.clearSpaces(nameLike ?? '');

  @override
  Map<String, dynamic> toMap() => {
    "nameLike": nameLike,
    "searchByStatus": searchByStatus,
    "orderBy": orderBy
  }..addAll(super.toMap());

  @override
  ClassroomFilter copyWith({
    int? pageSize, int? currentPage, bool? showHidden,
    String? nameLike, ClassroomStatus? searchByStatus,
    ClassroomOrderBy? orderBy
  }) => 
    ClassroomFilter(
      nameLike: nameLike ?? this.nameLike,
      searchByStatus: searchByStatus ?? this.searchByStatus,
      orderBy: orderBy ?? this.orderBy,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
    );

  @override
  List<Object?> get props => [nameLike, orderBy];
}

enum ClassroomOrderBy { timestampRecently, timestampOldy, nameAsc, nameDesc }