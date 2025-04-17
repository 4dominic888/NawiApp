import 'package:drift/drift.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/interfaces/model_drift_repository.dart';
import 'package:nawiapp/data/local/tables/register_book_table.dart';
import 'package:nawiapp/data/local/views/register_book_view.dart';
import 'package:nawiapp/domain/repositories/student_register_book_repository.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';

part 'register_book_repository.g.dart';

@DriftAccessor(tables: [RegisterBookTable], views: [RegisterBookViewSummaryVersion, HiddenRegisterBookViewSummaryVersion])
class RegisterBookRepository extends DatabaseAccessor<NawiDatabase> with _$RegisterBookRepositoryMixin
  implements ModelDriftRepository<
    RegisterBookTableData,
    RegisterBookTableCompanion,
    RegisterBookViewSummaryVersionData,
    RegisterBookFilter>
  {

  RegisterBookRepository(super.db);

  @override
  Future<Result<RegisterBookTableData>> addOne(RegisterBookTableCompanion data) async {
    try {
      final addedRegister = await into(registerBookTable).insertReturningOrNull(data);
      if(addedRegister != null) return Success(data: addedRegister);
      throw NawiError.onRepository(message: "Cuaderno de registro no agregado");
    } catch (e) { return NawiRepositoryTools.onCatch(e); }
  }

  @override
  Future<Result<Iterable<RegisterBookViewSummaryVersionData>>> getAll(RegisterBookFilter params) async {
    try {
      final registersIdByStudentResult = await _getRegisterBookIdByStudents(params.searchByStudentsId);
      if(registersIdByStudentResult is NawiError) return registersIdByStudentResult.getError()!;

      final Iterable<String> searchedRegistersIdByStudents = registersIdByStudentResult.getValue!;

      var query = (params.notShowHidden ? select(registerBookViewSummaryVersion) : select(hiddenRegisterBookViewSummaryVersion))
        ..where((tbl) {
          final List<Expression<bool>> filterExpressions = [];

          if(params.notShowHidden) {
            filterExpressions.add(
              (tbl as $RegisterBookViewSummaryVersionView).id.isNotInQuery(
                selectOnly(hiddenRegisterBookTable)..addColumns([hiddenRegisterBookTable.hiddenRegisterBookId])
              )
            );
          }

          if(searchedRegistersIdByStudents.isNotEmpty) {
            filterExpressions.add((tbl as $RegisterBookViewSummaryVersionView).id.isIn(searchedRegistersIdByStudents));
          }

          if(params.searchByType != null) {
            filterExpressions.add((tbl as $RegisterBookViewSummaryVersionView).type.equals(params.searchByType!.index));
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

      if(params.notShowHidden) {
        return Success(data: result as Iterable<RegisterBookViewSummaryVersionData>);
      }

      return Success(data:
        (result as List<HiddenRegisterBookViewSummaryVersionData>).map(
          (e) => NawiRepositoryTools.registerBookHiddenToPublic(e),
        )
      );

    } catch (e) { return NawiRepositoryTools.onCatch(e); }
  }

  @override
  Future<Result<RegisterBookTableData>> getOne(String id) async {
    try {
      final gottenRegister = await (select(registerBookTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if(gottenRegister != null) return Success(data: gottenRegister);
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
        final deleteStatement = delete(hiddenRegisterBookTable)..where((tbl) => tbl.hiddenRegisterBookId.equals(id));
        await deleteStatement.go();

        return Success(data: ( await (
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
        final registerArchived = await (select(registerBookTable)..where((tbl) => 
          Expression.and([
            tbl.id.isNotInQuery(selectOnly(hiddenRegisterBookTable)..addColumns([hiddenRegisterBookTable.hiddenRegisterBookId])),
            tbl.id.equals(id)
          ])
        )).getSingleOrNull();

        if(registerArchived == null) throw NawiError.onRepository(message: "No se pudo archivar al cuaderno de registro, porque no existe o ya está archivado");

        final addingStatement = await into(hiddenRegisterBookTable).insertReturningOrNull(HiddenRegisterBookTableData(hiddenRegisterBookId: id));
        if(addingStatement == null) throw NawiError.onRepository(message: "Ha ocurrido un problema al intentar archivar al cuaderno de registro");

        return Success(data: registerArchived);
      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }

  @override
  Future<Result<RegisterBookTableData>> unarchiveOne(String id) {
  return transaction<Result<RegisterBookTableData>>(() async {
      try {
        final registerUnarchived = await (select(registerBookTable)..where((tbl) => tbl.id.isInQuery(
          selectOnly(hiddenRegisterBookTable)
            ..addColumns([hiddenRegisterBookTable.hiddenRegisterBookId])
            ..where(hiddenRegisterBookTable.hiddenRegisterBookId.equals(id))
        ))).getSingleOrNull();

        if(registerUnarchived == null) throw NawiError.onRepository(message: "No se pudo desarchivar al cuaderno de registro, porque no existe o no esta desarchivado");

        final deleteRows = await (delete(hiddenRegisterBookTable)..where((tbl) => tbl.hiddenRegisterBookId.equals(id))).go();
        if(deleteRows == 0) throw NawiError.onRepository(message: "Ha ocurrido un problema al intentar desarchivar al cuaderno de registro");

        return Success(data: registerUnarchived);
      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }


  /// Obtiene los registros en base en base a los estudiantes involucrados en ella
  Future<Result<Iterable<String>>> _getRegisterBookIdByStudents(Iterable<String> studentsId) async {
    if(studentsId.isNotEmpty) {
      final studentRegisterBookRepo = StudentRegisterBookRepository(db); //* Repo auxiliar de muchos a muchos
      
      final registersResult = await studentRegisterBookRepo.getRegisterBookWithSelectedStudents(studentsId);

      if(registersResult is NawiError) return registersResult.getError()!;
      return Success(data: registersResult.getValue!.map((e) => e.id));
    }
    return Success(data: const []);
  }
}