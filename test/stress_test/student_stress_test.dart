import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';

import '../nawi_test_utils.dart' as testil;
import 'resource_usage.dart';

void main() {

  setUp(testil.setupIntegrationTestLocator);
  tearDown(testil.onTearDownSetupIntegrationTestLocator);

  const addedStudentResourceUsage = ResourceUsage(
    memoryKb: 113848,
    idleCpuTicks: 562,
    totalCpuTicks: 997,
    systemCpuTicks: 22,
    userCpuTicks: 274
  );

  const addStudentTimeDiff = 2360;

  List<Future<Result<Student>>> insertStudents(int n) {
    final service = GetIt.I<StudentServiceBase>();
    return List.generate(n, (i) {
      return service.addOne(Student(
        name: "Estudiante $i",
        age: StudentAge.fourYears,
        classroomId: '6615024f-0153-4492-b06e-0cb108f90ac6',
      ));
    });
  }

  test('Stress: Insertar 10,000 estudiantes', () => measureResourceUsage(() async {
    final futures = insertStudents(10000);

    final results = await Future.wait(futures);
    final successfulInserts = results.whereType<Success>().length;

    testil.customExpect(successfulInserts, 10000,
      about: "10,000 estudiantes insertados", n: 1
    );
  }), timeout: const Timeout(Duration(seconds: 15)) );

  test('Stress: Eliminar 10,000 estudiantes', () => measureResourceUsage(() async {
    final service = GetIt.I<StudentServiceBase>();

    final added = await Future.wait(insertStudents(10000));

    final ids = added.map((e) => e.getValue!.id).toList();
    final results = await Future.wait(ids.map((id) => service.deleteOne(id)));

    final successfulDeletes = results.whereType<Success>().length;

    testil.customExpect(successfulDeletes, 10000,
      about: "10,000 estudiantes eliminados", n: 1
    );
  }, diffMillis: addStudentTimeDiff, diffSubtract: addedStudentResourceUsage ), timeout: const Timeout(Duration(seconds: 18)));

  test('Stress: Actualizar 10,000 estudiantes simultáneamente', () => measureResourceUsage(() async {
    final service = GetIt.I<StudentServiceBase>();

    final added = await Future.wait(insertStudents(10000));

    final updates = added.map((result) {
      final student = result.getValue!;
      return service.updateOne(student.copyWith(name: "${student.name} Actualizado"));
    }).toList();

    final results = await Future.wait(updates);
    final successfulUpdates = results.whereType<Success>().length;

    testil.customExpect(successfulUpdates, 10000,
      about: "10,000 estudiantes actualizados", n: 1
    );
  }, diffMillis: addStudentTimeDiff, diffSubtract: addedStudentResourceUsage ), timeout: const Timeout(Duration(seconds: 18)));

  test('Stress: Leer 10,000 estudiantes en paralelo', () => measureResourceUsage(() async {
    final service = GetIt.I<StudentServiceBase>();

    final added = await Future.wait(insertStudents(10000));

    final ids = added.map((e) => e.getValue!.id).toList();
    final reads = await Future.wait(ids.map((id) => service.getOne(id)));


    final successfulReads = reads.whereType<Success>().length;

    testil.customExpect(successfulReads, 10000,
      about: "10,000 estudiantes leídos", n: 1
    );
  }, diffMillis: addStudentTimeDiff, diffSubtract: addedStudentResourceUsage ), timeout: const Timeout(Duration(seconds: 18)));

}