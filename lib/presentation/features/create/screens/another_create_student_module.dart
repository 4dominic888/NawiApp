import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/presentation/features/create/providers/create_student_form_provider.dart';
import 'package:nawiapp/presentation/shared/submit_status.dart';
import 'package:nawiapp/presentation/widgets/another_student_element.dart';
import 'package:nawiapp/presentation/widgets/loading_process_button.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';
import 'package:nawiapp/utils/nawi_form_utils.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class AnotherCreateStudentModule extends ConsumerStatefulWidget {

  final Student? data;
  const AnotherCreateStudentModule({super.key, this.data});

  @override
  ConsumerState<AnotherCreateStudentModule> createState() => _AnotherCreateStudentModuleState();
}

class _AnotherCreateStudentModuleState extends ConsumerState<AnotherCreateStudentModule> {

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  final _btnController = RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    final Student? initialValue = widget.data;
    _nameController = TextEditingController(text: initialValue?.name ?? '');
    _notesController = TextEditingController(text: initialValue?.notes ?? '');    
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentFormState = ref.watch(studentFormProvider(widget.data).select((e) => e.data));
    final formNotifier = ref.read(studentFormProvider(widget.data).notifier);
    ref.listen(studentFormProvider(widget.data), (_, next) => 
      NawiFormUtils.handleSubmitStatus(status: next.status, controller: _btnController) 
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Vista previa", style: Theme.of(context).textTheme.headlineSmall),
          
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: AnotherStudentElement(
              isPreview: true,
              item: StudentSummary(
                id: studentFormState.id, name: studentFormState.name, age: studentFormState.age
              )
            ),
          ),
      
          const Divider(),
      
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.data == null ? "Agregar estudiante" : "Editar estudiante",
                  style: Theme.of(context).textTheme.headlineSmall
                ),
              ),
    
              const SizedBox(width: 10),
    
              Expanded(
                child: LoadingProcessButton(
                  controller: _btnController,
                  proccess: formNotifier.isValid ? () async => await formNotifier.submit(idToEdit: widget.data?.id) : null,
                  label: const Text("Completar"),
                  onReset: () => formNotifier.setStatus(SubmitStatus.idle),
                ),
              )
            ],
          ),
      
          const SizedBox(height: 20),
      
          TextFormField(
            controller: _nameController,
            validator: formNotifier.nameValidator,
            onChanged: formNotifier.setName,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              labelText: 'Nombre',
              hintText: 'Nombre del estudiante',
              suffix: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  formNotifier.clearName();
                  _nameController.clear();
                },
              ),
              filled: true,
              fillColor: NawiColorUtils.secondaryColor.withAlpha(110),
              floatingLabelBehavior: FloatingLabelBehavior.always
            ),
          ),
      
          const SizedBox(height: 20),
      
          TextFormField(
            controller: _notesController,
            onChanged: formNotifier.setNotes,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Notas',
              hintText: 'Ingrese detalles adicionales (Opcional)',
              suffix: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  formNotifier.clearNotes();
                  _notesController.clear();
                }
              ),
              filled: true,
              fillColor: NawiColorUtils.secondaryColor.withAlpha(110),
              floatingLabelBehavior: FloatingLabelBehavior.always
            ),
          ),
      
          const SizedBox(height: 25),
      
          Center(
            child: SegmentedButton<StudentAge>(
              segments: NawiGeneralUtils.studentAges.map(
                (e) => ButtonSegment(value: e, label: Text(e.name))
              ).toList(),
              selected: { studentFormState.age },
              onSelectionChanged: formNotifier.setAge,
              multiSelectionEnabled: false,
            ),
          ),
      
      
          if(NawiGeneralUtils.isKeyboardVisible(context)) Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
          )
        ],
      ),
    );
  }
}