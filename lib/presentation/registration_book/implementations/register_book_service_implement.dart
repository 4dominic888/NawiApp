import 'package:nawiapp/domain/classes/paginated_data.dart';
import 'package:nawiapp/domain/classes/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/register_book.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/domain/repositories/register_book_repository.dart';
import 'package:nawiapp/domain/repositories/student_register_book_repository.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';

interface class RegisterBookServiceImplement extends RegisterBookServiceBase {

  final StudentRegisterBookRepository studentRegisterBookRepo;
  final RegisterBookRepository registerBookRepo;

  RegisterBookServiceImplement(this.registerBookRepo, this.studentRegisterBookRepo);

  @override
  Future<Result<RegisterBook>> addOne(RegisterBook data) {
    return registerBookRepo.transaction<Result<RegisterBook>>(() async {
      //* Agregado del cuaderno de registro a la tabla
      final addedRegisterBookResult = await registerBookRepo.addOne(NawiServiceTools.toRegisterBookTableCompanion(data));
      if(addedRegisterBookResult is Error) return NawiServiceTools.errorParser(addedRegisterBookResult);

      final addedStudentsOnRegisterBookResult = await studentRegisterBookRepo.addMany((
        emisors: data.mentions.map((e) => e.id),
        registerBookId: data.id
      ));
      if(addedStudentsOnRegisterBookResult is Error) return NawiServiceTools.errorParser(addedStudentsOnRegisterBookResult);

      return NawiTools.resultConverter(addedRegisterBookResult, (value) => RegisterBook.fromTableData(value!, data.mentions));
    });
  }

  @override
  Future<Result<RegisterBook>> deleteOne(String id) {
    return registerBookRepo.transaction<Result<RegisterBook>>(() async {
      final deleteManyToManyRelationResult = await studentRegisterBookRepo.deleteManyByRegisterBookID(id);
      if(deleteManyToManyRelationResult is Error) return NawiServiceTools.errorParser(deleteManyToManyRelationResult);

      final deleteRegisterBookResult = await registerBookRepo.deleteOne(id);
      if(deleteRegisterBookResult is Error) return NawiServiceTools.errorParser(deleteRegisterBookResult);

      return NawiTools.resultConverter(deleteRegisterBookResult, (value) => RegisterBook.fromTableData(value, const []));
    });
  }

  @override
  Future<Result<bool>> updateOne(RegisterBook data) {
    return registerBookRepo.transaction<Result<bool>>(() async {
      final updatedRegisterBookResult = await registerBookRepo.updateOne(data.toTable);
      if(updatedRegisterBookResult is Error) return NawiServiceTools.errorParser(updatedRegisterBookResult);

      final updateManyToManyResult = await studentRegisterBookRepo.updateMany((
        registerBookId: data.id,
        emisors: data.mentions.map((e) => e.id)
      ));
      if(updateManyToManyResult is Error) return NawiServiceTools.errorParser(updateManyToManyResult);
      return updatedRegisterBookResult;
    });
  }

  @override
  Future<Result<List<RegisterBookDAO>>> getAll(RegisterBookFilter params) {
    return registerBookRepo.transaction<Result<List<RegisterBookDAO>>>(() async {

      //* Obtiene los cuadernos de registro sin estudiantes
      final gotRawRegisterBookResult = await registerBookRepo.getAll(params);
      if(gotRawRegisterBookResult is Error) return NawiServiceTools.errorParser(gotRawRegisterBookResult);

      return Success(data: await Future.wait(
        gotRawRegisterBookResult.getValue!.map((e) async {
          //* Obtiene un Iterable de estudiantes segun el cuaderno de registro
          final mentionsResult = await studentRegisterBookRepo.getStudentsFromRegisterBook(e.id);

          //* Parsing
          return RegisterBookDAO.fromDAOView(data: e,
            mentions: (mentionsResult is Error) ? const [] : mentionsResult.getValue!.map((s) => StudentDAO.fromDAOView(s))
          );
        })
      ));
    });
  }

  @override
  Future<Result<PaginatedData<RegisterBookDAO>>> getAllPaginated({required int pageSize, required int currentPage, required RegisterBookFilter params}) {
    return getAll(params).then(
      (result) => NawiTools.resultConverter(result, (value) => PaginatedData.build(
        currentPage: currentPage,
        pageSize: pageSize,
        data: value
      )),
      onError: NawiServiceTools.defaultErrorFunction
    );
  }

  @override
  Future<Result<RegisterBook>> getOne(String id) {
    return registerBookRepo.transaction(() async {
      final studentOnRegisterBookResult = await studentRegisterBookRepo.getStudentsFromRegisterBook(id);
      if(studentOnRegisterBookResult is Error) return NawiServiceTools.errorParser(studentOnRegisterBookResult);

      return registerBookRepo.getOne(id).then(
        (value) => NawiTools.resultConverter(value, (result) => RegisterBook.fromTableData(
          result, studentOnRegisterBookResult.getValue!.map((e) => StudentDAO.fromDAOView(e))
        ))
      );
    });
  }

  @override
  Future<Result<RegisterBook>> archiveOne(String id) {
    return registerBookRepo.archiveOne(id).then(
      (result) => NawiTools.resultConverter(result, (value) => RegisterBook.fromTableData(value, const [])),
      onError: NawiServiceTools.defaultErrorFunction
    );
  }

  @override
  Future<Result<RegisterBook>> unarchiveOne(String id) {
    return registerBookRepo.unarchiveOne(id).then(
      (result) => NawiTools.resultConverter(result, (value) => RegisterBook.fromTableData(value, const [])),
      onError: NawiServiceTools.defaultErrorFunction
    );
  }
}