import 'package:drift/drift.dart';
import 'package:nawiapp/data/database_connection.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/models_table/register_book_table.dart';
import 'package:nawiapp/domain/models/models_table/student_register_book_table.dart';
import 'package:nawiapp/domain/models/models_views/student_view.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';

part 'student_register_book_repository.g.dart';

/// [registerBook] es el modelo de tabla de [RegisterBookTable]
/// 
/// [emisors] es una lista de IDs de los estudiantes a agregar
typedef RegisterBookWithEmisorsTableData = ({
  String registerBookId,
  Iterable<String> emisors,
});

@DriftAccessor(tables: [StudentRegisterBookTable, RegisterBookTable], views: [StudentViewDAOVersion])
class StudentRegisterBookRepository extends DatabaseAccessor<NawiDatabase> with _$StudentRegisterBookRepositoryMixin {
  
  StudentRegisterBookRepository(super.db);

  /// De un [RegisterBookTableData] con una lista de [StudentTableData] comprimido en [RegisterBookWithEmisorsTableData], se llenan en la tabla de
  /// [StudentRegisterBookTable]
  Future<Result<bool>> addMany(RegisterBookWithEmisorsTableData data) {
    return transaction<Result<bool>>(() async {
      try {
        final emisors = data.emisors;
        await batch((batch) => batch.insertAll(studentRegisterBookTable, emisors.map(
          (e) => StudentRegisterBookTableCompanion.insert(registerBook: data.registerBookId, student: e)
        )));
        return Success(data: true);
      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }

  /// De un [RegisterBookTableData] con una lista de [StudentTableData] comprimido en [RegisterBookWithEmisorsTableData], se actualizan en la tabla de
  /// [StudentRegisterBookTable].
  /// 
  /// PD: Se usa un borrado previo para luego volver a agregarlos
  Future<Result<bool>> updateMany(RegisterBookWithEmisorsTableData data) {
    return transaction<Result<bool>>(() async {
      try {
        //* Deleting first
        final deleteResult = await deleteManyByRegisterBookID(data.registerBookId);
        if(deleteResult is NawiError<bool>) throw NawiError.onRepository(message: "No se pudo borrar los cuadernos de registro previos");

        //* Add again
        final addResult = await addMany(data);
        if(addResult is NawiError<bool>) NawiError.onRepository(message: "No se pudo volver a agregar los cuadernos de registro");

        return Success(data: true);
      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }

  /// Elimina los registros donde exista [registerBookId]
  Future<Result<bool>> deleteManyByRegisterBookID(String registerBookId) async {
    try {
      await (delete(studentRegisterBookTable)..where((tbl) => tbl.registerBook.equals(registerBookId))).go();
      return Success(data: true);
    } catch (e) { return NawiRepositoryTools.onCatch(e); }
  }

  /// Elimina los registros donde exista [studentId], ademas de borrar los cuadernos de registro de la tabla [RegisterBookTable] involucrados si [deleteRegisterBooks] es `true`
  Future<Result<bool>> deleteManyByStudentID({required String studentId, bool deleteRegisterBooks = false}) {
    return transaction<Result<bool>>(() async {
      try {
        final selectedRegisterBook = selectOnly(studentRegisterBookTable)
          ..addColumns([studentRegisterBookTable.registerBook])
          ..where(studentRegisterBookTable.student.equals(studentId));
        
        await batch((batch) => batch.deleteWhere(studentRegisterBookTable, (tbl) => tbl.registerBook.isInQuery(selectedRegisterBook)));
        if(deleteRegisterBooks) {
          await batch((batch) => batch.deleteWhere(registerBookTable, (tbl) => tbl.id.isInQuery(selectedRegisterBook)));
        }

        return Success(data: true);
      } catch (e) { return NawiRepositoryTools.onCatch(e); }
    });
  }

  /// Obtiene una lista de [StudentViewDAOVersion] de un registro de un [RegisterBookTable] en base a la tabla many to many
  /// [StudentRegisterBookTable]
  Future<Result<List<StudentViewDAOVersionData>>> getStudentsFromRegisterBook(String registerBookId) async {
    try {
      final result = await ((select(studentViewDAOVersion))..where((tblStudent) => tblStudent.id.isInQuery(
        select(studentViewDAOVersion).join([
          innerJoin(studentRegisterBookTable, studentRegisterBookTable.student.equalsExp(studentViewDAOVersion.id))
        ])..where(studentRegisterBookTable.registerBook.equals(registerBookId))
      ))).get();
      return Success(data: result);
    } catch (e) { return NawiRepositoryTools.onCatch(e); }

  }
}