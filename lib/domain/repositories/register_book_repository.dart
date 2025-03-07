import 'package:drift/drift.dart';
import 'package:nawiapp/data/database_connection.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/interfaces/model_drift_repository.dart';
import 'package:nawiapp/domain/models/models_table/register_book_table.dart';
import 'package:nawiapp/domain/models/models_views/register_book_view.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';

part 'register_book_repository.g.dart';

@DriftAccessor(tables: [RegisterBookTable], views: [RegisterBookViewDAOVersion])
class RegisterBookRepository extends DatabaseAccessor<NawiDatabase> with _$RegisterBookRepositoryMixin
  implements ModelDriftRepository<RegisterBookTableData, RegisterBookTableCompanion, RegisterBookViewDAOVersionData> {
  RegisterBookRepository(super.db);

  @override
  Future<Result<RegisterBookTableData?>> addOne(RegisterBookTableCompanion data) {
    return into(registerBookTable).insertReturningOrNull(data).then(
      (result) => Success(data: result), onError: NawiRepositoryTools.defaultErrorFunction
    );
  }

  @override
  Stream<Result<List<RegisterBookViewDAOVersionData>>> getAll(Map<String, dynamic> params) {
    var query = select(registerBookViewDAOVersion)..where((tbl) {
      final List<Expression<bool>> filterExpressions = [];
      NawiRepositoryTools.actionFilter(filterExpressions, params, tbl);
      NawiRepositoryTools.nameStudentFilter(filterExpressions, params, tbl);
      NawiRepositoryTools.actionFilter(filterExpressions, params, tbl);
      return Expression.and(filterExpressions);
    });

    query = NawiRepositoryTools.orderByAction(query, params);
    query = NawiRepositoryTools.infiniteScrollFilter(query, params);

    return query.watch().map((event) {
      try { return Success(data: event); }
      catch (e) { return Error.onRepository(message: e.toString()); }
    });
  }

  @override
  Future<Result<RegisterBookTableData>> getOne(String id) {
    return (select(registerBookTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull().then(
      (result) => result != null ? Success(data: result) : Error.onRepository(message: "No encontrado"),
      onError: NawiRepositoryTools.defaultErrorFunction
    );
  }

  @override
  Future<Result<bool>> updateOne(RegisterBookTableData data) {
    return update(registerBookTable).replace(data).then(
      (result) => Success(data: result), onError: NawiRepositoryTools.defaultErrorFunction
    );
  }

  @override
  Future<Result<RegisterBookTableData>> deleteOne(String id) {
    return (delete(registerBookTable)..where((tbl) => tbl.id.equals(id))).goAndReturn().then(
      (result) => Success(data: result.first),
      onError: NawiRepositoryTools.defaultErrorFunction
    );
  }
}