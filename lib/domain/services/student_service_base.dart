import 'package:nawiapp/domain/classes/paginated_data.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/classes/stat_summary/student_stat.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';

abstract class StudentServiceBase {
  Future<Result<Student>> addOne(Student data);
  Future<Result<PaginatedData<StudentSummary>>> getAllPaginated({required int pageSize, required int currentPage, required StudentFilter params});
  Future<Result<Iterable<StudentSummary>>> getAll(StudentFilter params);
  Stream<int> getAllCount(StudentFilter params);
  Stream<StudentStat> getStudentStat(String classroomId);
  Future<Result<Student>> getOne(String id);
  Future<Result<bool>> updateOne(Student data);
  Future<Result<Student>> deleteOne(String id);
  Future<Result<Student>> archiveOne(String id);
  Future<Result<Student>> unarchiveOne(String id);
}