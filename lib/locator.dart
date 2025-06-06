import 'package:get_it/get_it.dart';
import 'package:nawiapp/data/drift_connection.dart';
import 'package:nawiapp/domain/daos/classroom_dao.dart';
import 'package:nawiapp/domain/daos/register_book_dao.dart';
import 'package:nawiapp/domain/daos/student_register_book_dao.dart';
import 'package:nawiapp/domain/daos/student_dao.dart';
import 'package:nawiapp/domain/services/classroom_service_base.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/infrastructure/fonts/open_sans_font.dart';
import 'package:nawiapp/infrastructure/in_memory_storage.dart';
import 'package:nawiapp/infrastructure/secure_credential_manager.dart';
import 'package:nawiapp/presentation/implementations/classroom_service_implement.dart';
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

  locator.registerLazySingleton<ClassroomDAO>(() => ClassroomDAO(
    locator<NawiDatabase>()
  ));

  //* Services
  locator.registerLazySingleton<StudentServiceBase>(() => StudentServiceImplement(
    locator<StudentDAO>(), locator<StudentRegisterBookDAO>()
  ));

  locator.registerLazySingleton<RegisterBookServiceBase>(() => RegisterBookServiceImplement(
    locator<RegisterBookDAO>(), locator<StudentRegisterBookDAO>()
  ));

  locator.registerLazySingleton<ClassroomServiceBase>(() => ClassroomServiceImplement(
    locator<ClassroomDAO>()
  ));

  //* Extra
  locator.registerLazySingletonAsync<OpenSansFont>(() async => await OpenSansFont.load());

  locator.registerLazySingleton<InMemoryStorage>(() => InMemoryStorage());

  locator.registerLazySingletonAsync<SecureCredentialManager>(() async => await SecureCredentialManager.init());
}