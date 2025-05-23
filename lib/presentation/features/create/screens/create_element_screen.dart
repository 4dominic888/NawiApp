import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/presentation/features/create/providers/register_book/initial_register_book_form_data_provider.dart';
import 'package:nawiapp/presentation/features/create/providers/student/initial_student_form_data_provider.dart';
import 'package:nawiapp/presentation/features/create/providers/selectable_element_for_create_provider.dart';
import 'package:nawiapp/presentation/features/create/screens/create_register_book_module.dart';
import 'package:nawiapp/presentation/features/create/screens/create_student_module.dart';
import 'package:nawiapp/presentation/widgets/selectable_model_based.dart';

class CreateElementScreen extends ConsumerStatefulWidget {
  const CreateElementScreen({ super.key });

  @override
  ConsumerState<CreateElementScreen> createState() => _CreateElementScreenState();
}

class _CreateElementScreenState extends ConsumerState<CreateElementScreen> {

  Student? _studentInitialData;
  RegisterBook? _registerBookInitialData;

  /// Esto solo automatiza lo que indica [didChangeDependencies]
  bool initializeData<T>(StateProvider<T?> stateProvider) {
    final dataProviderInitialData = ref.read(stateProvider);
    if(dataProviderInitialData != null) {
      //* Dato inicializado para que el formulario edite el elemento en vez de crearlo
      if(dataProviderInitialData.runtimeType == Student) {
        _studentInitialData = dataProviderInitialData as Student;
      }
      else {
        _registerBookInitialData = dataProviderInitialData as RegisterBook;
      }

      //* Resuelve el siguiente error, al igual que usar esto en didChangeDependencies
      //? Tried to modify a provider while the widget tree was building.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(stateProvider.notifier).state = null
      );
      return true;
    }
    return false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //* Sirve para poder inicializar los formularios con datos en casos de edición.

    //* Pero con la diferencia que esta conectados a un provider, de modo que es posible
    //* llenar estos datos desde cualquier parte de la app. Ejemplo:
    /*
      * ref.read(initialStudentFormDataProvider.notifier).state = data
    */

    //* Cuando se ingrese a esta pantalla de manera tradicional, se tendrá el campo de formulario vacio.

    if(initializeData(initialStudentFormDataProvider)) return;
    initializeData(initialRegisterBookFormDataProvider);
  }

  @override
  Widget build(BuildContext context) {
    return SelectableModelBased(
      padding: const EdgeInsets.all(20.0),
      studentModule: CreateStudentModule(data: _studentInitialData),
      registerBookModule: CreateRegisterBookModule(data: _registerBookInitialData),
      controller: selectableElementForCreateProvider
    );
  }
}