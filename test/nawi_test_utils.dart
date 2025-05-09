import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/data/mappers/student_mapper.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/domain/daos/register_book_dao.dart';
import 'package:nawiapp/domain/daos/student_register_book_dao.dart';
import 'package:nawiapp/domain/daos/student_dao.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/presentation/implementations/register_book_service_implement.dart';
import 'package:nawiapp/presentation/implementations/student_service_implement.dart';

  final GetIt _locator = GetIt.instance;

  Future<void> setupIntegrationTestLocator({bool withRegisterBook = false}) async {
    await _locator.reset();

    _locator.registerLazySingleton<NawiDatabase>(() => NawiDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true
    )));

    _locator.registerLazySingleton<StudentDAO>(() => StudentDAO(_locator<NawiDatabase>()));
    _locator.registerLazySingleton<RegisterBookDAO>(() => RegisterBookDAO(_locator<NawiDatabase>()));
    _locator.registerLazySingleton<StudentRegisterBookDAO>(() => StudentRegisterBookDAO(_locator<NawiDatabase>()));

    _locator.registerLazySingleton<StudentServiceBase>(() => 
      StudentServiceImplement(_locator<StudentDAO>(), _locator<StudentRegisterBookDAO>())
    );
    _locator.registerLazySingleton<RegisterBookServiceBase>(() => 
      RegisterBookServiceImplement(_locator<RegisterBookDAO>(), _locator<StudentRegisterBookDAO>())
    );

    await addingTestData(withRegisterBook);
  }

  Future<void> onTearDownSetupIntegrationTestLocator() async {
    await _locator<NawiDatabase>().close();
    await _locator.reset();
  }

  final listOfStudents = <Student>[
    Student(id: '1d03982a-7a0a-40f2-adb4-1e90c2550485', name: "Jose Olaya", age: StudentAge.threeYears).copyWith(timestamp: DateTime(2025, 1, 8)),
    Student(id: '9d95e4ee-8706-485d-b2a9-614583a05296', name: "Pablo Rojas", age: StudentAge.fourYears).copyWith(timestamp: DateTime(2025, 1, 9)),
    Student(id: '580e4114-98c8-4b80-92ea-b44c140f26e3', name: "Mendo Cabrera", age: StudentAge.fiveYears).copyWith(timestamp: DateTime(2025, 2, 1)),
    Student(id: '194c4084-0fdf-49f2-86d7-766b7607ce0b', name: "Bruno Sorias Alias El Cumbia Ninja", age: StudentAge.threeYears).copyWith(timestamp: DateTime(2025, 5, 1)),
    Student(id: '8722e6e9-6178-4296-948a-7fb3db196d44', name: "Gerardo Días", age: StudentAge.fourYears).copyWith(timestamp: DateTime(2025, 3, 20)),
    Student(id: '980bbf70-48de-4946-8d8f-de06a39d7611', name: "Leonardo Da Vinci", age: StudentAge.threeYears).copyWith(timestamp: DateTime(2025, 10, 4)),

    //* A archivar
    Student(id: '750c3a46-3e44-4800-bee1-ebccb4f4f55c', name: "Mario Bros Archived", age: StudentAge.threeYears).copyWith(timestamp: DateTime(2025, 1, 10)),
    Student(id: '9ee64bbd-1011-4849-aec6-eae4a587a8d5', name: "Lopez Garcia Archived", age: StudentAge.threeYears).copyWith(timestamp: DateTime(2025, 1, 11))
  ];

  final listOfRegisterBook = <RegisterBook>[
    RegisterBook(id: 'e0449ae1-ec4d-4eec-a0c2-3b6be2ff46f6', action: "Jose le pego a Pablo", mentions: [listOfStudents[0].toStudentSummary, listOfStudents[1].toStudentSummary], createdAt: DateTime(2025, 1, 5, 11, 32), type: RegisterBookType.incident),
    RegisterBook(id: 'dd1acb1c-86c2-4ba1-a69f-b1c8e24c01ee', action: "Accion indeterminada 1", createdAt: DateTime(2025, 1, 6, 9, 10)),
    RegisterBook(id: '06b654e1-2852-4618-84a7-bb2c43a3eba1', action: "Leonardo, Mendo y Bruno han hecho su actividad", createdAt: DateTime(2025, 1, 6, 8, 5), type: RegisterBookType.anecdotal),
    RegisterBook(id: '10277d6d-630c-4a6e-99ec-f807a64714f6', action: "Al bordo de un barco, Gerardo ha jugado con Jose", createdAt: DateTime(2025, 2, 15, 8, 5), mentions: [listOfStudents[4].toStudentSummary, listOfStudents[0].toStudentSummary], type: RegisterBookType.anecdotal),
    RegisterBook(id: '3984adaf-70c2-45b1-aecc-e0b56bb43158', action: "Otra accioni indeterminada 2", createdAt: DateTime(2025, 1, 1, 7, 30)),
    RegisterBook(id: 'cd334961-cc2f-4c2a-8477-482155e7ed0e', action: "Desde la vista de Bruno, ha visto como Pablo salía del salon", createdAt: DateTime(2025, 3, 8, 9, 30), mentions: [listOfStudents[3].toStudentSummary, listOfStudents[1].toStudentSummary]),

    //* A archivar
    RegisterBook(id: '743f923b-3a0e-45a9-a681-85408e5fa521', action: "Accion mal escrota Archived", createdAt: DateTime(2025, 2, 7, 8, 50)),
    RegisterBook(id: 'c1b271b1-f21f-4c10-9dae-975f627d0c00', action: "Otra accione mal escrota Archived", createdAt: DateTime(2025, 1, 2, 10, 10), mentions: [listOfStudents[5].toStudentSummary], type: RegisterBookType.incident),
  ];

  Student studentRecently = listOfStudents.reduce((a, b) => a.timestamp.isAfter(b.timestamp) ? a : b);
  Student studentOldy = listOfStudents.reduce((a, b) => a.timestamp.isBefore(b.timestamp) ? a : b);
  Student studentHighestName = listOfStudents.reduce((a, b) => a.name.compareTo(b.name) < 0 ? a : b);
  Student studentLowestName = listOfStudents.reduce((a, b) => a.name.compareTo(b.name) > 0 ? a : b);

  RegisterBook registerBookRecently = listOfRegisterBook.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);
  RegisterBook registerBookOldy = listOfRegisterBook.reduce((a, b) => a.createdAt.isBefore(b.createdAt) ? a : b);
  RegisterBook registerBookHighestAction = listOfRegisterBook.reduce((a, b) => a.action.compareTo(b.action) < 0 ? a : b);
  RegisterBook registerBookLowestAction = listOfRegisterBook.reduce((a, b) => a.action.compareTo(b.action) > 0 ? a : b);

  Future<void> addingTestData(bool withRegisterBook) async {
    final studentService = GetIt.I<StudentServiceBase>();

    //* Estudiantes agregados
    await Future.wait(listOfStudents.map((e) => studentService.addOne(e)));

    //* Estudiantes archivados agregados
    final studentlistAddedToArchive = await studentService.getAll(StudentFilter(nameLike: "archived"));
    await Future.wait(studentlistAddedToArchive.getValue!.map((e) => studentService.archiveOne(e.id)));

    if(withRegisterBook) {
      final registerBookService = GetIt.I<RegisterBookServiceBase>();

      //* Cuadernos de registro agregados
      await Future.wait(listOfRegisterBook.map((e) => registerBookService.addOne(e)));
      final registerBookListAddedToArchive = await registerBookService.getAll(RegisterBookFilter(actionLike: "archived"));
      await Future.wait(registerBookListAddedToArchive.getValue!.map((e) => registerBookService.archiveOne(e.id)));
    }
  }

  /// Expect personalizado para poder tener descripción de la acción exitosa o fallida del test
  /// 
  /// [about] de lo que trata el test
  /// 
  /// [output] es la descripción del expect colocado
  /// 
  /// [n] es el número, solo para enumar los expect
  void customExpect(dynamic actual, dynamic matcher, {required String about , final String? output, required int n}) {
    try {
      expect(actual, matcher);      
      debugPrint('*  \x1B[36mPrueba\x1B[0m \x1B[33m${_c(n.toString())}\x1B[0m acerca de ${_c(about, enfasis: true)} pasado con \x1B[42méxito!\x1B[0m');
      debugPrint('-  \x1B[35mOutput:\x1B[0m ${output ?? ''}');
    } catch (e) {
      debugPrint('*  \x1B[36mPrueba\x1B[0m \x1B[33m${_c(n.toString())}\x1B[0m acerca de ${_c(about, enfasis: true)} \x1B[41mfallido!\x1B[0m');
      debugPrint('-  \x1B[35mOutput:\x1B[0m ${output ?? ''}');
      rethrow;
    }
  }

  /// Solo para poder omitir comas cuando no hay valor
  /// 
  /// [value] en valor en [String]
  /// 
  /// [separator] el separador en cuestion, por defecto es una coma
  /// 
  /// [enfasis] si se desea colocar con comillas dobles
  String? _c(String? value, {String separator = ',', bool enfasis = false}) {
    return value != null && value.isNotEmpty ? 
      enfasis ? 
        '"\x1B[90m$value\x1B[0m"$separator' : '$value$separator'
      : value;
  }

