import 'package:flutter/material.dart';
import 'package:nawiapp/domain/models/register_book.dart';
import 'package:nawiapp/presentation/registration_book/add_registers_book/widgets/mention_student_form_field.dart';
import 'package:nawiapp/presentation/widgets/loading_process_button.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class AddRegisterBookScreen extends StatefulWidget {
  const AddRegisterBookScreen({super.key});

  @override
  State<AddRegisterBookScreen> createState() => _AddRegisterBookScreenState();
}

class _AddRegisterBookScreenState extends State<AddRegisterBookScreen> {

  final _formKey = GlobalKey<FormState>();
  final _actionKey = GlobalKey<FormFieldState<RegisterBook>>();
  final _btnController = RoundedLoadingButtonController();

  Future<void> onSubmit() async {
    if(_formKey.currentState!.validate()) {
      print(_actionKey.currentState?.value?.action);
      print(_actionKey.currentState?.value?.mentions.map((e) => e.mentionLabel));
      _btnController.success();
      return;
    }
    _btnController.error();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        persistentFooterButtons: [
          LoadingProcessButton(
            controller: _btnController,
            width: MediaQuery.of(context).size.width,
            label: const Text("Crear registro"),
            color: Theme.of(context).colorScheme.inversePrimary,
            proccess: onSubmit,
          ),
        ],
        appBar: AppBar(
          leading: const BackButton(),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Crear registro de estudiante"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16,32,16,16),
            child: MentionStudentFormField(formFieldKey: _actionKey)
          )
        ),
      ),
    );
  }
}