import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/presentation/widgets/loading_process_button.dart';
import 'package:nawiapp/presentation/widgets/multi_drop_down_form_field.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class AddRegisterBookScreen extends StatefulWidget {
  const AddRegisterBookScreen({super.key});

  @override
  State<AddRegisterBookScreen> createState() => _AddRegisterBookScreenState();
}

class _AddRegisterBookScreenState extends State<AddRegisterBookScreen> {

  final _formKey = GlobalKey<FormState>();
  final _studentKey = GlobalKey<FormFieldState<List<Student>>>();
  final _actionKey = GlobalKey<FormFieldState<String>>();
  final _btnController = RoundedLoadingButtonController();

  //* temp value
  final _studentItems = [
    Student(name: "Juana", age: StudentAge.threeYears),
    Student(name: "Paolo", age: StudentAge.fourYears),
    Student(name: "Pedro", age: StudentAge.threeYears),
    Student(name: "Maria Jose", age: StudentAge.fiveYears),
    Student(name: "Jose Maria", age: StudentAge.fourYears)
  ];

  Future<void> onSubmit() async {
    if(_formKey.currentState!.validate()) {
      print(_studentKey.currentState!.value!.map((e) => e.name));
      _btnController.success();
      return;
    }
    _btnController.error();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Crear registro de estudiante"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16,32,16,16),
          child: SingleChildScrollView(child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              MultiDropDownFormField<Student>(
                formFieldKey: _studentKey,
                label: "Selecciona a los estudiantes",
                icon: const Icon(Icons.person),
                items: _studentItems.map((e) => DropdownItem(label: e.name, value: e)).toList(),
              ),

              const SizedBox(height: 30),

              LoadingProcessButton(
                controller: _btnController,
                width: MediaQuery.of(context).size.width,
                label: const Text("Crear estudiante"),
                color: Theme.of(context).colorScheme.inversePrimary,
                proccess: onSubmit,
              ),

              const SizedBox(height: 30),

              TextFormField(
                key: _actionKey,
                decoration: const InputDecoration(
                  labelText: "Acción realizada",
                  prefixIcon: Icon(Icons.attractions),
                  border: OutlineInputBorder()
                ),
                validator: (value) {
                  if(value == null || value.trim().isEmpty) return "No se ha proporcionado una acción";
                  value = value.trim();
                  if(value.length <= 2) return "El nombre es demasiado corto";
                  return null;
                },
              ),

              const SizedBox(height: 30),

              

            ],
          )),
        )
      ),
    );
  }
}