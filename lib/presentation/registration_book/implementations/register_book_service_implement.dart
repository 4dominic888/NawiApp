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
      if(addedRegisterBookResult is NawiError) return NawiTools.errorParser(addedRegisterBookResult);

      final addedStudentsOnRegisterBookResult = await studentRegisterBookRepo.addMany((
        emisors: data.mentions.map((e) => e.id),
        registerBookId: data.id
      ));
      if(addedStudentsOnRegisterBookResult is NawiError) return NawiTools.errorParser(addedStudentsOnRegisterBookResult);

      return NawiTools.resultConverter(addedRegisterBookResult, (value) => RegisterBook.fromTableData(value, data.mentions));
    });
  }

  @override
  Future<Result<RegisterBook>> deleteOne(String id) {
    return registerBookRepo.transaction<Result<RegisterBook>>(() async {
      final deleteManyToManyRelationResult = await studentRegisterBookRepo.deleteManyByRegisterBookID(id);
      if(deleteManyToManyRelationResult is NawiError) return NawiTools.errorParser(deleteManyToManyRelationResult);

      final deleteRegisterBookResult = await registerBookRepo.deleteOne(id);
      if(deleteRegisterBookResult is NawiError) return NawiTools.errorParser(deleteRegisterBookResult);

      return NawiTools.resultConverter(deleteRegisterBookResult, (value) => RegisterBook.fromTableData(value, const []));
    });
  }

  @override
  Future<Result<bool>> updateOne(RegisterBook data) {
    return registerBookRepo.transaction<Result<bool>>(() async {
      final updatedRegisterBookResult = await registerBookRepo.updateOne(data.toTable);
      if(updatedRegisterBookResult is NawiError) return NawiTools.errorParser(updatedRegisterBookResult);

      final updateManyToManyResult = await studentRegisterBookRepo.updateMany((
        registerBookId: data.id,
        emisors: data.mentions.map((e) => e.id)
      ));
      if(updateManyToManyResult is NawiError) return NawiTools.errorParser(updateManyToManyResult);
      return updatedRegisterBookResult;
    });
  }

  @override
  Future<Result<Iterable<RegisterBookDAO>>> getAll(RegisterBookFilter params) {
    return registerBookRepo.transaction<Result<List<RegisterBookDAO>>>(() async {

      //* Obtiene los cuadernos de registro sin estudiantes
      final gotRawRegisterBookResult = await registerBookRepo.getAll(params);
      if(gotRawRegisterBookResult is NawiError) return NawiTools.errorParser(gotRawRegisterBookResult);

      return Success(data: await Future.wait(
        gotRawRegisterBookResult.getValue!.map((e) async {
          //* Obtiene un Iterable de estudiantes segun el cuaderno de registro
          final mentionsResult = await studentRegisterBookRepo.getStudentsFromRegisterBook(e.id);

          //* Parsing
          return RegisterBookDAO.fromDAOView(data: e,
            mentions: (mentionsResult is NawiError) ? const [] : mentionsResult.getValue!.map((s) => StudentDAO.fromDAOView(s))
          );
        })
      ));
    });
  }

  @override
  Future<Result<PaginatedData<RegisterBookDAO>>> getAllPaginated({required int pageSize, required int currentPage, required RegisterBookFilter params}) async {
    final result = await getAll(params.copyWith(pageSize: pageSize, currentPage: currentPage));
    return NawiTools.resultConverter(result, (value) => PaginatedData.build(currentPage: currentPage, pageSize: pageSize, data: result.getValue!));
  }

  @override
  Future<Result<RegisterBook>> getOne(String id) {
    return registerBookRepo.transaction(() async {
      final studentOnRegisterBookResult = await studentRegisterBookRepo.getStudentsFromRegisterBook(id);
      if(studentOnRegisterBookResult is NawiError) return NawiTools.errorParser(studentOnRegisterBookResult);
      final result = await registerBookRepo.getOne(id);
      return NawiTools.resultConverter(result, 
        (value) => 
          RegisterBook.fromTableData(value, studentOnRegisterBookResult.getValue!.map(
            (e) => StudentDAO.fromDAOView(e)
          )
        )
      );
    });
  }

  @override
  Future<Result<RegisterBook>> archiveOne(String id) async {
    final result = await registerBookRepo.archiveOne(id);
    return NawiTools.resultConverter(result, (value) => RegisterBook.fromTableData(value, const []));
  }

  @override
  Future<Result<RegisterBook>> unarchiveOne(String id) async {
    final result = await registerBookRepo.unarchiveOne(id);
    return NawiTools.resultConverter(result, (value) => RegisterBook.fromTableData(value, const []));
  }
}