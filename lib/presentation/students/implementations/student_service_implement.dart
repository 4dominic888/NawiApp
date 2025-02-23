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
    // TODO: implement getAll
    throw UnimplementedError();
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