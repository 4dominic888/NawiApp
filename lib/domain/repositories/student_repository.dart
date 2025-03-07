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
  Future<Result<StudentTableData?>> addOne(StudentTableCompanion data) {
    return into(studentTable).insertReturningOrNull(data).then(
      (result) => Success(data: result), onError: NawiRepositoryTools.defaultErrorFunction
    );
  }

  @override
  Stream<Result<List<DataClass>>> getAll(Map<String, dynamic> params) {
    var query = params['hidden'] as bool? ?? false ? select(hiddenStudentViewDAOVersion) : select(studentViewDAOVersion) ;

    query = NawiRepositoryTools.ageFilter(query, params);
    query = NawiRepositoryTools.nameStudentFilter(query, params);
    query = NawiRepositoryTools.orderByStudent(query, params);

    query = NawiRepositoryTools.infiniteScrollFilter(query, params);

    return query.watch().map((event) {
      try { return Success(data: event); } catch (e) { return Error.onRepository(message: e.toString()); }
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
  Future<Result<StudentTableData>> deleteOne(String id) {
    return (delete(studentTable)..where((tbl) => tbl.id.equals(id))).goAndReturn().then(
      (result) => Success(data: result.first),
      onError: NawiRepositoryTools.defaultErrorFunction
    );
  }

  /// Estudiantes ocultos del registro
  Future<Result<StudentTableData?>> archiveOne(String id) async {
    final result = await getOne(id);
    return into(hiddenStudentTable).insertReturningOrNull(HiddenStudentTableData(hiddenId: id)).then(
      (value) => result, onError: NawiRepositoryTools.defaultErrorFunction
    );
  }

}