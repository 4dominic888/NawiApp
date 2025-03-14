import 'package:nawiapp/domain/classes/paginated_data.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/classes/student_filter.dart';
import 'package:nawiapp/domain/models/student.dart';

abstract class StudentServiceBase {

  Future<Result<Student>> addOne(Student data);
  Stream<Result<PaginatedData<StudentDAO>>> getAllPaginated({required int pageSize, required int currentPage, required StudentFilter params});
  Stream<Result<List<StudentDAO>>> getAll(StudentFilter params);
  Future<Result<Student>> getOne(String? id);
  Future<Result<bool>> updateOne(Student data);
  Future<Result<Student>> deleteOne(String id);
  Future<Result<Student>> archiveOne(String id);
  Future<Result<Student>> unarchiveOne(String id);
}