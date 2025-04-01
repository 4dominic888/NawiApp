import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/models_views/register_book_view.dart';
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
    final errorRegisterBook = RegisterBook(id: '06b654e1-2852-4618-84a7-bb2c43a3eba1', action: 'asdasdasdasd');

    final result = await Future.wait([
      service.addOne(registerBook), service.addOne(errorRegisterBook)
    ]);

    final goodResult = result[0];
    final badResult = result[1];
    final registerBookFromDB = await service.getOne(goodResult.getValue!.id);

    expect(registerBookFromDB.getValue, isNotNull); //* El get deberia funcionar
    debugPrint("Expect 1 of 6 for AddOne() passed!");
    expect(goodResult.getValue!.action, registerBook.action); //* El atributo de accion del cuaderno de registro no debe diferir
    debugPrint("Expect 2 of 6 for AddOne() passed!");
    expect(goodResult.getValue!.action, isNot(diffRegisterBook.action)); //* Se vuelve a comprobar con otro registro que nunca fue agregado
    debugPrint("Expect 3 of 6 for AddOne() passed!");
    expect(registerBookFromDB.getValue!.mentions.any((e) => e == registerBook.mentions.first), true); //* Verificar que se haya agregado al menos una mencion
    debugPrint("Expect 4 of 6 for AddOne() passed!");
    expect(registerBookFromDB.getValue!.type, registerBook.type); //* Verificación de tipo
    debugPrint("Expect 5 of 6 for AddOne() passed!");
    expect(badResult, isA<NawiError>()); //* Verificar que el agregado sea incorrecto al haber una ID previamente registrada en la BD
    debugPrint("Expect 6 of 6 for AddOne() passed!");
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

  group('Filtro de cuadernos de registro', () {
    test('Ordenamiento de estudiantes', () async {
      final service = GetIt.I<RegisterBookServiceBase>();

      expect((
        await service.getAll(
          RegisterBookFilter(orderBy: RegisterBookViewOrderByType.actionAsc, pageSize: 1, currentPage: 0)
        )
      ).getValue!.first.action, NawiTestUtils.registerBookHighestAction.action);
      debugPrint("Expect 1 of 4 for getAll() about OrberBy passed!");

      expect((
        await service.getAll(
          RegisterBookFilter(orderBy: RegisterBookViewOrderByType.actionDesc, pageSize: 1, currentPage: 0)
        )
      ).getValue!.first.action, NawiTestUtils.registerBookLowestAction.action);
      debugPrint("Expect 2 of 4 for getAll() about OrberBy passed!");

      expect((
        await service.getAll(
          RegisterBookFilter(orderBy: RegisterBookViewOrderByType.timestampRecently, pageSize: 1, currentPage: 0)
        )
      ).getValue!.first.action, NawiTestUtils.registerBookRecently.action);
      debugPrint("Expect 3 of 4 for getAll() about OrberBy passed!");

      expect((
        await service.getAll(
          RegisterBookFilter(orderBy: RegisterBookViewOrderByType.timestampOldy, pageSize: 1, currentPage: 0)
        )
      ).getValue!.first.action, NawiTestUtils.registerBookOldy.action);
      debugPrint("Expect 4 of 4 for getAll() about OrberBy passed!");
    });

    test('Paginado de estudiantes', () async {
      final service = GetIt.I<RegisterBookServiceBase>();

      expect((
        await service.getAllPaginated(pageSize: 2, currentPage: 1, params: RegisterBookFilter())
      ).getValue!.data.length, 2);
      debugPrint("Expect 1 of 3 for getAll() about Pagination passed!");

      expect((
        await service.getAllPaginated(pageSize: 5, currentPage: 2, params: RegisterBookFilter())
      ).getValue!.data.length, 1);
      debugPrint("Expect 2 of 3 for getAll() about Pagination passed!");

      expect((
        await service.getAllPaginated(pageSize: 3, currentPage: 5, params: RegisterBookFilter())
      ).getValue!.data.length, 0);
      debugPrint("Expect 3 of 3 for getAll() about Pagination passed!");
    });

    test('Busqueda por nombre de accion', () async {
      final service = GetIt.I<RegisterBookServiceBase>();

      expect((
        await service.getAll(RegisterBookFilter(actionLike: 'pe'))
      ).getValue!.any((e) => e.action == "Jose le pego a Pablo"), true);
      debugPrint("Expect 1 of 3 for getAll() about SearchBy action passed!");

      expect((
        await service.getAll(RegisterBookFilter(actionLike: "asdasdasdasdsa"))
      ).getValue!.isEmpty, true);
      debugPrint("Expect 2 of 3 for getAll() about SearchBy action passed!");

      expect((
        await service.getAll(RegisterBookFilter(actionLike: "      "))
      ).getValue!.isEmpty, true);
      debugPrint("Expect 3 of 3 for getAll() about SearchBy action passed!");
    });

    test('Busqueda por estudiantes', () async {
      final service = GetIt.I<RegisterBookServiceBase>();

      expect(( //* Solo 2 cuadernos de registro poseen este estudiante
        await service.getAll(RegisterBookFilter(searchByStudentsId: ['1d03982a-7a0a-40f2-adb4-1e90c2550485']))
      ).getValue!.length, 2);
      debugPrint("Expect 1 of 3 for getAll() about SearchBy students passed!");

      //* Deberian haber 3 cuadernos de registro que tengan una o mas de las ID colocadas en el filtro
      expect((
        await service.getAll(RegisterBookFilter(searchByStudentsId: ['1d03982a-7a0a-40f2-adb4-1e90c2550485', '8722e6e9-6178-4296-948a-7fb3db196d44', '194c4084-0fdf-49f2-86d7-766b7607ce0b']))
      ).getValue!.length, 3);
      debugPrint("Expect 2 of 3 for getAll() about SearchBy students passed!");

      expect(( //* Pasar un array vacio deberia anular dicha busqueda
        await service.getAll(RegisterBookFilter(searchByStudentsId: []))
      ).getValue!.length, 6);
      debugPrint("Expect 3 of 3 for getAll() about SearchBy students passed!");
    });

    test('Busqueda por tipo de cuaderno de registro', () async {
      final service = GetIt.I<RegisterBookServiceBase>();

      expect(( //* Solo hay 2 cuadernos de registro de tipo anecdotico
        await service.getAll(RegisterBookFilter(searchByType: RegisterBookType.anecdotal))
      ).getValue!.length, 2);
      debugPrint("Expect 1 of 2 for getAll() about SearchBy register book type passed!");

      expect(( //* Sin dicho filtro, deberia seguir funcionando
        await service.getAll(RegisterBookFilter())
      ).getValue!.length, 6);
      debugPrint("Expect 2 of 2 for getAll() about SearchBy register book type passed!");
    });    

    test('Filtro por cuaderno de registros archivados', () async {
      final service = GetIt.I<RegisterBookServiceBase>();

      expect(( //* Solo hay 2 archivados
        await service.getAll(RegisterBookFilter(showHidden: true))
      ).getValue!.length, 2);
      debugPrint("Expect 1 of 1 for getAll() about archived register book passed!");
    });

  });
}