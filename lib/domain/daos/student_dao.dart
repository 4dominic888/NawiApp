import 'package:drift/drift.dart';
import 'package:drift/remote.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/interfaces/model_drift_dao.dart';
import 'package:nawiapp/data/local/tables/student_table.dart';
import 'package:nawiapp/data/local/views/student_view.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/infrastructure/in_memory_storage.dart';
import 'package:nawiapp/utils/nawi_dao_utils.dart';

part 'student_dao.g.dart';

@DriftAccessor(tables: [StudentTable], views: [
  StudentViewSummaryVersion, HiddenStudentViewSummaryVersion
])
class StudentDAO extends DatabaseAccessor<NawiDatabase> with _$StudentDAOMixin
  implements ModelDriftDAO<
    StudentTableData,
    StudentTableCompanion,
    StudentViewSummaryVersionData,
    StudentFilter
  >,
  
  CountableModelDriftDAO<StudentFilter>
  {

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

  Expression<bool> _filterExpressions({required dynamic table, required StudentFilter filter}) {
    final List<Expression<bool>> expressions = [];

    NawiDAOUtils.classroomFilter(
      expressions: expressions,
      table: table,
      classroomId: filter.classroomId ?? GetIt.I<InMemoryStorage>().currentClassroom?.id
    );

    //* Excluye estudiantes marcados como ocultos
    if(filter.notShowHidden) {
      table = table as $StudentViewSummaryVersionView;
      expressions.add(
        table.id.isNotInQuery(
          selectOnly(hiddenStudentTable)..addColumns([hiddenStudentTable.hiddenId])
        )
      );
    }

    NawiDAOUtils.ageFilter(
      table: table,
      expressions: expressions,
      ageEnumIndex1: filter.ageEnumIndex1?.index,
      ageEnumIndex2: filter.ageEnumIndex2?.index
    );

    NawiDAOUtils.nameStudentFilter(
      table: table,
      expressions: expressions,
      textLike: filter.nameLike
    );

    return Expression.and(expressions);
  }

  @override
  Future<Result<Iterable<StudentViewSummaryVersionData>>> getAll(StudentFilter params) async {
    try {
      var query = ( params.notShowHidden ? select(studentViewSummaryVersion) : select(hiddenStudentViewSummaryVersion) )
        ..where((tbl) => _filterExpressions(table: tbl, filter: params));

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
  Stream<int> getAllCount(StudentFilter params) {
    try {
      final view = params.notShowHidden ? studentViewSummaryVersion : hiddenStudentViewSummaryVersion;
      final selectedOnly = (params.notShowHidden ? selectOnly(studentViewSummaryVersion) : selectOnly(hiddenStudentViewSummaryVersion));
      final idExpressions = params.notShowHidden ? studentViewSummaryVersion.id.count() : hiddenStudentViewSummaryVersion.id.count();
      
      final queryOnly = selectedOnly
        ..addColumns([idExpressions])
        ..where(_filterExpressions(table: view, filter: params));

      return queryOnly.watchSingleOrNull().map((row) => row?.read(idExpressions) ?? 0);
    } catch (e) { return Stream.value(0); }
  }

  Stream<TypedResult> getGeneralStudentStat(String classroomId) {
    final studentSummarized = studentViewSummaryVersion;
    ageFilter(StudentAge age) => studentSummarized.age.equals(age.index);
    final columns = [
      studentSummarized.age.count(filter: ageFilter(StudentAge.threeYears)),
      studentSummarized.age.count(filter: ageFilter(StudentAge.fourYears)),
      studentSummarized.age.count(filter: ageFilter(StudentAge.fiveYears)),
      studentSummarized.id.count(filter: studentSummarized.classroom.equals(classroomId))
    ];

    final query = selectOnly(studentSummarized)..addColumns(columns)..where(studentSummarized.classroom.equals(classroomId));

    return query.watchSingle();
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
  Future<Result<StudentTableData>> deleteOne(String id) async {
    try {
      final deleteStudentQuery = delete(studentTable)..where((tbl) => tbl.id.equals(id));
      final studentTableData = (await deleteStudentQuery.goAndReturn()).firstOrNull;
      if(studentTableData == null) throw NawiError.onDAO(message: "Estudiante no encontrado");
      
      return Success(data: studentTableData);
    } catch (e) { return NawiDAOUtils.onCatch(e); }
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