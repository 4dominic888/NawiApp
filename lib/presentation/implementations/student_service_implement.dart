import 'package:nawiapp/domain/classes/count_ratio.dart';
import 'package:nawiapp/domain/classes/paginated_data.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/classes/stat_summary/student_stat.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/data/mappers/student_mapper.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/domain/daos/student_register_book_dao.dart';
import 'package:nawiapp/domain/daos/student_dao.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';

interface class StudentServiceImplement extends StudentServiceBase {

  final StudentDAO studentRepo;
  final StudentRegisterBookDAO studentRegisterBookRepo;
  StudentServiceImplement(this.studentRepo, this.studentRegisterBookRepo);

  @override
  Future<Result<Student>> addOne(Student data) async {
    data = data.copyWith(name: data.name.titleCase);
    final result = await studentRepo.addOne(data.toTableCompanion(withId: Uuid.isValidUUID(fromString: data.id)));
    return result.convertTo((value) => StudentMapper.fromTableData(value!), origin: NawiErrorOrigin.service);
  }

  @override
  Future<Result<Iterable<StudentSummary>>> getAll(StudentFilter params) async {
    final result = await studentRepo.getAll(params);
    return result.convertTo((value) => value.map((e) => StudentSummaryMapper.fromSummaryView(e)));
  }

  @override
  Future<Result<PaginatedData<StudentSummary>>> getAllPaginated({required int pageSize, required int currentPage, required StudentFilter params}) async {
    final result = await getAll(params.copyWith(pageSize: pageSize, currentPage: currentPage));
    return result.convertTo((value) => PaginatedData.build(currentPage: currentPage, pageSize: pageSize, data: result.getValue!));
  }

  @override
  Stream<int> getAllCount(StudentFilter params) => studentRepo.getAllCount(params);

  @override
  Future<Result<Student>> getOne(String id) async {
    final studentTableDataResult = await studentRepo.getOne(id);
    return studentTableDataResult.convertTo(
      (value) => StudentMapper.fromTableData(studentTableDataResult.getValue!)
    );
  }

  @override
  Future<Result<bool>> updateOne(Student data) => studentRepo.updateOne(data.toTableData);
  
  @override
  Future<Result<Student>> deleteOne(String id) {
    return studentRepo.transaction<Result<Student>>(() async {
      //* Eliminacion de registros relacionados de la tabla StudentRegisterBookTable
      final deleteManyToManyResult = await studentRegisterBookRepo.deleteManyByStudentID(studentId: id, deleteRegisterBooks: true);
      if(deleteManyToManyResult is NawiError) return deleteManyToManyResult.getError()!;

      //* Eliminación del estudiante en cuestion
      final deleteStudentResult = await studentRepo.deleteOne(id);
      if(deleteStudentResult is NawiError) return deleteStudentResult.getError()!;

      return deleteStudentResult.convertTo((value) => StudentMapper.fromTableData(deleteStudentResult.getValue!));
    });
  }
  
  @override
  Future<Result<Student>> archiveOne(String id) async {
    final result = await studentRepo.archiveOne(id);
    return result.convertTo((value) => StudentMapper.fromTableData(value));
  }

  @override
  Future<Result<Student>> unarchiveOne(String id) async {
    final result = await studentRepo.unarchiveOne(id);
    return result.convertTo((value) => StudentMapper.fromTableData(value));
  }

  @override
  Stream<StudentStat> getStudentStat(String classroomId) => studentRepo.getGeneralStudentStat(classroomId).map((event) {
    final columns = event.rawData.data.values;
    final threeCount = columns.elementAt(0) as int;
    final fourCount = columns.elementAt(1) as int;
    final fiveCount = columns.elementAt(2) as int;
    final total = columns.elementAt(3) as int;
    return StudentStat(
      threeAgeCount: CountRatio(count: threeCount, percent: NawiGeneralUtils.getPercent(threeCount, total)),
      fourAgeCount: CountRatio(count: fourCount, percent: NawiGeneralUtils.getPercent(fourCount, total)),
      fiveAgeCount: CountRatio(count: fiveCount, percent: NawiGeneralUtils.getPercent(fiveCount, total)),
      total: total
    );
  });
}