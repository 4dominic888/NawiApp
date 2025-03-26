import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/register_book.dart';
import 'package:nawiapp/domain/repositories/student_register_book_repository.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';

import '../nawi_test_utils.dart';

void main() {
  setUp(() async => await NawiTestUtils.setupTestLocator(withRegisterBook: true));
  tearDown(NawiTestUtils.onTearDownSetupLocator);

  test('Registro de un cuaderno de registro', () async {
    final service = GetIt.I<RegisterBookServiceBase>();

    final registerBook = RegisterBook(action: "Accion X", mentions: [NawiTestUtils.listOfStudents[1].toStudentDAO, NawiTestUtils.listOfStudents[0].toStudentDAO]);
    final diffRegisterBook = RegisterBook(action: "Accion Y");

    final result = await service.addOne(registerBook);
    final registerBookFromDB = await service.getOne(result.getValue!.id);

    expect(registerBookFromDB.getValue, isNotNull); //* El get deberia funcionar
    debugPrint("Expect 1 of 5 for AddOne() passed!");
    expect(result.getValue!.action, registerBook.action); //* El atributo de accion del cuaderno de registro no debe diferir
    debugPrint("Expect 2 of 5 for AddOne() passed!");
    expect(result.getValue!.action, isNot(diffRegisterBook.action)); //* Se vuelve a comprobar con otro registro que nunca fue agregado
    debugPrint("Expect 3 of 5 for AddOne() passed!");
    expect(registerBookFromDB.getValue!.mentions.any((e) => e == registerBook.mentions.first), true); //* Verificar que se haya agregado al menos una mencion
    debugPrint("Expect 4 of 5 for AddOne() passed!");
    expect(registerBookFromDB.getValue!.type, registerBook.type); //* Verificación de tipo
    debugPrint("Expect 5 of 5 for AddOne() passed!");
  });

  test('Eliminado de un cuaderno de registro', () async {
    final service = GetIt.I<RegisterBookServiceBase>();
    final manyToManyRepo = GetIt.I<StudentRegisterBookRepository>();

    final getResult = await service.getOne('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6'); //* Antes de eliminarlo
    final result = await service.deleteOne('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6');

    expect(getResult.getValue!.id, result.getValue!.id); //* Se espera que el valor devuelta coincida con el previo get()
    debugPrint("Expect 1 of 3 for DeleteOne() passed!");

    final getDeletedResult = await service.getOne('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6'); //* Se espera no encontrar el valor luego de ser eliminado
    expect(getDeletedResult.runtimeType, NawiError<RegisterBook>);
    debugPrint("Expect 2 of 3 for DeleteOne() passed!");

    final getStudents = await manyToManyRepo.getStudentsFromRegisterBook('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6');
    expect(getStudents.getValue!, isEmpty); //* No deberian haber coincidencias si se eliminó el cuaderno de registro
    debugPrint("Expect 3 of 3 for DeleteOne() passed!");
  });

  test('Actualizacion de un cuaderno de registro', () async {
    final service = GetIt.I<RegisterBookServiceBase>();

    final getResult = await service.getOne('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6'); //* Antes de editarlo
    final result = await service.updateOne(getResult.getValue!.copyWith(
      action: "Otra accion",
      mentions: [
        NawiTestUtils.listOfStudents[3].toStudentDAO,
        NawiTestUtils.listOfStudents[0].toStudentDAO,
        NawiTestUtils.listOfStudents[5].toStudentDAO
      ],
      type: RegisterBookType.anecdotal
    ));
    final getAfterUpdate = await service.getOne('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6'); //* Antes de editarlo

    expect(result.getValue!, true); //* Se debe de haber editado
    debugPrint("Expect 1 of 6 for UpdateOne() passed!");
    expect(getAfterUpdate.getValue!.action, "Otra accion"); //* La acción debe haberse cambiado
    debugPrint("Expect 2 of 6 for UpdateOne() passed!");
    expect(getAfterUpdate.getValue!.type, RegisterBookType.anecdotal); //* Igualmente el tipo
    debugPrint("Expect 3 of 6 for UpdateOne() passed!");
    expect(getAfterUpdate.getValue!.mentions, isNotEmpty); //* No debe estar vacio
    debugPrint("Expect 4 of 6 for UpdateOne() passed!");
    expect(getAfterUpdate.getValue!.mentions.length, 3); //* Estan los 3 elementos editados
    debugPrint("Expect 5 of 6 for UpdateOne() passed!");
    expect(getAfterUpdate.getValue!.mentions.contains(NawiTestUtils.listOfStudents[5].toStudentDAO), true); //* Comprobar que un elemento de la lista esté
    debugPrint("Expect 6 of 6 for UpdateOne() passed!");
  });

  test('Obtener un cuaderno de registro', () async {
    final service = GetIt.I<RegisterBookServiceBase>();

    final badResult = await service.getOne('0');
    final goodResult = await service.getOne('cd334961-cc2f-4c2a-8477-482155e7ed0e');
    
    expect(badResult.runtimeType, NawiError<RegisterBook>); //* Error esperado
    debugPrint("Expect 1 of 3 for getOne() passed!");
    expect(goodResult.getValue!.action, "Desde la vista de Bruno, ha visto como Pablo salía del salon"); //* Accion esperada
    debugPrint("Expect 2 of 3 for getOne() passed!");
    expect(goodResult.getValue!.mentions.contains(NawiTestUtils.listOfStudents[1].toStudentDAO), true); //* Mencion esperada
    debugPrint("Expect 3 of 3 for getOne() passed!");
  });

  test('Eliminado de un estudiante en cuaderno de registro', () async {
    final registerBookService = GetIt.I<RegisterBookServiceBase>();
    final studentService = GetIt.I<StudentServiceBase>();

    final deleteResult = await studentService.deleteOne('1d03982a-7a0a-40f2-adb4-1e90c2550485');
    final badGetResult = await registerBookService.getOne('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6');

    expect(deleteResult.getValue, isNotNull); //* Se elimino con exito
    debugPrint("Expect 1 of 2 for deleteOne() with relationship passed!");
    expect(badGetResult.runtimeType, NawiError<RegisterBook>); //* La eliminacion en cascada funciono
    debugPrint("Expect 2 of 2 for deleteOne() with relationship passed!");
  });

  test('Archivado y desarchivado de un cuaderno de registro', () async {
    final service = GetIt.I<RegisterBookServiceBase>();

    final registerBookArchived = await service.addOne(
      RegisterBook(
        action: "Alguna accion 1",
        type: RegisterBookType.incident,
        mentions: [NawiTestUtils.listOfStudents[4].toStudentDAO, NawiTestUtils.listOfStudents[0].toStudentDAO],
      )
    );

    var getResult = await service.getAll(RegisterBookFilter());
    int length = getResult.getValue!.length;

    final goodArchivedResult = await service.archiveOne(registerBookArchived.getValue!.id);
    final badArchivedResult = await service.archiveOne('c1b271b1-f21f-4c10-9dae-975f627d0c00');
    getResult = await service.getAll(RegisterBookFilter());

    expect(getResult.getValue!.length, length - 1); //* La cantidad debe reducirse del getAll()
    debugPrint("Expect 1 of 3 for archiveOne() passed!");
    expect(goodArchivedResult.getValue, isNotNull); //* No debe haber error al archivar
    debugPrint("Expect 2 of 3 for archiveOne() passed!");
    expect(badArchivedResult.runtimeType, NawiError<RegisterBook>); //* Debe haber error para archivar un registro ya archivado
    debugPrint("Expect 3 of 3 for archiveOne() passed!");

    final goodUnarchiveResult = await service.unarchiveOne(goodArchivedResult.getValue!.id);
    final badUnarchivedResult = await service.unarchiveOne('10277d6d-630c-4a6e-99ec-f807a64714f6');
    
    debugPrint("<---------------------------------------------->");
    getResult = await service.getAll(RegisterBookFilter());
    
    expect(getResult.getValue!.length, length); //* Se deberia devolver a la lista normal
    debugPrint("Expect 1 of 3 for unarchiveOne() passed!");
    expect(goodUnarchiveResult.getValue, isNotNull); //* No deberia poder desarchivar un cuaderno de registro no archivado
    debugPrint("Expect 2 of 3 for unarchiveOne() passed!");
    expect(badUnarchivedResult.runtimeType, NawiError<RegisterBook>); //* No deberia poder desarchivar un cuaderno de registro no archivado
    debugPrint("Expect 3 of 3 for unarchiveOne() passed!");

  });

}