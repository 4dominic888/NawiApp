import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';
import 'package:nawiapp/domain/services/classroom_service_base.dart' as testil;

import '../nawi_test_utils.dart' as testil;
import 'resource_usage.dart';

void main() {
  setUp(() async => await testil.setupIntegrationTestLocator(withRegisterBook: true));
  tearDown(testil.onTearDownSetupIntegrationTestLocator);

  const addedClassroomResourceUsage = ResourceUsage(
    memoryKb: 111960,
    idleCpuTicks: 512,
    totalCpuTicks: 940,
    systemCpuTicks: 19,
    userCpuTicks: 265
  );

  const addClassroomTimeDiff = 2372;

  List<Future<Result<Classroom>>> insertClassrooms(int n) {
    final service = GetIt.I<testil.ClassroomServiceBase>();
    return List.generate(n, (i) {
      return service.addOne(Classroom(
        name: "Clase $i",
        createdAt: DateTime.now(),
      ));
    });
  }

  test('Stress: Insertar 10,000 clases', () => measureResourceUsage(() async {
    final futures = insertClassrooms(10000);

    final results = await Future.wait(futures);
    final successfulInserts = results.whereType<Success>().length;

    testil.customExpect(successfulInserts, 10000,
      about: "10,000 clases insertadas", n: 1
    );
  }), timeout: const Timeout(Duration(seconds: 15)));

  test('Stress: Eliminar 10,000 clases', () => measureResourceUsage(() async {
    final service = GetIt.I<testil.ClassroomServiceBase>();

    final added = await Future.wait(insertClassrooms(10000));

    final ids = added.map((e) => e.getValue!.id).toList();
    final results = await Future.wait(ids.map((id) => service.deleteOne(id)));

    final successfulDeletes = results.whereType<Success>().length;

    testil.customExpect(successfulDeletes, 10000,
      about: "10,000 clases eliminadas", n: 1
    );
  }, diffMillis: addClassroomTimeDiff, diffSubtract: addedClassroomResourceUsage ), timeout: const Timeout(Duration(seconds: 18)));

  test('Stress: Actualizar 10,000 clases simultáneamente', () => measureResourceUsage(() async {
    final service = GetIt.I<testil.ClassroomServiceBase>();

    final added = await Future.wait(insertClassrooms(10000));

    final updates = added.map((result) {
      final classroom = result.getValue!;
      return service.updateOne(classroom.copyWith(name: "${classroom.name} Actualizado"));
    }).toList();

    final results = await Future.wait(updates);
    final successfulUpdates = results.whereType<Success>().length;

    testil.customExpect(successfulUpdates, 10000,
      about: "10,000 clases actualizadas", n: 1
    );
  }, diffMillis: addClassroomTimeDiff, diffSubtract: addedClassroomResourceUsage ), timeout: const Timeout(Duration(seconds: 18)));

  test('Stress: Leer 10,000 clases en paralelo', () => measureResourceUsage(() async {
    final service = GetIt.I<testil.ClassroomServiceBase>();

    final added = await Future.wait(insertClassrooms(10000));

    final ids = added.map((e) => e.getValue!.id).toList();
    final reads = await Future.wait(ids.map((id) => service.getOne(id)));

    final successfulReads = reads.whereType<Success>().length;

    testil.customExpect(successfulReads, 10000,
      about: "10,000 clases leídas", n: 1
    );
  }, diffMillis: addClassroomTimeDiff, diffSubtract: addedClassroomResourceUsage ), timeout: const Timeout(Duration(seconds: 18))); 
}