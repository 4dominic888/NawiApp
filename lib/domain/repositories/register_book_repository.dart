import 'package:drift/drift.dart';
import 'package:nawiapp/data/database_connection.dart';
import 'package:nawiapp/domain/classes/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/interfaces/model_drift_repository.dart';
import 'package:nawiapp/domain/models/models_table/register_book_table.dart';
import 'package:nawiapp/domain/models/models_views/register_book_view.dart';
import 'package:nawiapp/domain/repositories/student_register_book_repository.dart';
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
      Iterable<String> registerBookBelonged = [];
      if(params.searchByStudentsId.isNotEmpty) {
        final studentRegisterBookRepo = StudentRegisterBookRepository(db); //* Repo auxiliar
        final getRegisterBookBelonged = await studentRegisterBookRepo.getRegisterBookFromStudents(params.searchByStudentsId);
        if(getRegisterBookBelonged is NawiError) return getRegisterBookBelonged;
        registerBookBelonged = getRegisterBookBelonged.getValue!.map((e) => e.id); //* Obtiene las id de los cuadernos de registro en base a los estudiantes
      }

      var query = (!params.showHidden ? select(registerBookViewDAOVersion) : select(hiddenRegisterBookViewDAOVersion))
        ..where((tbl) {
          final List<Expression<bool>> filterExpressions = [];

          if(!params.showHidden) {
            filterExpressions.add((tbl as $RegisterBookViewDAOVersionView).id.isNotInQuery(
              selectOnly(hiddenRegisterBookTable)..addColumns([hiddenRegisterBookTable.hiddenRegisterBookId])
            ));
          }

          if(registerBookBelonged.isNotEmpty) {
            filterExpressions.add((tbl as $RegisterBookViewDAOVersionView).id.isIn(registerBookBelonged));
          }

          if(params.searchByType != null) {
            filterExpressions.add((tbl as $RegisterBookViewDAOVersionView).type.equals(params.searchByType!.index));
          }

          NawiRepositoryTools.actionFilter(
            expressions: filterExpressions, table: tbl,
            textLike: params.actionLike
          );

          NawiRepositoryTools.timestampRangeFilter(expressions: filterExpressions, table: tbl, range: params.timestampRange);

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
        final result = await (select(registerBookTable)..where((tbl) => 
          Expression.and([
            tbl.id.isNotInQuery(selectOnly(hiddenRegisterBookTable)..addColumns([hiddenRegisterBookTable.hiddenRegisterBookId])),
            tbl.id.equals(id)
          ])
        )).get();

        if(result.isEmpty) throw NawiError.onRepository(message: "No se pudo archivar al cuaderno de registro, porque no existe o ya está archivado");
        final hiddenResult = await into(hiddenRegisterBookTable).insertReturningOrNull(HiddenRegisterBookTableData(hiddenRegisterBookId: id));
        if(hiddenResult == null) throw NawiError.onRepository(message: "Ha ocurrido un problema al intentar archivar al cuaderno de registro");
        return Success(data: result.first);
      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }

  @override
  Future<Result<RegisterBookTableData>> unarchiveOne(String id) {
  return transaction<Result<RegisterBookTableData>>(() async {
      try {
        final result = await (select(registerBookTable)..where((tbl) => tbl.id.isInQuery(
          selectOnly(hiddenRegisterBookTable)
            ..addColumns([hiddenRegisterBookTable.hiddenRegisterBookId])
            ..where(hiddenRegisterBookTable.hiddenRegisterBookId.equals(id))
        ))).get();

        if(result.isEmpty) throw NawiError.onRepository(message: "No se pudo desarchivar al cuaderno de registro, porque no existe o no esta desarchivado");
        final hiddenResult = await (delete(hiddenRegisterBookTable)..where((tbl) => tbl.hiddenRegisterBookId.equals(id))).go();
        if(hiddenResult == 0) throw NawiError.onRepository(message: "Ha ocurrido un problema al intentar desarchivar al cuaderno de registro");
        return Success(data: result.first);
      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }
}