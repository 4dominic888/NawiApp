import 'package:nawiapp/data/mappers/register_book_mapper.dart';
import 'package:nawiapp/data/mappers/student_mapper.dart';
import 'package:nawiapp/domain/classes/paginated_data.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/domain/daos/register_book_dao.dart';
import 'package:nawiapp/domain/daos/student_register_book_dao.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:uuid/uuid.dart';

interface class RegisterBookServiceImplement extends RegisterBookServiceBase {

  final StudentRegisterBookRepository studentRegisterBookRepo;
  final RegisterBookRepository registerBookRepo;

  RegisterBookServiceImplement(this.registerBookRepo, this.studentRegisterBookRepo);

  @override
  Future<Result<RegisterBook>> addOne(RegisterBook data) {
    return registerBookRepo.transaction<Result<RegisterBook>>(() async {
      //* Agregado del cuaderno de registro a la tabla
      final addedRegisterBookResult = await registerBookRepo.addOne(data.toTableCompanion(withId: Uuid.isValidUUID(fromString: data.id)));
      if(addedRegisterBookResult is NawiError) return addedRegisterBookResult.getError()!;

      final addedStudentsOnRegisterBookResult = await studentRegisterBookRepo.addMany((
        mentions: data.mentions.map((e) => e.id),
        registerBookId: addedRegisterBookResult.getValue!.id
      ));

      if(addedStudentsOnRegisterBookResult is NawiError) return addedStudentsOnRegisterBookResult.getError()!;

      return addedRegisterBookResult.convertTo((value) => RegisterBookMapper.fromTableData(value, data.mentions));
    });
  }

  @override
  Future<Result<RegisterBook>> deleteOne(String id) {
    return registerBookRepo.transaction<Result<RegisterBook>>(() async {
      final deleteManyToManyRelationResult = await studentRegisterBookRepo.deleteManyByRegisterBookID(id);
      if(deleteManyToManyRelationResult is NawiError) deleteManyToManyRelationResult.getError()!;

      final deleteRegisterBookResult = await registerBookRepo.deleteOne(id);
      if(deleteRegisterBookResult is NawiError) return deleteRegisterBookResult.getError()!;

      return deleteRegisterBookResult.convertTo((value) => RegisterBookMapper.fromTableData(value, const []));
    });
  }

  @override
  Future<Result<bool>> updateOne(RegisterBook data) {
    return registerBookRepo.transaction<Result<bool>>(() async {
      final updatedRegisterBookResult = await registerBookRepo.updateOne(data.toTable);
      if(updatedRegisterBookResult is NawiError) return updatedRegisterBookResult.getError()!;

      final updateManyToManyResult = await studentRegisterBookRepo.updateMany((
        registerBookId: data.id,
        mentions: data.mentions.map((e) => e.id)
      ));
      if(updateManyToManyResult is NawiError) return updateManyToManyResult.getError()!;
      return updatedRegisterBookResult;
    });
  }

  @override
  Future<Result<Iterable<RegisterBookSummary>>> getAll(RegisterBookFilter params) {
    return registerBookRepo.transaction<Result<List<RegisterBookSummary>>>(() async {

      //* Obtiene los cuadernos de registro sin estudiantes
      final gotRawRegisterBookResult = await registerBookRepo.getAll(params);
      if(gotRawRegisterBookResult is NawiError) return gotRawRegisterBookResult.getError()!;

      return Success(data: await Future.wait(
        gotRawRegisterBookResult.getValue!.map((e) async {
          //* Obtiene un Iterable de estudiantes segun el cuaderno de registro
          final mentionsResult = await studentRegisterBookRepo.getStudentsFromRegisterBook(e.id);

          //* Parsing
          return RegisterBookSummaryMapper.fromSummaryView(data: e,
            mentions: (mentionsResult is NawiError) ? const [] : mentionsResult.getValue!.map((s) => StudentSummaryMapper.fromSummaryView(s))
          );
        })
      ));
    });
  }

  @override
  Future<Result<PaginatedData<RegisterBookSummary>>> getAllPaginated({required int pageSize, required int currentPage, required RegisterBookFilter params}) async {
    final result = await getAll(params.copyWith(pageSize: pageSize, currentPage: currentPage));
    return result.convertTo((value) => PaginatedData.build(currentPage: currentPage, pageSize: pageSize, data: result.getValue!));
  }

  @override
  Future<Result<RegisterBook>> getOne(String id) {
    return registerBookRepo.transaction(() async {
      final studentOnRegisterBookResult = await studentRegisterBookRepo.getStudentsFromRegisterBook(id);
      if(studentOnRegisterBookResult is NawiError) return studentOnRegisterBookResult.getError()!;
      final result = await registerBookRepo.getOne(id);
      return result.convertTo( 
        (value) => 
          RegisterBookMapper.fromTableData(value, studentOnRegisterBookResult.getValue!.map<StudentSummary>(
            (e) => StudentSummaryMapper.fromSummaryView(e)
          )
        )
      );
    });
  }

  @override
  Future<Result<RegisterBook>> archiveOne(String id) async {
    final result = await registerBookRepo.archiveOne(id);
    return result.convertTo((value) => RegisterBookMapper.fromTableData(value, const []));
  }

  @override
  Future<Result<RegisterBook>> unarchiveOne(String id) async {
    final result = await registerBookRepo.unarchiveOne(id);
    return result.convertTo((value) => RegisterBookMapper.fromTableData(value, const []));
  }
}