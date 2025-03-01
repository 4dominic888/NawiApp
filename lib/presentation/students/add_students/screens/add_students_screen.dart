import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';
import 'package:nawiapp/presentation/widgets/loading_process_button.dart';
import 'package:nawiapp/presentation/widgets/notification_message.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({super.key, this.idToEdit});

  final String? idToEdit;

  @override
  State<AddStudentsScreen> createState() => _AddStudentsScreenState();
}

class _AddStudentsScreenState extends State<AddStudentsScreen> {

  bool _isUpdatable = false;

  final _studentService = GetIt.I<StudentServiceBase>();

  final _formKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormFieldState<String>>();
  final _ageKey = GlobalKey<FormFieldState<StudentAge>>();
  final _btnController = RoundedLoadingButtonController();

  Future<void> onSubmit() async {
    if(_isUpdatable && widget.idToEdit != null) {
      _btnController.error();
      return;
    }

    if(_formKey.currentState!.validate()) {

      final Result<Object> result;
      final Student student = Student(
        name: _nameKey.currentState!.value!,
        age: _ageKey.currentState!.value!
      );

      if(!_isUpdatable) { //* Crear
        result = await _studentService.addOne(student);
      } else { //* Editar
        result = await _studentService.updateOne(student.copyWith(id: widget.idToEdit));
      }

      result.onValue(
        onError: (_, message) => NotificationMessage.showErrorNotification(message),
        onSuccessfully: (_, message) => NotificationMessage.showSuccessNotification(message),
      );

      _btnController.success();
      return;
    }
    _btnController.error();
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<Result<Student>>(
      future: _studentService.getOne(widget.idToEdit),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) SmartDialog.showLoading(animationType: SmartAnimationType.scale);
        final data = snapshot.data?.getValue;
        _isUpdatable = data != null;
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              leading: const BackButton(),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text("${_isUpdatable ? "Editar" : "Crear"} estudiante")
            ),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16,32,16,16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  
                      Center(
                        child: CircleAvatar(
                          radius: screenWidth / 9,
                          backgroundColor: NawiColor.iconColorMap(_ageKey.currentState?.value?.value ?? 0, withOpacity: true),
                          child: Icon(
                            Icons.person,
                            size: screenWidth / 9,
                            color: NawiColor.iconColorMap(_ageKey.currentState?.value?.value ?? 0)
                          )
                        )
                      ),
                  
                      const SizedBox(height: 30),
                  
                      TextFormField(
                        key: _nameKey,
                        initialValue: data?.name,
                        decoration: const InputDecoration(
                          labelText: "Nombre",
                          prefixIcon: Icon(Icons.accessibility_new_rounded),
                          border: OutlineInputBorder()
                        ),
                        validator: (value) {
                          if(value == null || value.trim().isEmpty) return "No se ha proporcionado un nombre";
                          value = NawiTools.clearText(value);
                          if(value.length <= 2) return "El nombre es demasiado corto";
                          return null;
                        },
                      ),
                  
                      const SizedBox(height: 30),
                  
                      DropdownButtonFormField<StudentAge>(
                        key: _ageKey,
                        value: data?.age,
                        decoration: const InputDecoration(
                          labelText: "Selecciona la edad",
                          prefixIcon: Icon(Icons.apple),
                          border: OutlineInputBorder()
                        ),
                        items: [
                          DropdownMenuItem(value: StudentAge.threeYears, child: const Text("3 años")),
                          DropdownMenuItem(value: StudentAge.fourYears, child: const Text("4 años")),
                          DropdownMenuItem(value: StudentAge.fiveYears, child: const Text("5 años"))
                        ],
                        onChanged: (value) => setState(() {}),
                        validator: (value) {
                          if(value == null) return "Debes seleccionar una opción";
                          return null;
                        },
                      ),
                  
                      const SizedBox(height: 30),
                  
                      LoadingProcessButton(
                        controller: _btnController,
                        width: screenWidth,
                        label: Text("${_isUpdatable ? "Editar" : "Crear"} estudiante"),
                        color: _isUpdatable ? Colors.blue : Theme.of(context).colorScheme.inversePrimary,
                        proccess: onSubmit,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}