import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/mappers/student_mapper.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/data/local/views/register_book_view.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/daos/student_register_book_dao.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';

import '../nawi_test_utils.dart' as testil;

void main() {
  setUp(() async => await testil.setupIntegrationTestLocator(withRegisterBook: true));
  tearDown(testil.onTearDownSetupIntegrationTestLocator);

  test('Registro de un registro del cuaderno de registro', () async {
    final service = GetIt.I<RegisterBookServiceBase>();

    final registerBook = RegisterBook(action: "Accion X", mentions: [testil.listOfStudents[0].toStudentSummary, testil.listOfStudents[1].toStudentSummary], createdAt: DateTime.now());
    final errorRegisterBook = RegisterBook(id: '06b654e1-2852-4618-84a7-bb2c43a3eba1', action: 'asdasdasdasd', createdAt: DateTime.now());

    final result = await Future.wait([
      service.addOne(registerBook), service.addOne(errorRegisterBook)
    ]);

    final goodResult = result[0];
    final badResult = result[1];
    final registerBookFromDB = await service.getOne(goodResult.getValue!.id);

    testil.customExpect(goodResult, isA<Success>(),
      about: "Agregado registro a la base de datos", output: goodResult.message, n: 1
    );

    testil.customExpect(badResult, isA<NawiError>(),
      about: "Registro con ID existente no debe ser registrado", output: badResult.message, n: 2
    );

    testil.customExpect(goodResult.getValue!.action, registerBook.action,
      about: "Valor de retorno", n: 3
    );

    testil.customExpect(registerBookFromDB.getValue!.mentions, containsAll(registerBook.mentions),
      about: "Menciones registradas correctamente", n: 4
    );

    testil.customExpect(registerBookFromDB.getValue!.type, registerBook.type,
      about: "Comprobación del tipo", n: 5
    );
  });

  test('Eliminado de un registro del cuaderno de registro', () async {
    final service = GetIt.I<RegisterBookServiceBase>();
    final manyToManyRepo = GetIt.I<StudentRegisterBookRepository>();

    final getResult = await service.getOne('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6'); //* Antes de eliminarlo
    final result = await service.deleteOne('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6');

    testil.customExpect(result, isA<Success>(),
      about: "Eliminado de registro", output: result.message, n: 1
    );

    testil.customExpect(getResult.getValue!.id, result.getValue!.id,
      about: "Valor de ID devuelto igual al valor obtenido de la BD", n: 2
    );

    final getDeletedResult = await service.getOne('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6');
    
    testil.customExpect(getDeletedResult, isA<NawiError>(),
      about: "Valor no encontrado al haber sido eliminado", output: getDeletedResult.message, n: 3
    );

    final getStudents = await manyToManyRepo.getStudentsFromRegisterBook('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6');

    testil.customExpect(getStudents.getValue!, isEmpty,
      about: "Valores de estudiantes no encontrados en la tabla muchos a muchos", output: getStudents.message, n: 4
    );
  });

  test('Actualizacion de un registro del cuaderno de registro', () async {
    final service = GetIt.I<RegisterBookServiceBase>();

    final getResult = await service.getOne('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6'); //* Antes de editarlo
    final result = await service.updateOne(getResult.getValue!.copyWith(
      action: "Otra accion",
      mentions: [
        testil.listOfStudents[3].toStudentSummary,
        testil.listOfStudents[0].toStudentSummary,
        testil.listOfStudents[5].toStudentSummary
      ],
      type: RegisterBookType.anecdotal
    ));
    final getAfterUpdate = await service.getOne('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6'); //* Antes de editarlo

    testil.customExpect(result, isA<Success>(),
      about: "Actualización correcta del registro", output: result.message, n: 1
    );

    testil.customExpect(getAfterUpdate.getValue!.action, "Otra accion",
      about: "Acción cambiado, vista desde la base de datos", n: 2
    );

    testil.customExpect(getAfterUpdate.getValue!.type, RegisterBookType.anecdotal,
      about: "Actualizado del tipo, vista desde la base de datos", n: 3
    );

    testil.customExpect(getAfterUpdate.getValue!.mentions, isNotEmpty,
      about: "La actualización no debe borrar las menciones", n: 4
    );

    testil.customExpect(getAfterUpdate.getValue!.mentions.length, 3,
      about: "La actualización no debe alterar las menciones", n: 5
    );

    testil.customExpect(getAfterUpdate.getValue!.mentions.contains(testil.listOfStudents[5].toStudentSummary), true,
      about: "La actualización no debe modificar internamente las menciones", n: 6
    );
  });

  test('Obtener un registro del cuaderno de registro', () async {
    final service = GetIt.I<RegisterBookServiceBase>();

    final results = await Future.wait([
      service.getOne('0'), service.getOne('cd334961-cc2f-4c2a-8477-482155e7ed0e')
    ]);

    final badResult = results[0];
    final goodResult = results[1];
    
    testil.customExpect(goodResult, isA<Success>(),
      about: "Obtención correcta", output: goodResult.message, n: 1
    );

    testil.customExpect(badResult, isA<NawiError>(),
      about: "Obtención incorrecta, ID no existente", output: badResult.message, n: 2
    );

    testil.customExpect(goodResult.getValue!.mentions.contains(testil.listOfStudents[1].toStudentSummary), true,
      about: "Obtención de registro con menciones obtenidas", n: 3
    );
  });

  test('Eliminado de un estudiante en registro del cuaderno de registro', () async {
    final registerBookService = GetIt.I<RegisterBookServiceBase>();
    final studentService = GetIt.I<StudentServiceBase>();

    final deleteResult = await studentService.deleteOne('1d03982a-7a0a-40f2-adb4-1e90c2550485');
    final badGetResult = await registerBookService.getOne('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6');

    testil.customExpect(deleteResult, isA<Success>(),
      about: "Eliminado exitoso", output: deleteResult.message, n: 1
    );

    testil.customExpect(badGetResult, isA<NawiError>(),
      about: "Los registros del cuaderno de registro donde tengan el estudiante eliminado funciona", output: badGetResult.message, n: 2
    );
  });

  test('Archivado y desarchivado de un registro del cuaderno de registro', () async {
    final service = GetIt.I<RegisterBookServiceBase>();

    final registerBookArchived = await service.addOne(
      RegisterBook(
        action: "Alguna accion 1",
        type: RegisterBookType.incident,
        createdAt: DateTime.now(),
        mentions: [testil.listOfStudents[4].toStudentSummary, testil.listOfStudents[0].toStudentSummary],
      )
    );

    var getResult = await service.getAll(RegisterBookFilter());
    int length = getResult.getValue!.length;

    final results = await Future.wait([
      service.archiveOne(registerBookArchived.getValue!.id),
      service.archiveOne('c1b271b1-f21f-4c10-9dae-975f627d0c00')
    ]);

    final goodArchivedResult = results[0];
    final badArchivedResult = results[1];

    getResult = await service.getAll(RegisterBookFilter());

    testil.customExpect(goodArchivedResult, isA<Success>(),
      about: "Archivado correcto", output: goodArchivedResult.message, n: 1
    );

    testil.customExpect(getResult.getValue!.length, length - 1,
      about: "Vista normal de registros reducida al archivar un registro", n: 2
    );

    testil.customExpect(badArchivedResult, isA<NawiError>(),
      about: "No se debe archivar un registro ya archivado", output: badArchivedResult.message, n: 3
    );

    final goodUnarchiveResult = await service.unarchiveOne(goodArchivedResult.getValue!.id);
    final badUnarchivedResult = await service.unarchiveOne('10277d6d-630c-4a6e-99ec-f807a64714f6');
    
    debugPrint("<---------------------------------------------->");
    getResult = await service.getAll(RegisterBookFilter());
    
    testil.customExpect(goodUnarchiveResult, isA<Success>(),
      about: "Desarchivado correcto", output: goodUnarchiveResult.message, n: 4
    );

    testil.customExpect(getResult.getValue!.length, length,
      about: "Vista normal de registros aumentada al desarchivar un registro", n: 5
    );

    testil.customExpect(badUnarchivedResult, isA<NawiError>(),
      about: "No se puede desarchivar un registro que no esté archivado previamente", output: badUnarchivedResult.message, n: 6
    );
  });

  group('Filtro de cuadernos de registro', () {
    test('Ordenamiento de estudiantes', () async {
      final service = GetIt.I<RegisterBookServiceBase>();

      var result = await service.getAll(
        RegisterBookFilter(orderBy: RegisterBookViewOrderByType.actionAsc, pageSize: 1, currentPage: 0)
      );

      testil.customExpect(result, isA<Success>(),
        about: "Obtención satisfactoria", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.first.action, testil.registerBookHighestAction.action,
        about: "Ordenamiento por acción ascendente hecho", n: 2
      );

      result = await service.getAll(
        RegisterBookFilter(orderBy: RegisterBookViewOrderByType.actionDesc, pageSize: 1, currentPage: 0)
      );

      testil.customExpect(result.getValue!.first.action, testil.registerBookLowestAction.action,
        about: "Ordenamiento por acción descendente hecho", n: 3
      );

      result = await service.getAll(
          RegisterBookFilter(orderBy: RegisterBookViewOrderByType.timestampRecently, pageSize: 1, currentPage: 0)
      );

      testil.customExpect(result.getValue!.first.action, testil.registerBookRecently.action,
        about: "Ordenamiento por registrado reciente", n: 4
      );

      result = await service.getAll(
        RegisterBookFilter(orderBy: RegisterBookViewOrderByType.timestampOldy, pageSize: 1, currentPage: 0)
      );

      testil.customExpect(result.getValue!.first.action, testil.registerBookOldy.action,
        about: "Ordenamiento por registro antiguo", n: 5
      );
    });

    test('Paginado de estudiantes', () async {
      final service = GetIt.I<RegisterBookServiceBase>();

      var result = await service.getAllPaginated(pageSize: 2, currentPage: 1, params: RegisterBookFilter());

      testil.customExpect(result, isA<Success>(),
        about: "Paginado correcto", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.data.length, 2,
        about: "Paginado con longitud 2", n: 2
      );

      result = await service.getAllPaginated(pageSize: 5, currentPage: 2, params: RegisterBookFilter());

      testil.customExpect(result.getValue!.data.length, 1,
        about: "Paginado de pagina 5, longitud 2", n: 3
      );

      result = await service.getAllPaginated(pageSize: 3, currentPage: 5, params: RegisterBookFilter());

      testil.customExpect(result.getValue!.data.length, 0,
        about: "Paginado con pagina fuera de rango", n: 4
      );
    });

    test('Busqueda por nombre de accion', () async {
      final service = GetIt.I<RegisterBookServiceBase>();

      var result = await service.getAll(RegisterBookFilter(actionLike: 'pe'));

      testil.customExpect(result, isA<Success>(),
        about: "Busqueda por nombre correcto", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.any((e) => e.action == "Jose le pego a Pablo"), true,
        about: "Búsqueda por una cadena de caracteres coincidente", n: 2
      );

      result = await service.getAll(RegisterBookFilter(actionLike: "asdasdasdasdsa"));

      testil.customExpect(result.getValue!.isEmpty, true,
        about: "Búsqueda por una cadena de caracteres sin coincidencias", n: 3
      );

      result = await service.getAll(RegisterBookFilter(actionLike: "      "));

      testil.customExpect(result.getValue!.isEmpty, true,
        about: "Búsqueda por espacios en blanco", n: 4
      );
    });

    test('Busqueda por estudiantes', () async {
      final service = GetIt.I<RegisterBookServiceBase>();

      var result = await service.getAll(RegisterBookFilter(searchByStudentsId: ['1d03982a-7a0a-40f2-adb4-1e90c2550485']));

      testil.customExpect(result, isA<Success>(),
        about: "Busqueda por estudiante correcto", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.length, 2,
        about: "Busqueda por un estudiante", n: 2
      );

      result = await service.getAll(RegisterBookFilter(searchByStudentsId: [
        '1d03982a-7a0a-40f2-adb4-1e90c2550485',
        '8722e6e9-6178-4296-948a-7fb3db196d44',
        '194c4084-0fdf-49f2-86d7-766b7607ce0b'
      ]));

      testil.customExpect(result.getValue!.length, 3,
        about: "Búsqueda por 3 estudiantes, se debe aplicar una operacion OR", n: 3
      );

      result = await service.getAll(RegisterBookFilter(searchByStudentsId: []));

      testil.customExpect(result.getValue!.length, 6,
        about: "Búsqueda sin estudiantes, debe aplicarse el filtro normal", n: 4
      );

      result = await service.getAll(RegisterBookFilter(searchByStudentsId: ['580e4114-98c8-4b80-92ea-b44c140f26e3']));
      testil.customExpect(result.getValue!, isEmpty,
        about: "Busqueda por un estudiante que no esta registrado en ningun cuaderno de registro", n: 5
      );
    });

    test('Busqueda por tipo de cuaderno de registro', () async {
      final service = GetIt.I<RegisterBookServiceBase>();

      var result = await service.getAll(RegisterBookFilter(searchByType: RegisterBookType.anecdotal));

      testil.customExpect(result, isA<Success>(),
        about: "Búsqueda por tipo correcta", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.length, 2,
        about: "Búsqueda por tipo anecdótico", n: 2
      );

      result = await service.getAll(RegisterBookFilter()); 

      testil.customExpect(result.getValue!.length, 6,
        about: "Búsqueda sin aplicar filtro de tipo", n: 3
      );
    });    

    test('Busqueda por rango de fechas', () async {
      final service = GetIt.I<RegisterBookServiceBase>();

      var result = await service.getAll(RegisterBookFilter(timestampRange: 
        DateTimeRange(start: DateTime(2025, 1, 6), end: DateTime(2025, 2, 15))
      ));

      testil.customExpect(result, isA<Success>(),
        about: "Busqueda por rango correcta", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.length, 3,
        about: "Busqueda con rango de fechas con resultados a esperar", n: 2
      );

      result = await service.getAll(RegisterBookFilter(timestampRange: 
        DateTimeRange(start: DateTime(2025, 1, 1), end: DateTime(2025, 1, 1))
      ));

      testil.customExpect(result.getValue!.length, 1,
        about: "Busqueda con rango de fechas donde se especifica un día en especifico", n: 3
      );

      result = await service.getAll(RegisterBookFilter(timestampRange: 
        DateTimeRange(start: DateTime(2025, 3, 9), end: DateTime(2025, 4, 8))
      ));

      testil.customExpect(result.getValue!, isEmpty,
        about: "Busqueda fuera de rango de las fechas de los registros", n: 4
      );
    });

    test('Filtro por cuaderno de registros archivados', () async {
      final service = GetIt.I<RegisterBookServiceBase>();

      var result = await service.getAll(RegisterBookFilter(showHidden: true));

      testil.customExpect(result, isA<Success>(),
        about: "Busqueda de estudiantes archivados correcta", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.length, 2,
        about: "Busqueda con datos coherentes de estudiantes archivados", n: 2
      );
    });
  });
}