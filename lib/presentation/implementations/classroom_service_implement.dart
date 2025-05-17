import 'package:nawiapp/data/mappers/classroom_mapper.dart';
import 'package:nawiapp/domain/classes/filter/classroom_filter.dart';
import 'package:nawiapp/domain/classes/paginated_data.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/daos/classroom_dao.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';
import 'package:nawiapp/domain/services/classroom_service_base.dart';
import 'package:uuid/uuid.dart';

interface class ClassroomServiceImplement extends ClassroomServiceBase {

  final ClassroomDAO classroomDAO;
  ClassroomServiceImplement(this.classroomDAO);

  @override
  Future<Result<Classroom>> addOne(Classroom data) async {
    final result = await classroomDAO.addOne(data.toTableCompanion(withId: Uuid.isValidUUID(fromString: data.id)));
    return result.convertTo((value) => ClassroomMapper.fromTableData(value), origin: NawiErrorOrigin.service);
  }

  @override
  Future<Result<Iterable<Classroom>>> getAll(ClassroomFilter params) async {
    final result = await classroomDAO.getAll(params);
    return result.convertTo((value) => value.map((e) => ClassroomMapper.fromTableData(e)));
  }

  @override
  Future<Result<PaginatedData<Classroom>>> getAllPaginated({required int pageSize, required int currentPage, required ClassroomFilter params}) async {
    final result = await getAll(params.copyWith(pageSize: pageSize, currentPage: currentPage));
    return result.convertTo((value) => PaginatedData.build(currentPage: currentPage, pageSize: pageSize, data: result.getValue!));
  }

  @override
  Future<Result<Classroom>> getOne(String id) async {
    final classroomTableDataResult = await classroomDAO.getOne(id);
    return classroomTableDataResult.convertTo(
      (value) => ClassroomMapper.fromTableData(classroomTableDataResult.getValue!),
    );
  }

  @override
  Future<Result<bool>> updateOne(Classroom data) => classroomDAO.updateOne(data.toTableData);

  @override
  Future<Result<Classroom>> deleteOne(String id) async {
    final deleteResult = await classroomDAO.deleteOne(id);
    return deleteResult.convertTo((value) => ClassroomMapper.fromTableData(deleteResult.getValue!));
  }
}