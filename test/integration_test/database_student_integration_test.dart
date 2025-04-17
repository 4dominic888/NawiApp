import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/data/local/views/student_view.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';

import '../nawi_test_utils.dart' as testil;

void main(){
  setUp(testil.setupTestLocator);
  tearDown(testil.onTearDownSetupLocator);

  test('Registro de un estudiante', () async {
    final service = GetIt.I<StudentServiceBase>();

    final student = Student(name: "Pepe Gonzales", age: StudentAge.fourYears);
    final errorStudent = Student(id: '980bbf70-48de-4946-8d8f-de06a39d7611', name: 'adasdasdasd', age: StudentAge.fiveYears); //* ID existente

    final result = await Future.wait([
      service.addOne(student),
      service.addOne(errorStudent)
    ]);
    final studentFromDatabaseSummary = (await service.getAll(StudentFilter(nameLike: "pepe"))).getValue!.first;

    final goodResult = result[0];
    final badResult = result[1];

    testil.customExpect(goodResult, isA<Success>(),
      about: 'Agregar estudiando a la base de datos', output: goodResult.message, n: 1
    );

    testil.customExpect(goodResult.getValue!.name, student.name,
      about: 'Valor de retorno', n: 2
    );

    testil.customExpect(studentFromDatabaseSummary, goodResult.getValue!,
      about: 'Verificar que esté en la base de datos', n: 3
    );

    testil.customExpect(badResult, isA<NawiError>(),
      about: 'Estudiante con ID existente no debe de registrarse', output: badResult.message, n: 4
    );
  });

  test('Eliminacion de un estudiante', () async {
    final service = GetIt.I<StudentServiceBase>();

    final addedResult = await service.addOne(Student(name: "Pepe Gonzales", age: StudentAge.fourYears));
    final result = await service.deleteOne(addedResult.getValue!.id);

    testil.customExpect(result, isA<Success>(),
      about: "Eliminación de un estudiante", output: result.message, n: 1
    );

    testil.customExpect(result.getValue!.id, addedResult.getValue!.id,
      about: "Valor retornado", output: result.message, n: 2
    );
    
    final getDeletedResult = await service.getOne(result.getValue!.id);
    testil.customExpect(getDeletedResult, isA<NawiError>(),
      about: "Resultado al obtener un estudiante eliminado", output: getDeletedResult.message, n: 3
    );
  });

  test("Actualizacion de un estudiante", () async {
    final service = GetIt.I<StudentServiceBase>();

    final addedResult = await service.addOne(Student(name: "Pepe Gonzales", age: StudentAge.fourYears));
    final result = await service.updateOne(addedResult.getValue!.copyWith(name: "Amaterasu Remake", age: StudentAge.fiveYears));
    final getResult = await service.getOne(addedResult.getValue!.id);

    testil.customExpect(result, isA<Success>(),
      about: "Actualizado de un estudiante", output: result.message, n: 1
    );

    testil.customExpect(getResult.getValue!.name, "Amaterasu Remake",
      about: "Verificar que el dato haya sido editado con nombre", n: 2
    );

    testil.customExpect(getResult.getValue!.id, addedResult.getValue!.id,
      about: "Verificar que sus identificadores sean iguales", n: 3
    );
  });

  test('Obtener un estudiante', () async {
    final service = GetIt.I<StudentServiceBase>();

    final results = await Future.wait([
      service.getOne('0'),
      service.getOne('980bbf70-48de-4946-8d8f-de06a39d7611')
    ]);

    final badResult = results[0];
    final goodResult = results[1];

    testil.customExpect(goodResult, isA<Success>(),
      about: "Obtención de un estudiante existente", output: goodResult.message, n: 1
    );

    testil.customExpect(goodResult.getValue!.name, "Leonardo Da Vinci",
      about: "Corroborar el nombre del estudiando obtenido", output: goodResult.message, n: 2
    );

    testil.customExpect(badResult, isA<NawiError>(),
      about: "Obtención de un estudiante no existente", output: badResult.message, n: 3
    );
  });

  test('Archivado y Desarchivado de un estudiante', () async {
    final service = GetIt.I<StudentServiceBase>();
    
    final studentArchived = Student(name: "Juan gonzales paredes", age: StudentAge.fourYears);
    final student = Student(name: "Juan Archive", age: StudentAge.fourYears);
    
    final addedResults = await Future.wait([
      service.addOne(studentArchived),
      service.addOne(student)
    ]);

    final archivedAddedResult = addedResults[0];

    var result = await service.getAll(StudentFilter());
    int length = result.getValue!.length;
    
    final archivedResults = await Future.wait([
      service.archiveOne(archivedAddedResult.getValue!.id),
      service.archiveOne('750c3a46-3e44-4800-bee1-ebccb4f4f55c')
    ]);

    final goodArchivedResult = archivedResults[0];
    final badArchivedResult = archivedResults[1];

    result = await service.getAll(StudentFilter());

    testil.customExpect(goodArchivedResult, isA<Success>(),
      about: "Archivado correcto", output: goodArchivedResult.message, n: 1
    );

    testil.customExpect(badArchivedResult, isA<NawiError>(),
      about: "Archivando un estudiante ya archivado", output: badArchivedResult.message, n: 2
    );

    testil.customExpect(result.getValue!.length, length - 1,
      about: "Lista reducida en la BD", n: 3
    );

    final unarchivedResults = await Future.wait([
      service.unarchiveOne(archivedAddedResult.getValue!.id),
      service.unarchiveOne('980bbf70-48de-4946-8d8f-de06a39d7611')
    ]);

    final goodUnarchiveResult = unarchivedResults[0];
    final badUnarchiveResult = unarchivedResults[1];
    
    debugPrint("<---------------------------------------------->");

    result = await service.getAll(StudentFilter());

    testil.customExpect(goodUnarchiveResult, isA<Success>(),
      about: "Desarchivado correcto", output: goodUnarchiveResult.message, n: 4
    );

    testil.customExpect(badUnarchiveResult, isA<NawiError>(),
      about: "Desarchivado incorrecto", output: badUnarchiveResult.message, n: 5
    );

    testil.customExpect(result.getValue!.length, length,
      about: "Lista aumentada en la BD", n: 6
    );
  });

  group('Filtro de estudiantes', () {
    test('Ordenamiento de estudiantes', () async {
      final service = GetIt.I<StudentServiceBase>();

      //* Por nombre
      var result = await service.getAll(
        StudentFilter(orderBy: StudentViewOrderByType.nameAsc, pageSize: 1, currentPage: 0)
      );

      testil.customExpect(result, isA<Success>(),
        about: "Comprobación del resultado por ordenamiento", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.first.name, testil.studentHighestName.name,
        about: "Ordenamiento por nombre ascendentemente", n: 2
      );

      result = await service.getAll(
        StudentFilter(orderBy: StudentViewOrderByType.nameDesc, pageSize: 1, currentPage: 0)
      );

      testil.customExpect(result.getValue!.first.name, testil.studentLowestName.name,
        about: "Ordenamiento por nombre descendentemente", n: 3
      );

      result = await service.getAll(
        StudentFilter(orderBy: StudentViewOrderByType.timestampRecently, pageSize: 1, currentPage: 0)
      );

      testil.customExpect(result.getValue!.first.name, testil.studentRecently.name,
        about: "Ordenamiento por tiempo de creación reciente", n: 4
      );

      result = await service.getAll(
        StudentFilter(orderBy: StudentViewOrderByType.timestampOldy, pageSize: 1, currentPage: 0)
      );

      testil.customExpect(result.getValue!.first.name, testil.studentOldy.name,
        about: "Ordenamiento por tiempo de creación antigua", n: 5
      );
    });

    test('Paginado de estudiantes', () async {
      final service = GetIt.I<StudentServiceBase>();

      var result = await service.getAllPaginated(pageSize: 3, currentPage: 1, params: StudentFilter());

      testil.customExpect(result, isA<Success>(),
        about: "Comprobación de resultado por paginado", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.data.length, 3,
        about: "Paginado de X longitud", n: 2
      );

      result = await service.getAllPaginated(pageSize: 4, currentPage: 2, params: StudentFilter()); 

      testil.customExpect(result.getValue!.data.length, 2,
        about: "Paginado de X longitud y X pagina", n: 3
      );

      result = await service.getAllPaginated(pageSize: 1, currentPage: 10, params: StudentFilter());

      testil.customExpect(result.getValue!.data.length, 0,
        about: "Paginado fuera de rango", n: 4
      );
    });

    test('Busqueda por nombre de estudiante', () async {
      final service = GetIt.I<StudentServiceBase>();

      var result = await service.getAll(StudentFilter(nameLike: 'l'));

      testil.customExpect(result, isA<Success>(),
        about: "Comprobación de resultado por nombre de estudiante", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.any((e) => e.name == 'Jose Olaya'), true,
        about: "Busqueda por nombre por un caracter aleatorio", n: 2
      );

      result = await service.getAll(StudentFilter(nameLike: "ñ"));

      testil.customExpect(result.getValue!.isEmpty, true,
        about: "Busqueda por nombre y que no exista", n: 3
      );

      result = await service.getAll(StudentFilter(nameLike: "  "));

      testil.customExpect(result.getValue!.length, 6,
        about: "Busqueda por nombre y que sean espacios en blanco", n: 4
      );
    });

    test('Busqueda por edad del estudiante', () async {
      final service = GetIt.I<StudentServiceBase>();

      var result = await service.getAll(StudentFilter(ageEnumIndex1: StudentAge.fiveYears));

      testil.customExpect(result, isA<Success>(),
        about: "Comprobación del resultado por edad del estudiante", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.any((e) => e.age == StudentAge.fiveYears), true,
        about: "Búsqueda por edad de 5 años", n: 2
      );

      result = await service.getAll(StudentFilter(ageEnumIndex1: StudentAge.fourYears, ageEnumIndex2: StudentAge.threeYears));

      testil.customExpect(result.getValue!.length, 5,
        about: "Búsqueda por 4 y 3 años", n: 3
      );
      
      result = await service.getAll(StudentFilter(ageEnumIndex2: StudentAge.fourYears));

      testil.customExpect(result.getValue!.length, 2,
        about: "Búsqueda por 4 años en el ageEnumIndex2", n: 4
      );
    });

    test('Filtro de estudiantes archivados', () async {
      final service = GetIt.I<StudentServiceBase>();

      var result = await service.getAll(StudentFilter(showHidden: true));

      testil.customExpect(result, isA<Success>(),
        about: "Comprobación de búsqueda de estudiantes ocultos", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.length, 2,
        about: "Búsqueda de estudiantes archivados", n: 2
      );
      debugPrint("Expect 1 of 1 for getAll() about archived students passed!");
    });

  });
}