import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/filter/classroom_filter.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom_status.dart';
import 'package:nawiapp/domain/services/classroom_service_base.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';

import '../nawi_test_utils.dart' as testil;

void main() {
  setUp(() async => await testil.setupIntegrationTestLocator(withRegisterBook: true));
  tearDown(testil.onTearDownSetupIntegrationTestLocator);

  test('Registro de un aula', () async {
    final service = GetIt.I<ClassroomServiceBase>();

    final classroom = Classroom(name: 'Clase C', iconCode: 12745);
    final errorClassroom = Classroom(id: '6615024f-0153-4492-b06e-0cb108f90ac6', name: 'Clase D', iconCode: 12345);

    final result = await Future.wait([
      service.addOne(classroom),
      service.addOne(errorClassroom),
    ]);

    final classroomFromDatabase = (await service.getAll(ClassroomFilter(nameLike: 'Clase C'))).getValue!.first;

    final goodResult = result[0];
    final badResult = result[1];

    testil.customExpect(goodResult, isA<Success>(),
      about: 'Creación de aula', n: 1, output: goodResult.message
    );

    testil.customExpect(goodResult.getValue!.name, classroom.name,
      about: 'Valor de retorno', n: 2
    );

    testil.customExpect(classroomFromDatabase, goodResult.getValue!,
      about: 'Verificar que exista en la base de datos', n: 3
    );

    testil.customExpect(badResult, isA<NawiError>(),
      about: 'Aula con ID existente', n: 4, output: badResult.message
    );

  });

  test('Eliminación de un aula', () async {
    final classroomService = GetIt.I<ClassroomServiceBase>();
    final studentService = GetIt.I<StudentServiceBase>();
    final registerBookService = GetIt.I<RegisterBookServiceBase>();

    final deleteResult = await classroomService.deleteOne('b393e6bb-9b59-4c74-95ca-e7969bf5262a');

    testil.customExpect(deleteResult, isA<Success>(),
      about: 'Eliminación exitosa', n: 1, output: deleteResult.message
    );

    final queryStudentDoesntBelongedResult = await studentService.getOne('d91d2fdb-ed8f-4577-aeb3-47a0d43d0501');
    final queryRegisterBookDoesntBelongedResult = await registerBookService.getOne('a3c633a9-b3bf-4096-8c9e-aa0a8e06a327');

    testil.customExpect(queryStudentDoesntBelongedResult, isA<NawiError>(),
      about: 'Estudiante eliminado mediante eliminación de aula', n: 2, output: queryStudentDoesntBelongedResult.message
    );

    testil.customExpect(queryRegisterBookDoesntBelongedResult, isA<NawiError>(),
      about: 'Registro del cuaderno de registro eliminado mediante eliminación de aula', n: 3, output: queryRegisterBookDoesntBelongedResult.message
    );

  });

  test('Actualización de un aula', () async {
    final service = GetIt.I<ClassroomServiceBase>();

    final addedResult = await service.addOne(
      Classroom(
        name: 'Clase X', iconCode: 14785
      )
    );

    final updatedResult = await service.updateOne(addedResult.getValue!.copyWith(name: 'Clase Y', iconCode: 12369));
    final getResult = await service.getOne(addedResult.getValue!.id);

    testil.customExpect(updatedResult, isA<Success>(),
      about: 'Actualización de un aula', n: 1
    );

    testil.customExpect(getResult.getValue!.name, 'Clase Y',
      about: 'Verificación de la actualización', n: 2
    );

    testil.customExpect(getResult.getValue!.id, addedResult.getValue!.id,
      about: "Verificar que sus identificadores sean iguales", n: 3
    );
  });

  test('Obtener un aula', () async {
    final service = GetIt.I<ClassroomServiceBase>();

    final results = await Future.wait([
      service.getOne('0'),
      service.getOne('6615024f-0153-4492-b06e-0cb108f90ac6')
    ]);

    final badResult = results[0];
    final goodResult = results[1];

    testil.customExpect(goodResult, isA<Success>(),
      about: "Obtención de un aula existente", output: goodResult.message, n: 1
    );

    testil.customExpect(goodResult.getValue!.name, "Clase A",
      about: "Corroborar el nombre del aula obtenido", output: goodResult.message, n: 2
    );

    testil.customExpect(badResult, isA<NawiError>(),
      about: "Obtención de un aula no existente", output: badResult.message, n: 3
    );
  });

  group('Filtro de aulas', () {

    test('Contador de aulas', () async {
      final service = GetIt.I<ClassroomServiceBase>();
      var stream = service.getAllCount(ClassroomFilter());

      testil.customExpect(await stream.first, 2,
        about: 'Obtener cantidad de aulas', n: 1
      );
    });

    test('Contador de elementos dentro de aulas', () async {
      final studentService = GetIt.I<StudentServiceBase>();

      var streamStudent = studentService.getAllCount(StudentFilter(
        classroomId: '6615024f-0153-4492-b06e-0cb108f90ac6'
      ));
      testil.customExpect(await streamStudent.first, 6,
        about: 'Obtener cantidad de estudiantes de Aula A', n: 1
      );

      streamStudent = studentService.getAllCount(StudentFilter(
        classroomId: 'b393e6bb-9b59-4c74-95ca-e7969bf5262a'
      ));
      testil.customExpect(await streamStudent.first, 2,
        about: 'Obtener cantidad de estudiantes de Aula B', n: 2
      );

      final registerBookService = GetIt.I<RegisterBookServiceBase>();
      var registerBookStream = await registerBookService.getAllCount(RegisterBookFilter(
        classroomId: '6615024f-0153-4492-b06e-0cb108f90ac6'
      ));
      testil.customExpect(await registerBookStream.first, 6,
        about: 'Obtener cantidad de registros de Aula A', n: 3
      );

      registerBookStream = await registerBookService.getAllCount(RegisterBookFilter(
        classroomId: 'b393e6bb-9b59-4c74-95ca-e7969bf5262a'
      ));
      testil.customExpect(await registerBookStream.first, 1,
        about: 'Obtener cantidad de registros de Aula B', n: 4
      );
    });

    test('Ordenamiento de aulas', () async {
      final service = GetIt.I<ClassroomServiceBase>();

      var result = await service.getAll(
        ClassroomFilter(orderBy: ClassroomOrderBy.nameAsc, pageSize: 1, currentPage: 0)
      );
      testil.customExpect(result, isA<Success>(),
        about: 'Comprobación del resultado del ordenamiento', n: 1
      );

      testil.customExpect(result.getValue!.first, testil.classroomHighestName,
          about: 'Ordenamiento por nombre ascendente', n: 2
      );

      result = await service.getAll(
        ClassroomFilter(orderBy: ClassroomOrderBy.nameDesc)
      );
      testil.customExpect(result.getValue!.first, testil.classroomLowestName,
        about: 'Ordenamiento por nombre descendente', n: 3
      );

      result = await service.getAll(
        ClassroomFilter(orderBy: ClassroomOrderBy.timestampRecently)
      );
      testil.customExpect(result.getValue!.first, testil.classroomRecently,
        about: 'Ordenamiento por aula reciente', n: 3
      );

      result = await service.getAll(
        ClassroomFilter(orderBy: ClassroomOrderBy.timestampOldy)
      );
      testil.customExpect(result.getValue!.first, testil.classroomOldy,
        about: 'Ordenamiento por aula antigua', n: 4
      );

    });
  
    test('Paginado de aulas', () async {
      final service = GetIt.I<ClassroomServiceBase>();

      var result = await service.getAllPaginated(pageSize: 3, currentPage: 1, params: ClassroomFilter());

      testil.customExpect(result, isA<Success>(),
        about: "Comprobación de resultado por paginado", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.data.length, 2,
        about: "Paginado de X longitud", n: 2
      );

      result = await service.getAllPaginated(pageSize: 1, currentPage: 2, params: ClassroomFilter());

      testil.customExpect(result.getValue!.data.length, 1,
        about: "Paginado de X longitud y X pagina", n: 3
      );

      result = await service.getAllPaginated(pageSize: 1, currentPage: 10, params: ClassroomFilter());

      testil.customExpect(result.getValue!.data.length, 0,
        about: "Paginado fuera de rango", n: 4
      );      
    });
  
    test('Búsqueda por nombre', () async {
      final service = GetIt.I<ClassroomServiceBase>();

      var result = await service.getAll(ClassroomFilter(nameLike: 'b'));

      testil.customExpect(result, isA<Success>(),
        about: "Comprobación de resultado por nombre de estudiante", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.any((e) => e.name == 'Clase B'), true,
        about: "Busqueda por nombre por un caracter aleatorio", n: 2
      );

      result = await service.getAll(ClassroomFilter(nameLike: "ñ"));

      testil.customExpect(result.getValue!.isEmpty, true,
        about: "Busqueda por nombre y que no exista", n: 3
      );

      result = await service.getAll(ClassroomFilter(nameLike: "  "));

      testil.customExpect(result.getValue!.length, 2,
        about: "Busqueda por nombre y que sean espacios en blanco", n: 4
      );
    });

    test('Busqueda por estatus', () async {
      final service = GetIt.I<ClassroomServiceBase>();

      var result = await service.getAll(ClassroomFilter(searchByStatus: ClassroomStatus.ended));

      testil.customExpect(result, isA<Success>(),
        about: "Búsqueda por tipo correcta", output: result.message, n: 1
      );

      testil.customExpect(result.getValue!.length, 1,
        about: "Búsqueda por status acabado", n: 2
      );

      result = await service.getAll(ClassroomFilter()); 

      testil.customExpect(result.getValue!.length, 2,
        about: "Búsqueda sin aplicar filtro de tipo", n: 3
      );

      result = await service.getAll(ClassroomFilter(searchByStatus: ClassroomStatus.inProgress));
      testil.customExpect(result.getValue, isEmpty,
        about: "Búsqueda sin aplicar filtro de tipo", n: 4
      );

    });
  });
}