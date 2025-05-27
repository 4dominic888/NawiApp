import 'package:drift/drift.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/data/local/tables/classroom_table.dart';
import 'package:nawiapp/data/local/tables/student_table.dart';
import 'package:nawiapp/domain/classes/filter/classroom_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/interfaces/model_drift_dao.dart';
import 'package:nawiapp/utils/nawi_dao_utils.dart';

part 'classroom_dao.g.dart';

@DriftAccessor(tables: [ClassroomTable, StudentTable])
class ClassroomDAO extends DatabaseAccessor<NawiDatabase> with _$ClassroomDAOMixin 
  implements ModelDriftDAOWithouArchieve<
    ClassroomTableData,
    ClassroomTableCompanion,
    ClassroomTableData,
    ClassroomFilter
  >,
  CountableModelDriftDAO<ClassroomFilter>
  {

  ClassroomDAO(super.db);

  @override
  Future<Result<ClassroomTableData>> addOne(ClassroomTableCompanion data) async {
    try {
      final addedRegister = await into(classroomTable).insertReturningOrNull(data);
      if(addedRegister != null) return Success(data: addedRegister);
      throw NawiError.onDAO(message: "Aula no creada");
    } catch (e) { return NawiDAOUtils.onCatch(e); }
  }

  Expression<bool> _filterExpressions({required dynamic table, required ClassroomFilter filter}) {
    final List<Expression<bool>> expressions = [];

    if(filter.searchByStatus != null) {
      expressions.add(table.status.equals(filter.searchByStatus!.index));
    }
    
    NawiDAOUtils.nameClassroomFilter(
      expressions: expressions,
      table: table,
      textLike: filter.nameLike
    );

    return Expression.and(expressions);
  }

  @override
  Future<Result<Iterable<ClassroomTableData>>> getAll(ClassroomFilter params) async {
    try {
      var query = select(classroomTable)..where((tbl) => _filterExpressions(table: tbl, filter: params));

      query = NawiDAOUtils.orderByClassroom(query: query, orderBy: params.orderBy);
      query = NawiDAOUtils.infiniteScrollFilter(
        query: query,
        pageSize: params.pageSize,
        currentPage: params.currentPage
      );

      return Success(data: await query.get());

    } catch (e) { return NawiDAOUtils.onCatch(e); }
  }

  @override
  Stream<int> getAllCount(ClassroomFilter params) {
    final queryOnly = selectOnly(classroomTable)
      ..addColumns([classroomTable.id.count()])
      ..where(_filterExpressions(table: classroomTable, filter: params)
    );

    return queryOnly.watchSingleOrNull().map((row) => row?.read(classroomTable.id.count()) ?? 0);
  }

  @override
  Future<Result<ClassroomTableData>> getOne(String id) async {
    try {
      final gottenClassroom = await (select(classroomTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if(gottenClassroom != null) return Success(data: gottenClassroom);
      throw NawiError.onDAO(message: "Aula no encontrada");
    } catch (e) { return NawiDAOUtils.onCatch(e); }
  }

  @override
  Future<Result<bool>> updateOne(ClassroomTableData data) async {
    try {
      final isUpdated = await update(classroomTable).replace(data);
      if(!isUpdated) throw NawiError.onDAO(message: "Aula no actualizada");
      return Success(data: true);
    } catch (e) { return NawiDAOUtils.onCatch(e); }
  }

  @override
  Future<Result<ClassroomTableData>> deleteOne(String id) async {
    return transaction<Result<ClassroomTableData>>(() async {
      try {
        final studentDeleteStatement = delete(studentTable)..where((tbl) => tbl.classroom.equals(id));
        await studentDeleteStatement.go();

        final classroomTableDataResult = (await (delete(classroomTable)..where((tbl) => tbl.id.equals(id))).goAndReturn()).first;

        return Success(data: classroomTableDataResult);
      } catch (e) { return NawiDAOUtils.onCatch(e); }
    });
  }
}