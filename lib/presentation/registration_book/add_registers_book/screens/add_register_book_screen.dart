import 'package:flutter/material.dart';
import 'package:nawiapp/presentation/registration_book/add_registers_book/widgets/button_speech_form_field.dart';
import 'package:nawiapp/presentation/widgets/loading_process_button.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class AddRegisterBookScreen extends StatefulWidget {
  const AddRegisterBookScreen({super.key});

  @override
  State<AddRegisterBookScreen> createState() => _AddRegisterBookScreenState();
}

class _AddRegisterBookScreenState extends State<AddRegisterBookScreen> {

  final _formKey = GlobalKey<FormState>();
  final _actionKey = GlobalKey<FormFieldState<String>>();
  final _btnController = RoundedLoadingButtonController();

  Future<void> onSubmit() async {
    if(_formKey.currentState!.validate()) {
      // print(_studentKey.currentState!.value!.map((e) => e.name));
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
        appBar: AppBar(
          leading: const BackButton(),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Crear registro de estudiante"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16,32,16,16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  
                // MultiDropDownFormField<Student>(
                //   formFieldKey: _studentKey,
                //   label: "Selecciona a los estudiantes",
                //   icon: const Icon(Icons.person),
                //   items: _studentItems.map((e) => DropdownItem(label: e.name, value: e)).toList(),
                // ),
                  
                const SizedBox(height: 30),

                ButtonSpeechFormField(
                  actionKey: _actionKey
                ),

                const SizedBox(height: 30),
                  
                LoadingProcessButton(
                  controller: _btnController,
                  width: MediaQuery.of(context).size.width,
                  label: const Text("Crear estudiante"),
                  color: Theme.of(context).colorScheme.inversePrimary,
                  proccess: onSubmit,
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}