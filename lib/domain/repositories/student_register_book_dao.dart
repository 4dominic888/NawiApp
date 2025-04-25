import 'package:drift/drift.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/data/local/tables/register_book_table.dart';
import 'package:nawiapp/data/local/tables/student_register_book_table.dart';
import 'package:nawiapp/data/local/views/register_book_view.dart';
import 'package:nawiapp/data/local/views/student_view.dart';
import 'package:nawiapp/utils/nawi_repository_utils.dart';

part 'student_register_book_dao.g.dart';

/// [registerBook] es el modelo de tabla de [RegisterBookTable]
/// 
/// [mentions] es una lista de IDs de los estudiantes a agregar
typedef RegisterBookWithEmisorsTableData = ({
  String registerBookId,
  Iterable<String> mentions,
});

@DriftAccessor(tables: [StudentRegisterBookTable, RegisterBookTable], views: [StudentViewSummaryVersion, RegisterBookViewSummaryVersion])
class StudentRegisterBookRepository extends DatabaseAccessor<NawiDatabase> with _$StudentRegisterBookRepositoryMixin {
  
  StudentRegisterBookRepository(super.db);

  /// De un [RegisterBookTableData] con una lista de [StudentTableData] comprimido en [RegisterBookWithEmisorsTableData], se llenan en la tabla de
  /// [StudentRegisterBookTable]
  Future<Result<bool>> addMany(RegisterBookWithEmisorsTableData data) {
    return transaction<Result<bool>>(() async {
      try {
        final emisors = data.mentions;
        await batch((batch) => batch.insertAll(studentRegisterBookTable, emisors.map(
          (studentName) => StudentRegisterBookTableCompanion.insert(
            registerBook: data.registerBookId,
            student: studentName
          )
        )));
        return Success(data: true);
      } catch (e) { return NawiRepositoryUtils.onCatch(e); }
    });
  }

  /// De un [RegisterBookTableData] con una lista de [StudentTableData] comprimido en [RegisterBookWithEmisorsTableData], se actualizan en la tabla de
  /// [StudentRegisterBookTable].
  /// 
  /// PD: Se usa un borrado previo para luego volver a agregarlos
  Future<Result<bool>> updateMany(RegisterBookWithEmisorsTableData data) {
    return transaction<Result<bool>>(() async {
      try {
        //* Se elimina primero
        final deletedResult = await deleteManyByRegisterBookID(data.registerBookId);
        if(deletedResult is NawiError<bool>) throw NawiError.onRepository(message: "No se pudo borrar los cuadernos de registro previos");

        //* Y se vuelven a agregar
        final addedResult = await addMany(data);
        if(addedResult is NawiError<bool>) NawiError.onRepository(message: "No se pudo volver a agregar los cuadernos de registro");

        return Success(data: true);
      } catch (e) { return NawiRepositoryUtils.onCatch(e); }
    });
  }

  /// Elimina los registros donde exista [registerBookId]
  Future<Result<bool>> deleteManyByRegisterBookID(String registerBookId) async {
    try {
      final deleteStatement = delete(studentRegisterBookTable)..where((tbl) => tbl.registerBook.equals(registerBookId));
      await deleteStatement.go();
      return Success(data: true);
    } catch (e) { return NawiRepositoryUtils.onCatch(e); }
  }

  /// Elimina los registros donde exista [studentId], ademas de borrar los cuadernos de registro de la tabla [RegisterBookTable] involucrados si [deleteRegisterBooks] es `true`
  Future<Result<bool>> deleteManyByStudentID({required String studentId, bool deleteRegisterBooks = false}) {
    return transaction<Result<bool>>(() async {
      try {
        final selectedRegisterBook = await (select(studentRegisterBookTable)..where((tbl) => tbl.student.equals(studentId))).get();
        if(selectedRegisterBook.isEmpty) return Success(data: true);
        
        final registerBookIDs = selectedRegisterBook.map((e) => e.registerBook);
        
        await (
          delete(studentRegisterBookTable)..where((tbl) => tbl.registerBook.isIn(registerBookIDs))
        ).go();
        
        if(deleteRegisterBooks) {
          await (
            delete(registerBookTable)..where((tbl) => tbl.id.isIn(registerBookIDs))
          ).go();
        }

        return Success(data: true);
      } catch (e) { return NawiRepositoryUtils.onCatch(e); }
    });
  }

  /// Obtiene una lista de [StudentViewSummaryVersion] de un registro de un [RegisterBookTable] en base a la tabla many to many
  /// [StudentRegisterBookTable]
  Future<Result<List<StudentViewSummaryVersionData>>> getStudentsFromRegisterBook(String registerBookId) async {
    try {
      final studentList = await (
        (select(studentViewSummaryVersion))
          ..where((tblStudent) => tblStudent.id.isInQuery(

            selectOnly(studentRegisterBookTable)
              ..addColumns([studentRegisterBookTable.student])
              ..where(studentRegisterBookTable.registerBook.equals(registerBookId)
            )
          )
        )
      ).get();
      return Success(data: studentList);
    } catch (e) { return NawiRepositoryUtils.onCatch(e); }
  }

  /// Obtiene una lista de [RegisterBookViewSummaryVersionData] en base a [studentIds], solo las coincidencias encontradas.
  /// 
  /// Si se eligiera más de una id en [studentIds], la busqueda se hará como si fuera un `OR` en cada ID.
  Future<Result<Iterable<RegisterBookViewSummaryVersionData>>> getRegisterBookWithSelectedStudents(Iterable<String> studentIds) async {
    try {
      final registerBookList = await (
        select(registerBookViewSummaryVersion)..where((tbl) => tbl.id.isInQuery(
          selectOnly(studentRegisterBookTable)
            ..addColumns([studentRegisterBookTable.registerBook])
            ..where(studentRegisterBookTable.student.isIn(studentIds))
          )
        )
      ).get();

      return Success(data: registerBookList);
    } catch (e) { return NawiRepositoryUtils.onCatch(e); }
  }
}