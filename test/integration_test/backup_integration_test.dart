import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/core/ports/backup/backup_service_base.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';

import '../nawi_test_utils.dart' as testil;

void main() {
  setUp(() async => await testil.setupIntegrationTestLocator(withRegisterBook: true));
  tearDown(testil.onTearDownSetupIntegrationTestLocator);

  test('Crear backup', () async {
    final backupService = GetIt.I<BackupServiceBase>();
    final studentService = GetIt.I<StudentServiceBase>();
    final registerBookService = GetIt.I<RegisterBookServiceBase>();
    
    //* Crear backup con datos alterados
    await Future.wait([
      studentService.addOne(Student(name: 'test student backup', age: StudentAge.fiveYears, classroomId: '6615024f-0153-4492-b06e-0cb108f90ac6')),
      studentService.addOne(Student(name: 'another test student backup', age: StudentAge.fourYears, classroomId: '6615024f-0153-4492-b06e-0cb108f90ac6'))
    ]);
    await registerBookService.deleteOne('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6');

    final backupResult = await backupService.backupDatabase('test/backup_test_output/backup.nwdb', isTest: true);

    testil.customExpect(backupResult, isA<Success>(),
      about: 'Proceso de backup exitoso', n: 1
    );

    final outputFile = backupResult.getValue!;

    testil.customExpect(await outputFile.exists(), isTrue,
      about: "Backup generado", n: 2
    );

    testil.customExpect(await outputFile.length(), greaterThan(0),
      about: "Backup con datos", n: 3
    );
  });

  //* Es necesario generar el backup del test de arriba para que funcione adecuadamente
  test('Restaurar backup', () async {
    final backupService = GetIt.I<BackupServiceBase>();

    final backupRestoreResult = await backupService.restoreDatabase('test/backup_test_output/backup.nwdb', isTest: true);

    testil.customExpect(backupRestoreResult, isA<Success>(),
      about: 'Proceso de restauracion exitoso', n: 1
    );

    final studentService = GetIt.I<StudentServiceBase>();
    final students = await studentService.getAll(StudentFilter(nameLike: 'test'));

    testil.customExpect(students.getValue!.length, equals(2),
      about: 'Estudiantes restaurados', n: 2
    );
  
    final registerBookService = GetIt.I<RegisterBookServiceBase>();
    final noRegisterBookFound = await registerBookService.getOne('e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6');

    testil.customExpect(noRegisterBookFound, isA<NawiError>(),
      about: 'No se encontro este registro', n: 3
    );

    final registerBooks = await registerBookService.getAllPaginated(currentPage: 1, pageSize: 1, params: RegisterBookFilter());
    final existenceOfRegisterBook = registerBooks.getValue!.data;

    testil.customExpect(existenceOfRegisterBook.length, equals(1),
      about: 'Registro restaurado', n: 4
    );
  }); 
}