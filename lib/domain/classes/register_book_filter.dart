import 'package:nawiapp/domain/interfaces/filter_data.dart';
import 'package:nawiapp/domain/models/models_views/register_book_view.dart';

class RegisterBookFilter extends FilterData {

  /// Filtro por nombre de accion
  final String? actionLike;

  /// Filtro por nombre de estudiante
  final String? studentNameLike;

  /// Tipo de ordenamiento
  final RegisterBookViewOrderByType orderBy;

  /// Filtro por lista de ID de estudiantes exactos
  final Iterable<String> searchByStudentsId;

  RegisterBookFilter({
    super.pageSize, super.currentPage,
    this.actionLike, this.studentNameLike,
    this.orderBy = RegisterBookViewOrderByType.timestampRecently,
    this.searchByStudentsId = const [], super.showHidden
  });

  @override
  Map<String, dynamic> toMap() => {
    "orderBy": orderBy,
    "actionLike": actionLike,
    "studentNameLike": studentNameLike,
    "searchByStudents": searchByStudentsId
  }..addAll(super.toMap());
  
  @override
  RegisterBookFilter copyWith({
    int? pageSize, int? currentPage,
    bool? showHidden, String? actionLike,
    String? studentNameLike,
    Iterable<String>? searchByStudents,
    RegisterBookViewOrderByType? orderBy
  }) =>
    RegisterBookFilter(
      studentNameLike: studentNameLike ?? this.studentNameLike,
      actionLike: actionLike ?? this.actionLike,
      searchByStudentsId: searchByStudents ?? this.searchByStudentsId,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      showHidden: showHidden ?? this.showHidden,
      orderBy: orderBy ?? this.orderBy
    );
  
}