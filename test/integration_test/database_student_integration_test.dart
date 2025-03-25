import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/classes/student_filter.dart';
import 'package:nawiapp/domain/models/models_views/student_view.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';

import '../nawi_test_utils.dart';

void main(){
  setUp(NawiTestUtils.setupTestLocator);
  tearDown(NawiTestUtils.onTearDownSetupLocator);

  test('Registro de un estudiante', () async {
    final service = GetIt.I<StudentServiceBase>();

    final student = Student(name: "Pepe Gonzales", age: StudentAge.fourYears);
    final diffStudent = Student(name: "Pepe Gonzales2", age: StudentAge.fourYears);

    final result = await service.addOne(student);
    final studentFromDatabaseDAO = (await service.getAll(StudentFilter(nameLike: "pepe"))).getValue!.first;

    //? Se compara por nombres, ya que [student] no tiene una ID asignada, pero para verificar que devuelva un estudiante coherente
    expect(result.getValue!.name, student.name); //* El retorno de la función de AddOne() es correcto
    debugPrint("Expect 1 of 3 for AddOne() passed!");
    expect(result.getValue!.name, isNot(diffStudent.name)); //* Corrobora con un estudiante erróneo
    debugPrint("Expect 2 of 3 for AddOne() passed!");
    expect(studentFromDatabaseDAO, result.getValue); //* Se verifica que exista en la base de datos
    debugPrint("Expect 3 of 3 for AddOne() passed!");
  });

  test('Eliminacion de un estudiante', () async {
    final service = GetIt.I<StudentServiceBase>();

    final addedResult = await service.addOne(Student(name: "Pepe Gonzales", age: StudentAge.fourYears));
    final result = await service.deleteOne(addedResult.getValue!.id);

    expect(result.getValue!.id, addedResult.getValue!.id); //* Se espera que el valor devuelto sea del estudiante eliminado
    debugPrint("Expect 1 of 2 for DeleteOne() passed!");
    
    final getDeletedResult = await service.getOne(result.getValue!.id);
    expect(getDeletedResult.runtimeType, NawiError<Student>); //* Se espera que no esté en la BD
    debugPrint("Expect 2 of 2 for DeleteOne() passed!");
  });

  test("Actualizacion de un estudiante", () async {
    final service = GetIt.I<StudentServiceBase>();

    final addedResult = await service.addOne(Student(name: "Pepe Gonzales", age: StudentAge.fourYears));
    final result = await service.updateOne(addedResult.getValue!.copyWith(name: "Amaterasu Remake", age: StudentAge.fiveYears));

    final getResult = await service.getOne(addedResult.getValue!.id);

    expect(result.getValue!, true); //* Segun el result, debería de haberse ejecutado correctamente
    debugPrint("Expect 1 of 3 for UpdateOne() passed!");
    expect(getResult.getValue!.name, "Amaterasu Remake"); //* En la consulta a la BD, se debe reflejar los cambios
    debugPrint("Expect 2 of 3 for UpdateOne() passed!");
    expect(getResult.getValue!.id, addedResult.getValue!.id); //* Las IDs deben coincidir
    debugPrint("Expect 2 of 3 for UpdateOne() passed!");
  });

  test('Obtener un estudiante', () async {
    final service = GetIt.I<StudentServiceBase>();

    final badResult = await service.getOne('0');
    final goodResult = await service.getOne('980bbf70-48de-4946-8d8f-de06a39d7611');

    expect(badResult.runtimeType, NawiError<Student>); //* Se espera que no se encuentre el valor ante un ID no existente
    debugPrint("Expect 1 of 2 for getOne() passed!");
    expect(goodResult.getValue!.name, "Leonardo Da Vinci"); //* Se espera que el estudiante obtenido exista en la base de datos
    debugPrint("Expect 2 of 2 for getOne() passed!");
  });

  test('Archivado y Desarchivado de un estudiante', () async {
    final service = GetIt.I<StudentServiceBase>();
    
    final studentArchived = Student(name: "Juan gonzales paredes", age: StudentAge.fourYears);
    final student = Student(name: "Juan Archive", age: StudentAge.fourYears);
    
    final archivedAddedResult = await service.addOne(studentArchived);
    await service.addOne(student);

    var result = await service.getAll(StudentFilter());
    int length = result.getValue!.length;
    
    final goodArchivedResult = await service.archiveOne(archivedAddedResult.getValue!.id);
    final badArchivedResult = await service.archiveOne('750c3a46-3e44-4800-bee1-ebccb4f4f55c');

    result = await service.getAll(StudentFilter());
    expect(result.getValue!.length, length - 1); //* Deberia quitarse el estudiante archivado de la lista
    debugPrint("Expect 1 of 3 for archiveOne() passed!");
    expect(goodArchivedResult.getValue, isNotNull);
    debugPrint("Expect 2 of 3 for archiveOne() passed!");
    expect(badArchivedResult.runtimeType, NawiError<Student>);
    debugPrint("Expect 3 of 3 for archiveOne() passed!");

    final goodUnarchiveResult = await service.unarchiveOne(archivedAddedResult.getValue!.id);
    final badUnarchiveResult = await service.unarchiveOne('980bbf70-48de-4946-8d8f-de06a39d7611');
    
    debugPrint("<---------------------------------------------->");
    result = await service.getAll(StudentFilter());
    expect(result.getValue!.length, length); //* Deberia volver a ingresarse el estudiante archivado
    debugPrint("Expect 1 of 3 for unarchiveOne() passed!");
    expect(goodUnarchiveResult.getValue, isNotNull);
    debugPrint("Expect 2 of 3 for unarchiveOne() passed!");
    expect(badUnarchiveResult.runtimeType, NawiError<Student>);
    debugPrint("Expect 3 of 3 for unarchiveOne() passed!");
  });

  group('Filtro de estudiantes', () {
    test('Ordenamiento de estudiantes', () async {
      final service = GetIt.I<StudentServiceBase>();

      expect(( //* Prueba por order por nombre ascendentemente
        await service.getAll(
          StudentFilter(orderBy: StudentViewOrderByType.nameAsc, pageSize: 1, currentPage: 0)
        )
      ).getValue!.first.name, NawiTestUtils.studentHighestName.name);
      debugPrint("Expect 1 of 4 for getAll() about OrberBy passed!");

      expect(( //* Prueba por nombre descendentemente
        await service.getAll(
          StudentFilter(orderBy: StudentViewOrderByType.nameDesc, pageSize: 1, currentPage: 0)
        )
      ).getValue!.first.name, NawiTestUtils.studentLowestName.name);
      debugPrint("Expect 2 of 4 for getAll() about OrberBy passed!");

      expect(( //* Prueba por estudiante registrado recientemente
        await service.getAll(
          StudentFilter(orderBy: StudentViewOrderByType.timestampRecently, pageSize: 1, currentPage: 0)
        )
      ).getValue!.first.name, NawiTestUtils.studentRecently.name);
      debugPrint("Expect 3 of 4 for getAll() about OrberBy passed!");

      expect(( //* Prueba por estudiante registrado viejo
        await service.getAll(
          StudentFilter(orderBy: StudentViewOrderByType.timestampOldy, pageSize: 1, currentPage: 0)
        )
      ).getValue!.first.name, NawiTestUtils.studentOldy.name);
      debugPrint("Expect 4 of 4 for getAll() about OrberBy passed!");
    });

    test('Paginado de estudiantes', () async {
      final service = GetIt.I<StudentServiceBase>();

      expect(( //* Prueba que solo se regrese 3 elementos
        await service.getAllPaginated(pageSize: 3, currentPage: 1, params: StudentFilter())
      ).getValue!.data.length, 3);
      debugPrint("Expect 1 of 2 for getAll() about Pagination passed!");

      expect(( //* Prueba que solo se regrese 2 elementos
        await service.getAllPaginated(pageSize: 4, currentPage: 2, params: StudentFilter())
      ).getValue!.data.length, 2);
      debugPrint("Expect 1 of 2 for getAll() about Pagination passed!");
    });

    test('Busqueda por nombre de estudiante', () async {
      final service = GetIt.I<StudentServiceBase>();

      expect((
        await service.getAll(StudentFilter(nameLike: "l"))
      ).getValue!.any((e) => e.name == 'Jose Olaya'), true);
      debugPrint("Expect 1 of 3 for getAll() about SearchBy name passed!");

      expect((
        await service.getAll(StudentFilter(nameLike: "ñ"))
      ).getValue!.isEmpty, true);
      debugPrint("Expect 2 of 3 for getAll() about SearchBy name passed!");

      expect(( //* Como si no se aplicara el filtro
        await service.getAll(StudentFilter(nameLike: "  "))
      ).getValue!.length, 6);
      debugPrint("Expect 3 of 3 for getAll() about SearchBy name passed!");
    });

    test('Busqueda por edad del estudiante', () async {
      final service = GetIt.I<StudentServiceBase>();

      expect((
        await service.getAll(StudentFilter(ageEnumIndex1: StudentAge.fiveYears))
      ).getValue!.any((element) => element.age == StudentAge.fiveYears), true);
      debugPrint("Expect 1 of 3 for getAll() about SearchBy age passed!");

      expect((
        await service.getAll(StudentFilter(ageEnumIndex1: StudentAge.fourYears, ageEnumIndex2: StudentAge.threeYears))
      ).getValue!.length, 5);
      debugPrint("Expect 2 of 3 for getAll() about SearchBy age passed!");
      
      expect((
        await service.getAll(StudentFilter(ageEnumIndex2: StudentAge.fourYears))
      ).getValue!.length, 2);
      debugPrint("Expect 3 of 3 for getAll() about SearchBy age passed!");
    });

    test('Filtro de estudiantes archivados', () async {
      final service = GetIt.I<StudentServiceBase>();

      expect(( //* Solo hay 2 estudiantes archivados en la lista estática
        await service.getAll(StudentFilter(showHidden: true))
      ).getValue!.length, 2);
      debugPrint("Expect 1 of 1 for getAll() about archived students passed!");
    });

  });
}