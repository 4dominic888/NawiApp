import 'package:drift/drift.dart';
import 'package:drift/remote.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/interfaces/model_drift_dao.dart';
import 'package:nawiapp/data/local/tables/student_table.dart';
import 'package:nawiapp/data/local/views/student_view.dart';
import 'package:nawiapp/infrastructure/in_memory_storage.dart';
import 'package:nawiapp/utils/nawi_dao_utils.dart';

part 'student_dao.g.dart';

@DriftAccessor(tables: [StudentTable], views: [StudentViewSummaryVersion, HiddenStudentViewSummaryVersion])
class StudentDAO extends DatabaseAccessor<NawiDatabase> with _$StudentDAOMixin
  implements ModelDriftDAO<
    StudentTableData,
    StudentTableCompanion,
    StudentViewSummaryVersionData,
    StudentFilter
  >{

  StudentDAO(super.db);

  @override
  Future<Result<StudentTableData?>> addOne(StudentTableCompanion data) async {
    try {
      final addedStudent = await into(studentTable).insertReturningOrNull(data);
      if(addedStudent != null) return Success(data: addedStudent);
      throw NawiError.onDAO(message: "Estudiante no agregado");
    } on DriftRemoteException catch (e) {
      if(e.remoteCause.toString().contains('UNIQUE constraint failed')) {
        return NawiDAOUtils.onCatch("Parece que esta intentando ingresar un estudiante ya existente, intentelo nuevamente");
      }
      return NawiDAOUtils.onCatch(e);
    }
    catch (e) { return NawiDAOUtils.onCatch(e); }
    
  }

  @override
  Future<Result<Iterable<StudentViewSummaryVersionData>>> getAll(StudentFilter params) async {
    try {
      final memoryStorage = GetIt.I<InMemoryStorage>();

      var query = ( params.notShowHidden ? select(studentViewSummaryVersion) : select(hiddenStudentViewSummaryVersion) )
        ..where((tbl) {
          final List<Expression<bool>> filterExpressions = [];

          NawiDAOUtils.classroomFilter(
            expressions: filterExpressions,
            table: tbl,
            classroomId: memoryStorage.currentClassroom?.id
          );

          //* Excluye estudiantes marcados como ocultos
          if(params.notShowHidden) {
            tbl = tbl as $StudentViewSummaryVersionView;
            filterExpressions.add(
              tbl.id.isNotInQuery(
                selectOnly(hiddenStudentTable)..addColumns([hiddenStudentTable.hiddenId])
              )
            );
          }

          NawiDAOUtils.ageFilter(
            table: tbl,
            expressions: filterExpressions,
            ageEnumIndex1: params.ageEnumIndex1?.index,
            ageEnumIndex2: params.ageEnumIndex2?.index
          );

          NawiDAOUtils.nameStudentFilter(
            table: tbl,
            expressions: filterExpressions,
            textLike: params.nameLike
          );
          
          return Expression.and(filterExpressions);
      });

      query = NawiDAOUtils.orderByStudent(query: query, orderBy: params.orderBy);

      query = NawiDAOUtils.infiniteScrollFilter(
        query: query,
        pageSize: params.pageSize,
        currentPage: params.currentPage
      );

      final filteredStudents = await query.get();

      if(params.notShowHidden) {
        return Success(data: filteredStudents as Iterable<StudentViewSummaryVersionData>);
      }

      return Success(data:
        (filteredStudents as Iterable<HiddenStudentViewSummaryVersionData>).map(
          (e) => NawiDAOUtils.studentHiddenToPublic(e)
        )
      );
      
    } catch (e) { return NawiDAOUtils.onCatch(e); }
  }

  @override
  Future<Result<StudentTableData>> getOne(String id) async{
    try {
      final gottenStudent = await (select(studentTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if(gottenStudent != null) return Success(data: gottenStudent);
      throw NawiError.onDAO(message: "No encontrado");
    } catch (e) { return NawiDAOUtils.onCatch(e); }
  }

  @override
  Future<Result<bool>> updateOne(StudentTableData data) async {
    try {
      final isUpdated = await update(studentTable).replace(data);
      if(!isUpdated) throw NawiError.onDAO(message: "Estudiante no actualizado");
      return Success(data: true);
    } on DriftRemoteException catch (e) {
      if(e.remoteCause.toString().contains('UNIQUE constraint failed')) {
        return NawiDAOUtils.onCatch("Ya hay un estudiante con estos campos, no es posible sobreescribirlo");
      }
      return NawiDAOUtils.onCatch(e);
    }
    catch (e) { return NawiDAOUtils.onCatch(e); }
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

      } catch (e) { return NawiDAOUtils.onCatch(e); }
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
        
        if(studentArchived == null) throw NawiError.onDAO(message: "No se pudo archivar el estudiante, porque no existe o ya ha sido archivado");

        final addingStatement = await into(hiddenStudentTable).insertReturningOrNull(HiddenStudentTableData(hiddenId: id));
        if(addingStatement == null) throw NawiError.onDAO(message: "Ha ocurrido un problema al intentar archivar al estudiante");

        return Success(data: studentArchived);
      } catch (e) { return NawiDAOUtils.onCatch(e); }
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

        if(studentUnarchived == null) throw NawiError.onDAO(message: "No se pudo desarchivar el estudiante, porque no existe o no esta archivado");

        final deleteRows = await (
          delete(hiddenStudentTable)..where((tbl) => tbl.hiddenId.equals(id))
        ).go();

        if(deleteRows == 0) throw NawiError.onDAO(message: "Ha ocurrido un error al desarchivar al estudiante");

        return Success(data: studentUnarchived);
      } catch (e) { return NawiDAOUtils.onCatch(e); }
    });
  }
}