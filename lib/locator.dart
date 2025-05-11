import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/daos/register_book_dao.dart';
import 'package:nawiapp/domain/daos/student_register_book_dao.dart';
import 'package:nawiapp/domain/daos/student_dao.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/infrastructure/fonts/open_sans_font.dart';
import 'package:nawiapp/presentation/implementations/register_book_service_implement.dart';
import 'package:nawiapp/presentation/implementations/student_service_implement.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  //* DB
  locator.registerLazySingleton<NawiDatabase>(() => NawiDatabase());

  //* Repositories
  locator.registerLazySingleton<StudentDAO>(() => StudentDAO(
    locator<NawiDatabase>()
  ));

  locator.registerLazySingleton<RegisterBookDAO>(() => RegisterBookDAO(
    locator<NawiDatabase>()
  ));

  locator.registerLazySingleton<StudentRegisterBookDAO>(() => StudentRegisterBookDAO(
    locator<NawiDatabase>()
  ));

  //* Services
  locator.registerLazySingleton<StudentServiceBase>(() => StudentServiceImplement(
    locator<StudentDAO>(), locator<StudentRegisterBookDAO>()
  ));

  locator.registerLazySingleton<RegisterBookServiceBase>(() => RegisterBookServiceImplement(
    locator<RegisterBookDAO>(), locator<StudentRegisterBookDAO>()
  ));

  //* Extra
  locator.registerLazySingletonAsync<OpenSansFont>(() async => await OpenSansFont.load());
}