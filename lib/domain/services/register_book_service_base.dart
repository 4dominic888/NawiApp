import 'package:nawiapp/domain/classes/paginated_data.dart';
import 'package:nawiapp/domain/classes/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/register_book.dart';


abstract class RegisterBookServiceBase {
  Future<Result<RegisterBook>> addOne(RegisterBook data);
  Future<Result<PaginatedData<RegisterBookDAO>>> getAllPaginated({required int pageSize, required int currentPage, required RegisterBookFilter params});
  Future<Result<List<RegisterBookDAO>>> getAll(RegisterBookFilter params);
  Future<Result<RegisterBook>> getOne(String id);
  Future<Result<bool>> updateOne(RegisterBook data);
  Future<Result<RegisterBook>> deleteOne(String id);
  Future<Result<RegisterBook>> archiveOne(String id);
  Future<Result<RegisterBook>> unarchiveOne(String id);
}