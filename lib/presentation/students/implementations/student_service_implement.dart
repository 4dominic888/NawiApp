import 'package:nawiapp/domain/classes/paginated_data.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/classes/student_filter.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/domain/repositories/student_register_book_repository.dart';
import 'package:nawiapp/domain/repositories/student_repository.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';

interface class StudentServiceImplement extends StudentServiceBase {

  final StudentRepository studentRepo;
  final StudentRegisterBookRepository studentRegisterBookRepo;
  StudentServiceImplement(this.studentRepo, this.studentRegisterBookRepo);

  @override
  Future<Result<Student>> addOne(Student data) {
    return studentRepo.addOne(NawiServiceTools.toStudentTableCompanion(data)).then(
      (result) => NawiTools.resultConverter(result, (value) => Student.fromTableData(value!)),
      onError: NawiServiceTools.defaultErrorFunction
    );
  }

  @override
  Future<Result<List<StudentDAO>>> getAll(StudentFilter params) {
    return studentRepo.getAll(params).then(
      (result) => NawiTools.resultConverter(
        result, (value) => value.map((e) => StudentDAO.fromDAOView(e)).toList()
      ),
      onError: NawiServiceTools.defaultErrorFunction
    );
  }

  @override
  Future<Result<PaginatedData<StudentDAO>>> getAllPaginated({required int pageSize, required int currentPage, required StudentFilter params}){
    params = params.copyWith(pageSize: pageSize, currentPage: currentPage);
    return getAll(params).then(
      (result) => NawiTools.resultConverter(result, (value) => PaginatedData.build(
        currentPage:currentPage, pageSize: pageSize, data: value
      )),
      onError: NawiServiceTools.defaultErrorFunction
    );
  }

  @override
  Future<Result<Student>> getOne(String? id) {
    return studentRepo.getOne(id).then(
      (result) => NawiTools.resultConverter(result, (value) => Student.fromTableData(result.getValue!)),
      onError: NawiServiceTools.defaultErrorFunction
    );
  }

  @override
  Future<Result<bool>> updateOne(Student data) {
    return studentRepo.updateOne(data.toTableData).then(
      (result) => Success(data: true, message: result.message), onError: NawiRepositoryTools.defaultErrorFunction
    );
  }
  
  @override
  Future<Result<Student>> deleteOne(String id) {
    return studentRepo.transaction<Result<Student>>(() async {
      //* Eliminacion de registros relacionados de la tabla StudentRegisterBookTable
      final deleteManyToManyResult = await studentRegisterBookRepo.deleteManyByStudentID(studentId: id, deleteRegisterBooks: true);
      if(deleteManyToManyResult is Error) Error.onRepository(message: deleteManyToManyResult.message, stackTrace: (deleteManyToManyResult as Error).stackTrace);

      //* Eliminación del estudiante en cuestion
      final deleteStudentResult = await studentRepo.deleteOne(id);
      if(deleteStudentResult is Error) Error.onRepository(message: deleteStudentResult.message, stackTrace: (deleteStudentResult as Error).stackTrace);

      return NawiTools.resultConverter(deleteStudentResult, (value) => Student.fromTableData(deleteStudentResult.getValue!));
    });
  }
  
  @override
  Future<Result<Student>> archiveOne(String id) {
    return studentRepo.archiveOne(id).then(
      (result) => NawiTools.resultConverter(result, (value) => Student.fromTableData(value)),
      onError: NawiServiceTools.defaultErrorFunction
    );
  }

  @override
  Future<Result<Student>> unarchiveOne(String id) {
    return studentRepo.unarchiveOne(id).then(
      (result) => NawiTools.resultConverter(result, (value) => Student.fromTableData(value)),
      onError: NawiServiceTools.defaultErrorFunction
    );
  }
}