import 'package:flutter/material.dart';
import 'package:nawiapp/presentation/features/select_classroom/widgets/classroom_icon_selector_field.dart';
import 'package:nawiapp/presentation/widgets/loading_process_button.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class AddClassroomModal extends StatefulWidget {
  const AddClassroomModal({ super.key });

  @override
  State<AddClassroomModal> createState() => _AddClassroomModalState();
}

class _AddClassroomModalState extends State<AddClassroomModal> {

  final _createBtnController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Crear aula", style: Theme.of(context).textTheme.headlineMedium),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nombre del aula"
                ),
              ),

              const SizedBox(height: 10),

              ClassroomIconSelectorField(onIconSelected: (value) {
                
              }),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: const Divider(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Cancelar")
        ),

        SizedBox(
          width: 100,
          child: LoadingProcessButton(
            autoResetable: true,
            controller: _createBtnController,
            proccess: () async {
              await Future.delayed(const Duration(seconds: 1));
              _createBtnController.error();
            },
            label: const Text('Crear')
          ),
        )
      ],
    );
  }
}