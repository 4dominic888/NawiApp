import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/interfaces/model_drift_dao.dart';
import 'package:nawiapp/data/local/tables/register_book_table.dart';
import 'package:nawiapp/data/local/views/register_book_view.dart';
import 'package:nawiapp/domain/daos/student_register_book_dao.dart';
import 'package:nawiapp/infrastructure/in_memory_storage.dart';
import 'package:nawiapp/utils/nawi_dao_utils.dart';

part 'register_book_dao.g.dart';

@DriftAccessor(tables: [RegisterBookTable], views: [RegisterBookViewSummaryVersion, HiddenRegisterBookViewSummaryVersion])
class RegisterBookDAO extends DatabaseAccessor<NawiDatabase> with _$RegisterBookDAOMixin
  implements ModelDriftDAO<
    RegisterBookTableData,
    RegisterBookTableCompanion,
    RegisterBookViewSummaryVersionData,
    RegisterBookFilter>
  {

  RegisterBookDAO(super.db);

  @override
  Future<Result<RegisterBookTableData>> addOne(RegisterBookTableCompanion data) async {
    try {
      final addedRegister = await into(registerBookTable).insertReturningOrNull(data);
      if(addedRegister != null) return Success(data: addedRegister);
      throw NawiError.onDAO(message: "Cuaderno de registro no agregado");
    } catch (e) { return NawiDAOUtils.onCatch(e); }
  }

  @override
  Future<Result<Iterable<RegisterBookViewSummaryVersionData>>> getAll(RegisterBookFilter params) async {
    try {
      final memoryStorage = GetIt.I<InMemoryStorage>();
      
      final registersIdByStudentResult = await _getRegisterBookIdByStudents(params.searchByStudentsId);
      if(registersIdByStudentResult is NawiError) return registersIdByStudentResult.getError()!;

      final Iterable<String> searchedRegistersIdByStudents = registersIdByStudentResult.getValue!;

      var query = (params.notShowHidden ? select(registerBookViewSummaryVersion) : select(hiddenRegisterBookViewSummaryVersion))
        ..where((tbl) {
          final List<Expression<bool>> filterExpressions = [];

          NawiDAOUtils.classroomFilter(
            expressions: filterExpressions,
            table: tbl,
            classroomId: memoryStorage.currentClassroomId
          );          

          if(params.notShowHidden) {
            filterExpressions.add(
              (tbl as $RegisterBookViewSummaryVersionView).id.isNotInQuery(
                selectOnly(hiddenRegisterBookTable)..addColumns([hiddenRegisterBookTable.hiddenRegisterBookId])
              )
            );
          }

          if(params.searchByStudentsId.isNotEmpty) {
            filterExpressions.add((tbl as $RegisterBookViewSummaryVersionView).id.isIn(
              searchedRegistersIdByStudents
            ));
          }

          if(params.searchByType != null) {
            filterExpressions.add((tbl as $RegisterBookViewSummaryVersionView).type.equals(params.searchByType!.index));
          }

          NawiDAOUtils.actionFilter(
            expressions: filterExpressions, table: tbl,
            textLike: params.actionLike
          );

          NawiDAOUtils.timestampRangeFilter(expressions: filterExpressions, table: tbl, range: params.timestampRange);

          NawiDAOUtils.nameStudentFilter(
            expressions: filterExpressions, table: tbl,
            textLike: params.studentNameLike
          );

          return Expression.and(filterExpressions);
        });

      query = NawiDAOUtils.orderByAction(query: query, orderBy: params.orderBy);
      query = NawiDAOUtils.infiniteScrollFilter(
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
          (e) => NawiDAOUtils.registerBookHiddenToPublic(e),
        )
      );

    } catch (e) { return NawiDAOUtils.onCatch(e); }
  }

  @override
  Future<Result<RegisterBookTableData>> getOne(String id) async {
    try {
      final gottenRegister = await (select(registerBookTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if(gottenRegister != null) return Success(data: gottenRegister);
      throw NawiError.onDAO(message: "Cuaderno de registro no encontrado");
    } catch (e) { return NawiDAOUtils.onCatch(e); }
  }

  @override
  Future<Result<bool>> updateOne(RegisterBookTableData data) async {
    try {
      final isUpdated = await update(registerBookTable).replace(data);
      if(!isUpdated) throw NawiError.onDAO(message: "Cuaderno de registro no actualizado");
      return Success(data: true);
    } catch (e) { return NawiDAOUtils.onCatch(e); }
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

      } catch (e) { return NawiDAOUtils.onCatch(e); }
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

        if(registerArchived == null) throw NawiError.onDAO(message: "No se pudo archivar al cuaderno de registro, porque no existe o ya está archivado");

        final addingStatement = await into(hiddenRegisterBookTable).insertReturningOrNull(HiddenRegisterBookTableData(hiddenRegisterBookId: id));
        if(addingStatement == null) throw NawiError.onDAO(message: "Ha ocurrido un problema al intentar archivar al cuaderno de registro");

        return Success(data: registerArchived);
      } catch (e) { return NawiDAOUtils.onCatch(e); }
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

        if(registerUnarchived == null) throw NawiError.onDAO(message: "No se pudo desarchivar al cuaderno de registro, porque no existe o no esta desarchivado");

        final deleteRows = await (delete(hiddenRegisterBookTable)..where((tbl) => tbl.hiddenRegisterBookId.equals(id))).go();
        if(deleteRows == 0) throw NawiError.onDAO(message: "Ha ocurrido un problema al intentar desarchivar al cuaderno de registro");

        return Success(data: registerUnarchived);
      } catch (e) { return NawiDAOUtils.onCatch(e); }
    });
  }


  /// Obtiene los registros en base en base a los estudiantes involucrados en ella
  Future<Result<Iterable<String>>> _getRegisterBookIdByStudents(Iterable<String> studentsId) async {
    if(studentsId.isNotEmpty) {
      final studentRegisterBookRepo = StudentRegisterBookDAO(db); //* Repo auxiliar de muchos a muchos
      
      final registersResult = await studentRegisterBookRepo.getRegisterBookWithSelectedStudents(studentsId);

      if(registersResult is NawiError) return registersResult.getError()!;
      return Success(data: registersResult.getValue!.map((e) => e.id));
    }
    return Success(data: const []);
  }
}