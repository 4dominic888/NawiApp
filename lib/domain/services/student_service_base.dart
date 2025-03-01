import 'package:nawiapp/domain/classes/paginated_data.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/student.dart';

abstract class StudentServiceBase {

  Future<Result<Student>> addOne(Student data);
  Stream<Result<PaginatedData<StudentDAO>>> getAllPaginated({required int pageSize, required int curretPage, required Map<String, dynamic> params});
  Stream<Result<List<StudentDAO>>> getAll(Map<String, dynamic> params);
  Future<Result<Student>> getOne(String? id);
  Future<Result<bool>> updateOne(Student data);
  Future<Result<Student>> deleteOne(Student student);
  
}