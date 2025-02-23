import 'package:drift/drift.dart';
import 'package:nawiapp/data/database_connection.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/models_table/student_register_book_table.dart';

part 'student_register_book_repository.g.dart';

typedef RegisterBookWithEmisorsTableData = ({
  RegisterBookTableData registerBook,
  List<StudentTableData> emisors,
});

@DriftAccessor(tables: [StudentRegisterBookTable])
class StudentRegisterBookRepository extends DatabaseAccessor<NawiDatabase> with _$StudentRegisterBookRepositoryMixin {
  
  StudentRegisterBookRepository(super.db);

  Future<Result<bool>> addMany(RegisterBookWithEmisorsTableData data) async {
    return await transaction<Result<bool>>(() async {
      try {
        final registerBookId = data.registerBook.id; final emisors = data.emisors;
        await batch((batch) => batch.insertAll(studentRegisterBookTable, emisors.map(
          (e) => StudentRegisterBookTableCompanion.insert(registerBook: registerBookId, student: e.id)
        )));
        return Success(data: true);
      } catch (e) { return Error.onRepository(message: e.toString()); }
    });
  }

  // Future<Result<List<StudentRegisterBookTableData>>> getAll({required int pageSize, required int currentPage}) async{
  //   return (select(studentRegisterBookTable)..limit(pageSize, offset: (currentPage - 1) * pageSize)).get().then(
  //     (result) => Success(data: result), onError: NawiRepositoryTools.defaultErrorFunction
  //   );
  // }

  Future<Result<bool>> updateOne(RegisterBookWithEmisorsTableData data) async {
    return await transaction<Result<bool>>(() async {
      try {
        final registerBookId = data.registerBook.id; final emisors = data.emisors;

        //* Deleting first
        await batch((batch) => batch.deleteWhere(studentRegisterBookTable, (tbl) => tbl.registerBook.equals(registerBookId)));

        //* Add again
        await batch((batch) => batch.insertAll(studentRegisterBookTable, emisors.map(
          (e) => StudentRegisterBookTableCompanion.insert(registerBook: registerBookId, student: e.id)
        )));

        return Success(data: true);
      } catch (e) { return Error.onRepository(message: e.toString()); }
    });
  }

  Future<Result<bool>> deleteOne(RegisterBookWithEmisorsTableData data) async {
    return await transaction<Result<bool>>(() async {
      try {
        final registerBookId = data.registerBook.id;;
        await batch((batch) => batch.deleteWhere(studentRegisterBookTable, (tbl) => tbl.registerBook.equals(registerBookId)));

        return Success(data: true);
      } catch (e) { return Error.onRepository(message: e.toString()); }
    });
  }
}