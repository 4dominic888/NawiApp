import 'package:nawiapp/domain/classes/filter/classroom_filter.dart';
import 'package:nawiapp/domain/classes/paginated_data.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';

abstract class ClassroomServiceBase {
  Future<Result<Classroom>> addOne(Classroom data);
  Future<Result<PaginatedData<Classroom>>> getAllPaginated({required int pageSize, required int currentPage, required ClassroomFilter params});
  Future<Result<Iterable<Classroom>>> getAll(ClassroomFilter params);
  Future<Result<Classroom>> getOne(String id);
  Future<Result<bool>> updateOne(Classroom id);
  Future<Result<Classroom>> deleteOne(String id);
}