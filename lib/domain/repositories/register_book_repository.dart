import 'package:drift/drift.dart';
import 'package:nawiapp/data/database_connection.dart';
import 'package:nawiapp/domain/classes/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/interfaces/model_drift_repository.dart';
import 'package:nawiapp/domain/models/models_table/register_book_table.dart';
import 'package:nawiapp/domain/models/models_views/register_book_view.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';

part 'register_book_repository.g.dart';

@DriftAccessor(tables: [RegisterBookTable], views: [RegisterBookViewDAOVersion, HiddenRegisterBookViewDAOVersion])
class RegisterBookRepository extends DatabaseAccessor<NawiDatabase> with _$RegisterBookRepositoryMixin
  implements ModelDriftRepository<
    RegisterBookTableData,
    RegisterBookTableCompanion,
    RegisterBookViewDAOVersionData,
    RegisterBookFilter
  >{

  RegisterBookRepository(super.db);

  @override
  Future<Result<RegisterBookTableData?>> addOne(RegisterBookTableCompanion data) {
    return into(registerBookTable).insertReturningOrNull(data).then(
      (result) => Success(data: result), onError: NawiRepositoryTools.defaultErrorFunction
    );
  }

  @override
  Future<Result<List<RegisterBookViewDAOVersionData>>> getAll(RegisterBookFilter params) {
    var query = (!params.showHidden ? select(registerBookViewDAOVersion) : select(hiddenRegisterBookViewDAOVersion))
      ..where((tbl) {
        final List<Expression<bool>> filterExpressions = [];

        if(!params.showHidden) {
          filterExpressions.add((tbl as $RegisterBookViewDAOVersionView).id.isNotInQuery(
            selectOnly(hiddenRegisterBookTable)..addColumns([hiddenRegisterBookTable.hiddenRegisterBookId])
          ));
        }

        NawiRepositoryTools.actionFilter(
          expressions: filterExpressions, table: tbl,
          textLike: params.actionLike
        );

        NawiRepositoryTools.nameStudentFilter(
          expressions: filterExpressions, table: tbl,
          textLike: params.studentNameLike
        );

        return Expression.and(filterExpressions);
      });

    query = NawiRepositoryTools.orderByAction(query: query, orderBy: params.orderBy);
    query = NawiRepositoryTools.infiniteScrollFilter(
      query: query,
      pageSize: params.pageSize,
      currentPage: params.currentPage
    );

    return query.get().then(
      (result) => Success(data: !params.showHidden ?
        result as List<RegisterBookViewDAOVersionData> :
        (result as List<HiddenRegisterBookViewDAOVersionData>).map(
          (e) => NawiRepositoryTools.registerBookHiddenToPublic(e)
        ).toList(),
      ),
      onError: NawiRepositoryTools.defaultErrorFunction
    );
  }

  // Stream<Result<List<RegisterBookViewDAOVersionData>>> getAllHidden(RegisterBookFilter params) {
  //   var query = select(hiddenRegisterBookViewDAOVersion)..where((tbl) {
  //     final List<Expression<bool>> filterExpressions = [];

  //     NawiRepositoryTools.actionFilter(
  //       expressions: filterExpressions, table: tbl,
  //       textLike: params.actionLike
  //     );

  //     NawiRepositoryTools.nameStudentFilter(
  //       expressions: filterExpressions, table: tbl,
  //       textLike: params.studentNameLike
  //     );

  //     return Expression.and(filterExpressions);
  //   });

  //   query = NawiRepositoryTools.orderByAction(query: query, orderBy: params.orderBy);
  //   query = NawiRepositoryTools.infiniteScrollFilter(
  //     query: query,
  //     pageSize: params.pageSize,
  //     currentPage: params.currentPage
  //   );

  //   return query.watch().map((event) {
  //     try { return Success(data: event); }
  //     catch (e) { return Error.onRepository(message: e.toString()); }
  //   });
  // }

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

  Future<Result<RegisterBookTableData>> archiveOne(String id) {
    return transaction<Result<RegisterBookTableData>>(() async {
      try {
        final result = await getOne(id);
        return into(hiddenRegisterBookTable).insertReturningOrNull(HiddenRegisterBookTableData(hiddenRegisterBookId: id)).then(
          (_) => result, onError: NawiRepositoryTools.defaultErrorFunction
        );
      } catch (e) { return Error.onRepository(message: e.toString()); }
    });
  }

  Future<Result<RegisterBookTableData>> unarchiveOne(String id) {
    return transaction<Result<RegisterBookTableData>>(() async {
      try {
        final result = await getOne(id);
        return (delete(hiddenRegisterBookTable)..where((tbl) => tbl.hiddenRegisterBookId.equals(id))).goAndReturn().then(
          (_) => result, onError: NawiRepositoryTools.defaultErrorFunction
        );
      } catch (e) { return Error.onRepository(message: e.toString()); }
    });
  }
}