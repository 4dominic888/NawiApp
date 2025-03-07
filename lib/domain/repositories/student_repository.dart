import 'package:drift/drift.dart';
import 'package:nawiapp/data/database_connection.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/interfaces/model_drift_repository.dart';
import 'package:nawiapp/domain/models/models_table/student_table.dart';
import 'package:nawiapp/domain/models/models_views/student_view.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';

part 'student_repository.g.dart';

@DriftAccessor(tables: [StudentTable], views: [StudentViewDAOVersion, HiddenStudentViewDAOVersion])
class StudentRepository extends DatabaseAccessor<NawiDatabase> with _$StudentRepositoryMixin 
  implements ModelDriftRepository<StudentTableData, StudentTableCompanion, StudentViewDAOVersionData> {

  StudentRepository(super.db);

  @override
  Future<Result<StudentTableData?>> addOne(StudentTableCompanion data) async {
    return into(studentTable).insertReturningOrNull(data).then(
      (result) => Success(data: result), onError: NawiRepositoryTools.defaultErrorFunction
    );
  }

  @override
  Stream<Result<List<StudentViewDAOVersionData>>> getAll(Map<String, dynamic> params) {
    var query = select(studentViewDAOVersion)..where((tbl) {
      final List<Expression<bool>> filterExpressions = [];

      //* Excluye estudiantes marcados como ocultos
      filterExpressions.add(tbl.id.isNotInQuery(
        selectOnly(hiddenStudentTable)..addColumns([hiddenStudentTable.hiddenId])
      ));

      NawiRepositoryTools.ageFilter(filterExpressions, params, tbl);
      NawiRepositoryTools.nameStudentFilter(filterExpressions, params, tbl);
      
      return Expression.and(filterExpressions);
    });

    query = NawiRepositoryTools.orderByStudent(query, params);
    query = NawiRepositoryTools.infiniteScrollFilter(query, params);

    return query.watch().map((event) {
      try { return Success(data: event); }
      catch (e) { return Error.onRepository(message: e.toString()); }
    });
  }

  @override
  Future<Result<StudentTableData>> getOne(String? id) {
    return (select(studentTable)..where((tbl) => tbl.id.equals(id ?? '*'))).getSingleOrNull().then(
      (result) => result != null ? Success(data: result) : Error.onRepository(message: "No encontrado"),
      onError: NawiRepositoryTools.defaultErrorFunction
    );
  }

  @override
  Future<Result<bool>> updateOne(StudentTableData data) {
    return update(studentTable).replace(data).then(
      (result) => Success(data: result), onError: NawiRepositoryTools.defaultErrorFunction
    );
  }

  @override
  Future<Result<StudentTableData>> deleteOne(String id) async {
    return await transaction<Result<StudentTableData>>(() async {
      try {
        //* Elimina primero el registro en la tabla de estudiantes ocultos, si es que existe
        await (delete(hiddenStudentTable)..where((tbl) => tbl.hiddenId.equals(id))).go();

        return (delete(studentTable)..where((tbl) => tbl.id.equals(id))).goAndReturn().then(
          (result) => Success(data: result.first),
          onError: NawiRepositoryTools.defaultErrorFunction
        );
      } catch (e) { return Error.onRepository(message: e.toString()); }
    });
  }

  /// Agrega un estudiantes ocultos del registro
  Future<Result<StudentTableData>> archiveOne(String id) async {
    return await transaction<Result<StudentTableData>>(() async {
      try {
        final result = await getOne(id);
        return into(hiddenStudentTable).insertReturningOrNull(HiddenStudentTableData(hiddenId: id)).then(
          (_) => result, onError: NawiRepositoryTools.defaultErrorFunction
        );
      } catch (e) { return Error.onRepository(message: e.toString()); }
    });
  }

  /// Elimina un estudiante oculto del registro
  Future<Result<StudentTableData>> unarchiveOne(String id) async {
    return await transaction<Result<StudentTableData>>(() async {
      try {
        final result = await getOne(id);
        return (delete(hiddenStudentTable)..where((tbl) => tbl.hiddenId.equals(id))).goAndReturn().then(
          (_) => result, onError: NawiRepositoryTools.defaultErrorFunction
        );
      } catch (e) { return Error.onRepository(message: e.toString()); }
    });
  }

  /// Lista oculta de estudiantes
  Stream<Result<List<StudentViewDAOVersionData>>> getAllHidden(Map<String, dynamic> params) {
    var query = select(hiddenStudentViewDAOVersion)..where((tbl) {
      final List<Expression<bool>> filterExpressions = [];
      NawiRepositoryTools.ageFilter(filterExpressions, params, tbl);
      NawiRepositoryTools.nameStudentFilter(filterExpressions, params, tbl);
      return Expression.and(filterExpressions);
    });

    query = NawiRepositoryTools.orderByStudent(query, params);
    query = NawiRepositoryTools.infiniteScrollFilter(query, params);    

    return query.watch().map((event) {
      try { return Success(data: event.map((e) => NawiRepositoryTools.hiddenToPublic(e) ).toList() ); }
      catch (e) { return Error.onRepository(message: e.toString()); }
    });
  }  

}