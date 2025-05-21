import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/classroom/entity/classroom.dart';
import 'package:nawiapp/presentation/features/select_classroom/providers/create_classroom_form_provider.dart';
import 'package:nawiapp/presentation/features/select_classroom/widgets/classroom_icon_selector_field.dart';
import 'package:nawiapp/presentation/widgets/loading_process_button.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class AddClassroomModal extends ConsumerStatefulWidget {

  final Classroom? data;

  const AddClassroomModal({ super.key, this.data });

  @override
  ConsumerState<AddClassroomModal> createState() => _AddClassroomModalState();
}

class _AddClassroomModalState extends ConsumerState<AddClassroomModal> {

  final _createBtnController = RoundedLoadingButtonController();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.data?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final classroomFormNotifier = ref.read(classroomFormProvider(widget.data).notifier);

    return AlertDialog(
      title: Text("${widget.data == null ? "Crear" : "Editar"} aula", style: Theme.of(context).textTheme.headlineMedium),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                onChanged: classroomFormNotifier.setName,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Nombre del aula",
                  errorText: classroomFormNotifier.nameErrorText,
                  prefixIcon: const Icon(Icons.abc)
                ),
              ),

              const SizedBox(height: 10),

              ClassroomIconSelectorField(onIconSelected: (value) =>
                classroomFormNotifier.setIcon(value)
              ),

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
            proccess: classroomFormNotifier.isValid ?
              () async => await classroomFormNotifier.submit(
                buttonController: _createBtnController, idToEdit: widget.data?.id
              ) : null,
            label: const Text('Crear')
          ),
        )
      ],
    );
  }
}