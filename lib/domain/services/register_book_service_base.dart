import 'package:nawiapp/domain/classes/paginated_data.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';


abstract class RegisterBookServiceBase {
  Future<Result<RegisterBook>> addOne(RegisterBook data);
  Future<Result<PaginatedData<RegisterBookSummary>>> getAllPaginated({required int pageSize, required int currentPage, required RegisterBookFilter params});
  Future<Result<Iterable<RegisterBookSummary>>> getAll(RegisterBookFilter params);
  Future<Stream<int>> getAllCount(RegisterBookFilter params);
  Future<Result<RegisterBook>> getOne(String id);
  Future<Result<bool>> updateOne(RegisterBook data);
  Future<Result<RegisterBook>> deleteOne(String id);
  Future<Result<RegisterBook>> archiveOne(String id);
  Future<Result<RegisterBook>> unarchiveOne(String id);
}