import 'package:nawiapp/domain/classes/paginated_data.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/classes/student_filter.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/domain/repositories/student_register_book_repository.dart';
import 'package:nawiapp/domain/repositories/student_repository.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';

interface class StudentServiceImplement extends StudentServiceBase {

  final StudentRepository studentRepo;
  final StudentRegisterBookRepository studentRegisterBookRepo;
  StudentServiceImplement(this.studentRepo, this.studentRegisterBookRepo);

  @override
  Future<Result<Student>> addOne(Student data) async {
    data = data.copyWith(name: data.name.titleCase);
    final result = await studentRepo.addOne(NawiServiceTools.toStudentTableCompanion(data, withId: Uuid.isValidUUID(fromString: data.id)));
    return NawiTools.resultConverter(result, (value) => Student.fromTableData(value!), origin: NawiErrorOrigin.service);
  }

  @override
  Future<Result<Iterable<StudentDAO>>> getAll(StudentFilter params) async {
    final result = await studentRepo.getAll(params);
    return NawiTools.resultConverter(result, (value) => value.map((e) => StudentDAO.fromDAOView(e)));
  }

  @override
  Future<Result<PaginatedData<StudentDAO>>> getAllPaginated({required int pageSize, required int currentPage, required StudentFilter params}) async {
    final result = await getAll(params.copyWith(pageSize: pageSize, currentPage: currentPage));
    return NawiTools.resultConverter(result, (value) => PaginatedData.build(currentPage: currentPage, pageSize: pageSize, data: result.getValue!));
  }

  @override
  Future<Result<Student>> getOne(String id) async {
    final studentTableDataResult = await studentRepo.getOne(id);
    return NawiTools.resultConverter(
      studentTableDataResult, 
      (value) => Student.fromTableData(studentTableDataResult.getValue!)
    );
  }

  @override
  Future<Result<bool>> updateOne(Student data) => studentRepo.updateOne(data.toTableData);
  
  @override
  Future<Result<Student>> deleteOne(String id) {
    return studentRepo.transaction<Result<Student>>(() async {
      //* Eliminacion de registros relacionados de la tabla StudentRegisterBookTable
      final deleteManyToManyResult = await studentRegisterBookRepo.deleteManyByStudentID(studentId: id, deleteRegisterBooks: true);
      if(deleteManyToManyResult is NawiError) return NawiTools.errorParser(deleteManyToManyResult);

      //* Eliminación del estudiante en cuestion
      final deleteStudentResult = await studentRepo.deleteOne(id);
      if(deleteStudentResult is NawiError) return NawiTools.errorParser(deleteStudentResult);

      return NawiTools.resultConverter(deleteStudentResult, (value) => Student.fromTableData(deleteStudentResult.getValue!));
    });
  }
  
  @override
  Future<Result<Student>> archiveOne(String id) async {
    final result = await studentRepo.archiveOne(id);
    return NawiTools.resultConverter(result, (value) => Student.fromTableData(value));
  }

  @override
  Future<Result<Student>> unarchiveOne(String id) async {
    final result = await studentRepo.unarchiveOne(id);
    return NawiTools.resultConverter(result, (value) => Student.fromTableData(value));
  }
}