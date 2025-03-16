import 'package:nawiapp/domain/models/register_book.dart';

import '../classes/result.dart';

abstract class RegisterBookServiceBase {
  Future<Result<RegisterBook>> addOne(RegisterBook data);
  // TODO Stream<Result<PaginatedData<StudentDAO>>> getAllPaginated({required int pageSize, required int currentPage, required StudentFilter params});
  // TODO Stream<Result<List<StudentDAO>>> getAll(StudentFilter params);
  Future<Result<RegisterBook>> getOne(String? id);
  Future<Result<bool>> updateOne(RegisterBook data);
  Future<Result<RegisterBook>> deleteOne(String id);
  Future<Result<RegisterBook>> archiveOne(String id);
  Future<Result<RegisterBook>> unarchiveOne(String id);
}