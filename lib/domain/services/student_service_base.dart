import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/student.dart';

abstract class StudentServiceBase {

  Future<Result<Student>> addOne(Student data);
  Stream<Result<List<StudentDAO>>> getAll(Map<String, dynamic> params);
  Future<Result<Student>> getOne(String id);
  Future<Result<bool>> updateOne(Student data);
  //* Delete coming soon
  
}