import 'package:nawiapp/data/database_connection.dart';
import 'package:nawiapp/domain/classes/paginated_data.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/domain/repositories/student_repository.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';

interface class StudentServiceImplement extends StudentServiceBase {

  final StudentRepository repo;
  StudentServiceImplement(this.repo);

  @override
  Future<Result<Student>> addOne(Student data) async {
    return repo.addOne(NawiServiceTools.toStudentTableCompanion(data)).then(
      (result) => NawiServiceTools.resultConverter(result, (value) => Student.fromTableData(value!)),
      onError: NawiServiceTools.defaultErrorFunction
    );
  }

  @override
  Stream<Result<List<StudentDAO>>> getAll(Map<String, dynamic> params) {
    params.addAll({"hidden" : false});
    return repo.getAll(params).map((result) {
      try { return NawiServiceTools.resultConverter(result, 
        (value) => value.map((e) => StudentDAO.fromDAOView(e)).toList()); 
      }
      catch (e) { return Error.onService(message: e.toString()); }
    });
  }

  @override
  Stream<Result<PaginatedData<StudentDAO>>> getAllPaginated({required int pageSize, required int currentPage, required Map<String, dynamic> params}){
    params.addAll({"pageSize": pageSize, "currentPage": currentPage});
    return getAll(params).map((result) {
      try {
        return NawiTools.resultConverter(result, 
          (value) => PaginatedData.build(currentPage: currentPage, pageSize: pageSize, data: value),
        );
      } catch (e) { return Error.onService(message: e.toString()); }
    });
  }

  @override
  Stream<Result<List<StudentDAO>>> getAllHidden(Map<String, dynamic> params) {
    params.addAll({"hidden" : true});
    return repo.getAll(params).map((result) {
      try {
        return NawiServiceTools.resultConverter(result, 
          (value) => PaginatedData.build(
            currentPage: curretPage,
            pageSize: pageSize,
            data: value.map((e) => StudentDAO.fromDAOView(e)).toList() 
          ));
      } catch (e) { return Error.onService(message: e.toString()); }
    });
  }

  @override
  Future<Result<Student>> getOne(String? id) {
    return repo.getOne(id).then(
      (result) => NawiServiceTools.resultConverter(result, (value) => Student.fromTableData(result.getValue!)),
      onError: NawiServiceTools.defaultErrorFunction
    );
  }

  @override
  Future<Result<bool>> updateOne(Student data) {
    return repo.updateOne(data.toTableData).then(
      (result) => Success(data: true, message: result.message), onError: NawiRepositoryTools.defaultErrorFunction
    );
  }
  
  @override
  Future<Result<Student>> deleteOne(String id) {
    return repo.deleteOne(id).then(
      (result) => NawiServiceTools.resultConverter(result, (value) => Student.fromTableData(result.getValue!)),
      onError: NawiServiceTools.defaultErrorFunction
    );
  }
  
  @override
  Future<Result<Student>> archiveOne(String id) {
    return repo.archiveOne(id).then(
      (result) => NawiTools.resultConverter(result, (value) => Student.fromTableData(value!)),
      onError: NawiServiceTools.defaultErrorFunction
    );
  }
  

}