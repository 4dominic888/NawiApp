import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/presentation/features/create/providers/initial_student_form_data_provider.dart';
import 'package:nawiapp/presentation/features/create/providers/selectable_element_for_create_provider.dart';
import 'package:nawiapp/presentation/features/create/screens/another_create_register_book_module.dart';
import 'package:nawiapp/presentation/features/create/screens/another_create_student_module.dart';
import 'package:nawiapp/presentation/widgets/selectable_model_based.dart';

class CreateElementScreen extends ConsumerStatefulWidget {
  const CreateElementScreen({ super.key });

  @override
  ConsumerState<CreateElementScreen> createState() => _CreateElementScreenState();
}

class _CreateElementScreenState extends ConsumerState<CreateElementScreen> {

  Student? _studentInitialData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final studentProviderInitialData = ref.read(initialStudentFormDataProvider);
    if(_studentInitialData == null && studentProviderInitialData != null) {
      _studentInitialData = studentProviderInitialData;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(initialStudentFormDataProvider.notifier).state = null;
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return SelectableModelBased(
      padding: const EdgeInsets.all(20.0),
      studentModule: SingleChildScrollView(child: AnotherCreateStudentModule(data: _studentInitialData)),
      registerBookModule: SingleChildScrollView(child: AnotherCreateRegisterBookModule()),
      controller: selectableElementForCreateProvider
    );
  }
}