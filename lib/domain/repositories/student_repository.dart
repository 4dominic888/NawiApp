import 'package:drift/drift.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/interfaces/model_drift_repository.dart';
import 'package:nawiapp/domain/models/tables/student_table.dart';
import 'package:nawiapp/domain/models/views/student_view.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';

part 'student_repository.g.dart';

@DriftAccessor(tables: [StudentTable], views: [StudentViewDTOVersion, HiddenStudentViewDTOVersion])
class StudentRepository extends DatabaseAccessor<NawiDatabase> with _$StudentRepositoryMixin 
  implements ModelDriftRepository<
    StudentTableData,
    StudentTableCompanion,
    StudentViewDTOVersionData,
    StudentFilter
  >{

  StudentRepository(super.db);

  @override
  Future<Result<StudentTableData?>> addOne(StudentTableCompanion data) async {
    try {
      final addedStudent = await into(studentTable).insertReturningOrNull(data);
      if(addedStudent != null) return Success(data: addedStudent);
      throw NawiError.onRepository(message: "Estudiante no agregado");
    } catch (e) { return NawiRepositoryTools.onCatch(e); }
  }

  @override
  Future<Result<Iterable<StudentViewDTOVersionData>>> getAll(StudentFilter params) async {
    try {
      var query = ( params.notShowHidden ? select(studentViewDTOVersion) : select(hiddenStudentViewDTOVersion) )
        ..where((tbl) {
          final List<Expression<bool>> filterExpressions = [];

          //* Excluye estudiantes marcados como ocultos
          if(params.notShowHidden) {
            tbl = tbl as $StudentViewDTOVersionView;
            filterExpressions.add(
              tbl.id.isNotInQuery(
                selectOnly(hiddenStudentTable)..addColumns([hiddenStudentTable.hiddenId])
              )
            );
          }

          NawiRepositoryTools.ageFilter(
            table: tbl,
            expressions: filterExpressions,
            ageEnumIndex1: params.ageEnumIndex1?.index,
            ageEnumIndex2: params.ageEnumIndex2?.index
          );

          NawiRepositoryTools.nameStudentFilter(
            table: tbl,
            expressions: filterExpressions,
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

      final filteredStudents = await query.get();

      if(params.notShowHidden) {
        return Success(data: filteredStudents as Iterable<StudentViewDTOVersionData>);
      }

      return Success(data:
        (filteredStudents as Iterable<HiddenStudentViewDTOVersionData>).map(
          (e) => NawiRepositoryTools.studentHiddenToPublic(e)
        )
      );
      
    } catch (e) { return NawiRepositoryTools.onCatch(e); }
  }

  @override
  Future<Result<StudentTableData>> getOne(String id) async{
    try {
      final gottenStudent = await (select(studentTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if(gottenStudent != null) return Success(data: gottenStudent);
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
        final deleteStatement = delete(hiddenStudentTable)..where((tbl) => tbl.hiddenId.equals(id));
        await deleteStatement.go();

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
        final studentArchived = await (
          select(studentTable)..where((tbl) => 
            Expression.and([
              tbl.id.isNotInQuery(selectOnly(hiddenStudentTable)..addColumns([hiddenStudentTable.hiddenId])),
              tbl.id.equals(id)
            ])
          )
        ).getSingleOrNull();
        
        if(studentArchived == null) throw NawiError.onRepository(message: "No se pudo archivar el estudiante, porque no existe o ya ha sido archivado");

        final addingStatement = await into(hiddenStudentTable).insertReturningOrNull(HiddenStudentTableData(hiddenId: id));
        if(addingStatement == null) throw NawiError.onRepository(message: "Ha ocurrido un problema al intentar archivar al estudiante");

        return Success(data: studentArchived);
      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }

  /// Elimina un estudiante oculto del registro
  @override
  Future<Result<StudentTableData>> unarchiveOne(String id) {
    return transaction<Result<StudentTableData>>(() async {
      try {
        final studentUnarchived = await (
          select(studentTable)..where((tbl) => tbl.id.isInQuery(
            selectOnly(hiddenStudentTable)
              ..addColumns([hiddenStudentTable.hiddenId])
              ..where(hiddenStudentTable.hiddenId.equals(id))
            )
          )
        ).getSingleOrNull();

        if(studentUnarchived == null) throw NawiError.onRepository(message: "No se pudo desarchivar el estudiante, porque no existe o no esta archivado");

        final deleteRows = await (
          delete(hiddenStudentTable)..where((tbl) => tbl.hiddenId.equals(id))
        ).go();

        if(deleteRows == 0) throw NawiError.onRepository(message: "Ha ocurrido un error al desarchivar al estudiante");

        return Success(data: studentUnarchived);
      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }
}