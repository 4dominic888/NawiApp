import 'package:flutter/material.dart';
import 'package:nawiapp/presentation/features/create/screens/another_create_register_book_module.dart';
import 'package:nawiapp/presentation/features/create/screens/another_create_student_module.dart';
import 'package:nawiapp/presentation/widgets/selectable_model_based.dart';

class CreateElementScreen extends StatefulWidget {
  const CreateElementScreen({ super.key });

  @override
  State<CreateElementScreen> createState() => _CreateElementScreenState();
}

class _CreateElementScreenState extends State<CreateElementScreen> {

  @override
  Widget build(BuildContext context) {

    return SelectableModelBased(
      padding: const EdgeInsets.all(20.0),
      studentModule: SingleChildScrollView(child: AnotherCreateStudentModule()),
      registerBookModule: SingleChildScrollView(child: AnotherCreateRegisterBookModule())
    );
  }
}