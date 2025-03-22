import 'package:drift/drift.dart';
import 'package:nawiapp/data/database_connection.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/classes/student_filter.dart';
import 'package:nawiapp/domain/interfaces/model_drift_repository.dart';
import 'package:nawiapp/domain/models/models_table/student_table.dart';
import 'package:nawiapp/domain/models/models_views/student_view.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';

part 'student_repository.g.dart';

@DriftAccessor(tables: [StudentTable], views: [StudentViewDAOVersion, HiddenStudentViewDAOVersion])
class StudentRepository extends DatabaseAccessor<NawiDatabase> with _$StudentRepositoryMixin 
  implements ModelDriftRepository<
    StudentTableData,
    StudentTableCompanion,
    StudentViewDAOVersionData,
    StudentFilter
  >{

  StudentRepository(super.db);

  @override
  Future<Result<StudentTableData?>> addOne(StudentTableCompanion data) async {
    try {
      final result = await into(studentTable).insertReturningOrNull(data);
      if(result != null) return Success(data: result);
      throw NawiError.onRepository(message: "Estudiante no agregado");
    } catch (e) { return NawiRepositoryTools.onCatch(e); }
  }

  @override
  Future<Result<Iterable<StudentViewDAOVersionData>>> getAll(StudentFilter params) async {
    try {
      var query = (!params.showHidden ? select(studentViewDAOVersion) : select(hiddenStudentViewDAOVersion))
        ..where((tbl) {
          final List<Expression<bool>> filterExpressions = [];

          //* Excluye estudiantes marcados como ocultos
          if(!params.showHidden) {
            filterExpressions.add((tbl as $StudentViewDAOVersionView).id.isNotInQuery(
              selectOnly(hiddenStudentTable)..addColumns([hiddenStudentTable.hiddenId])
            ));
          }

          NawiRepositoryTools.ageFilter(
            expressions: filterExpressions, table: tbl,
            ageEnumIndex1: params.ageEnumIndex1?.index,
            ageEnumIndex2: params.ageEnumIndex2?.index
          );

          NawiRepositoryTools.nameStudentFilter(
            expressions: filterExpressions, table: tbl,
            textLike: params.nameLike
          );
          
          return Expression.and(filterExpressions);
      });

      query = NawiRepositoryTools.orderByStudent(query: query, orderBy: params.orderBy);

      query = NawiRepositoryTools.infiniteScrollFilter(
        query: query,
        pageSize: params.pageSize,
        currentPage: params.currentPage
      );

      final result = await query.get();
      return Success(data: !params.showHidden ?
        result as Iterable<StudentViewDAOVersionData> :
        (result as Iterable<HiddenStudentViewDAOVersionData>).map(
          (e) => NawiRepositoryTools.studentHiddenToPublic(e)
        )
      );
      
    } catch (e) { return NawiRepositoryTools.onCatch(e); }
  }

  @override
  Future<Result<StudentTableData>> getOne(String? id) async{
    try {
      final result = await (select(studentTable)..where((tbl) => tbl.id.equals(id ?? '*'))).getSingleOrNull();
      if(result != null) return Success(data: result);
      throw NawiError.onRepository(message: "No encontrado");
    } catch (e) { return NawiRepositoryTools.onCatch(e); }
  }

  @override
  Future<Result<bool>> updateOne(StudentTableData data) async {
    try {
      final isUpdated = await update(studentTable).replace(data);
      if(!isUpdated) throw NawiError.onRepository(message: "Estudiante no actualizado");
      return Success(data: true);
    } catch (e) { return NawiRepositoryTools.onCatch(e); }
  }

  @override
  Future<Result<StudentTableData>> deleteOne(String id) {
    return transaction<Result<StudentTableData>>(() async {
      try {
        //* Elimina primero el registro en la tabla de estudiantes ocultos, si es que existe
        await (delete(hiddenStudentTable)..where((tbl) => tbl.hiddenId.equals(id))).go();

        return Success(data: ( await (
            delete(studentTable)
              ..where((tbl) => tbl.id.equals(id))
            ).goAndReturn()
          ).first
        );

      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }

  /// Agrega un estudiantes ocultos del registro
  @override
  Future<Result<StudentTableData>> archiveOne(String id) {
    return transaction<Result<StudentTableData>>(() async {
      try {
        final result = await getOne(id);
        if(result is NawiError<StudentTableData>) throw NawiError.onRepository(message: "No se pudo archivar el estudiante, porque no existe");
        final hiddenResult = (await into(hiddenStudentTable).insertReturningOrNull(HiddenStudentTableData(hiddenId: id)));
        if(hiddenResult == null) throw NawiError.onRepository(message: "Ha ocurrido un problema al intentar archivar al estudiante");
        return Success(data: result.getValue!);
      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }

  /// Elimina un estudiante oculto del registro
  @override
  Future<Result<StudentTableData>> unarchiveOne(String id) {
    return transaction<Result<StudentTableData>>(() async {
      try {
        final result = await getOne(id);
        if(result is NawiError<StudentTableData>) throw NawiError.onRepository(message: "No se pudo desarchivar el estudiante, porque no existe");
        final hiddenResult = await (delete(hiddenStudentTable)..where((tbl) => tbl.hiddenId.equals(id))).go();
        if(hiddenResult != 0) throw NawiError.onRepository(message: "Ha ocurrido un error al desarchivar al estudiante");
        return Success(data: result.getValue!);
      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }
}