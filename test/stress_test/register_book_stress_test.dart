import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/mappers/student_mapper.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';

import '../nawi_test_utils.dart' as testil;
import 'resource_usage.dart';

void main() {
  setUp(() async => await testil.setupIntegrationTestLocator(withRegisterBook: true));
  tearDown(testil.onTearDownSetupIntegrationTestLocator);

  const addedRegisterBookResourceUsage = ResourceUsage(
    memoryKb: 32864,
    idleCpuTicks: 279,
    totalCpuTicks: 486,
    systemCpuTicks: 7,
    userCpuTicks: 143
  );

  const addRegisterBookTimeDiff = 1222;

  List<Future<Result<RegisterBook>>> insertRegisterBooks(int n) {
    final service = GetIt.I<RegisterBookServiceBase>();
    return List.generate(n, (i) {
      return service.addOne(RegisterBook(
        action: "Acción #$i",
        mentions: [testil.listOfStudents[i % testil.listOfStudents.length].toStudentSummary],
        createdAt: DateTime.now(),
        classroomId: '6615024f-0153-4492-b06e-0cb108f90ac6',
      ));
    });
  }

  test('Stress: Insertar 1,000 de cuaderno de registro', () => measureResourceUsage(() async {
    final futures = insertRegisterBooks(1000);

    final results = await Future.wait(futures);
    final successfulInserts = results.whereType<Success>().length;

    testil.customExpect(successfulInserts, 1000,
      about: "1000 registros insertados", n: 1
    );
  }), timeout: const Timeout(Duration(seconds: 15)));

  test('Stress: Eliminar 1,000 de cuaderno de registro', () => measureResourceUsage(() async {
    final service = GetIt.I<RegisterBookServiceBase>();

    final added = await Future.wait(insertRegisterBooks(1000));

    final ids = added.map((e) => e.getValue!.id).toList();
    final results = await Future.wait(ids.map((id) => service.deleteOne(id)));

    final successfulDeletes = results.whereType<Success>().length;

    testil.customExpect(successfulDeletes, 1000,
      about: "1000 registros eliminados", n: 1
    );
  }, diffMillis: addRegisterBookTimeDiff, diffSubtract: addedRegisterBookResourceUsage ), timeout: const Timeout(Duration(seconds: 18)));

  test('Stress: Actualizar 1,000 de cuaderno de registro simultáneamente', () => measureResourceUsage(() async {
    final service = GetIt.I<RegisterBookServiceBase>();

    final added = await Future.wait(insertRegisterBooks(1000));

    final updates = added.map((result) {
      final registerBook = result.getValue!;
      return service.updateOne(registerBook.copyWith(action: "${registerBook.action} Actualizado"));
    }).toList();

    final results = await Future.wait(updates);
    final successfulUpdates = results.whereType<Success>().length;

    testil.customExpect(successfulUpdates, 1000,
      about: "1000 registros actualizados", n: 1
    );
  }, diffMillis: addRegisterBookTimeDiff, diffSubtract: addedRegisterBookResourceUsage ), timeout: const Timeout(Duration(seconds: 18)));

  test('Stress: Leer 1,000 de cuaderno de registro en paralelo', () => measureResourceUsage(() async {
    final service = GetIt.I<RegisterBookServiceBase>();

    final added = await Future.wait(insertRegisterBooks(1000));

    final ids = added.map((e) => e.getValue!.id).toList();
    final reads = await Future.wait(ids.map((id) => service.getOne(id)));

    final successfulReads = reads.whereType<Success>().length;

    testil.customExpect(successfulReads, 1000,
      about: "1000 registros leídos", n: 1
    );
  }, diffMillis: addRegisterBookTimeDiff, diffSubtract: addedRegisterBookResourceUsage ), timeout: const Timeout(Duration(seconds: 18)));

}