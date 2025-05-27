import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  Widget build(BuildContext context) {
    return SelectableModelBased(
      label: '¿Que desea agregar?: ',
      padding: const EdgeInsets.all(20.0),
      studentModule: CreateStudentModule(data: ref.watch(initialStudentFormDataProvider)),
      registerBookModule: CreateRegisterBookModule(data: ref.watch(initialRegisterBookFormDataProvider)),
      controller: selectableElementForCreateProvider
    );
  }
}