import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/database_connection.dart';
import 'package:nawiapp/domain/repositories/register_book_repository.dart';
import 'package:nawiapp/domain/repositories/student_register_book_repository.dart';
import 'package:nawiapp/domain/repositories/student_repository.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/presentation/students/implementations/student_service_implement.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  //* DB
  locator.registerLazySingleton<NawiDatabase>(() => NawiDatabase());

  //* Repositories
  locator.registerLazySingleton<StudentRepository>(() => StudentRepository(
    locator<NawiDatabase>()
  ));

  locator.registerLazySingleton<RegisterBookRepository>(() => RegisterBookRepository(
    locator<NawiDatabase>()
  ));

  locator.registerLazySingleton<StudentRegisterBookRepository>(() => StudentRegisterBookRepository(
    locator<NawiDatabase>()
  ));

  //* Services
  locator.registerLazySingleton<StudentServiceBase>(() => StudentServiceImplement(
    locator<StudentRepository>()
  ));
}