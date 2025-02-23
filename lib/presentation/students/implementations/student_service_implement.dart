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
    return repo.getAll(params).map((event) {
      try { return NawiServiceTools.resultConverter(event, 
        (value) => value.map((e) => StudentDAO.fromDAOView(e)).toList()); 
      }
      catch (e) { return Error.onService(message: e.toString()); }
    });
  }

  @override
  Stream<Result<PaginatedData<StudentDAO>>> getAllPaginated({required int pageSize, required int curretPage, required Map<String, dynamic> params}){
    params.addAll({"pageSize": pageSize, "currentPage": curretPage});
    return repo.getAll(params).map((event) {
      try {
        return NawiServiceTools.resultConverter(event, 
          (value) => PaginatedData.build(
            currentPage: curretPage,
            pageSize: pageSize,
            data: value.map((e) => StudentDAO.fromDAOView(e)).toList() 
          ));
      } catch (e) { return Error.onService(message: e.toString()); }
    });
  }

  @override
  Future<Result<Student>> getOne(String id) {
    // TODO: implement getOne
    throw UnimplementedError();
  }

  @override
  Future<Result<bool>> updateOne(Student data) {
    // TODO: implement updateOne
    throw UnimplementedError();
  }

}