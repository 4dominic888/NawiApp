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
    RegisterBookFilter>
  {

  RegisterBookRepository(super.db);

  @override
  Future<Result<RegisterBookTableData>> addOne(RegisterBookTableCompanion data) async {
    try {
      final result = await into(registerBookTable).insertReturningOrNull(data);
      if(result != null) return Success(data: result);
      throw NawiError.onRepository(message: "Cuaderno de registro no agregado");
    } catch (e) { return NawiRepositoryTools.onCatch(e); }
  }

  @override
  Future<Result<Iterable<RegisterBookViewDAOVersionData>>> getAll(RegisterBookFilter params) async {
    try {
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

      final result = await query.get();
      return Success(data: !params.showHidden ?
        result as Iterable<RegisterBookViewDAOVersionData> :
        (result as List<HiddenRegisterBookViewDAOVersionData>).map(
          (e) => NawiRepositoryTools.registerBookHiddenToPublic(e),
        )
      );
    } catch (e) { return NawiRepositoryTools.onCatch(e); }
  }

  @override
  Future<Result<RegisterBookTableData>> getOne(String id) async {
    try {
      final result = await (select(registerBookTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if(result != null) return Success(data: result);
      throw NawiError.onRepository(message: "Cuaderno de registro no encontrado");
    } catch (e) { return NawiRepositoryTools.onCatch(e); }
  }

  @override
  Future<Result<bool>> updateOne(RegisterBookTableData data) async {
    try {
      final isUpdated = await update(registerBookTable).replace(data);
      if(!isUpdated) throw NawiError.onRepository(message: "Cuaderno de registro no actualizado");
      return Success(data: true);
    } catch (e) { return NawiRepositoryTools.onCatch(e); }
  }

  @override
  Future<Result<RegisterBookTableData>> deleteOne(String id) {
    return transaction<Result<RegisterBookTableData>>(() async {
      try {
        await (delete(hiddenRegisterBookTable)..where((tbl) => tbl.hiddenRegisterBookId.equals(id))).go();
        return Success(data: (await (
            delete(registerBookTable)
              ..where((tbl) => tbl.id.equals(id))
            ).goAndReturn()
          ).first
        );
      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }

  @override
  Future<Result<RegisterBookTableData>> archiveOne(String id) {
    return transaction<Result<RegisterBookTableData>>(() async {
      try {
        final result = await getOne(id);
        if(result is NawiError<RegisterBookTableData>) throw NawiError.onRepository(message: "No se pudo archivar al cuaderno de registro");
        final hiddenResult = await  into(hiddenRegisterBookTable).insertReturningOrNull(HiddenRegisterBookTableData(hiddenRegisterBookId: id));
        if(hiddenResult == null) throw NawiError.onRepository(message: "Ha ocurrido un problema al intentar archivar al cuaderno de registro");
        return Success(data: result.getValue!);
      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }

  @override
  Future<Result<RegisterBookTableData>> unarchiveOne(String id) {
  return transaction<Result<RegisterBookTableData>>(() async {
      try {
        final result = await getOne(id);
        if(result is NawiError<RegisterBookTableData>) throw NawiError.onRepository(message: "No se pudo desarchivar al cuaderno de registro");
        final hiddenResult = await (delete(hiddenRegisterBookTable)..where((tbl) => tbl.hiddenRegisterBookId.equals(id))).go();
        if(hiddenResult != 0) throw NawiError.onRepository(message: "Ha ocurrido un problema al intentar desarchivar al cuaderno de registro");
        return Success(data: result.getValue!);
      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }
}