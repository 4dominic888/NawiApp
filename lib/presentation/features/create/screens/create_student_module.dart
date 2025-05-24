import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/presentation/features/create/providers/student/create_student_form_provider.dart';
import 'package:nawiapp/presentation/features/home/extra/menu_tabs.dart';
import 'package:nawiapp/presentation/features/home/providers/tab_index_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/selectable_element_for_search_provider.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';
import 'package:nawiapp/utils/nawi_form_utils.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';

class CreateStudentModule extends ConsumerStatefulWidget {

  final Student? data;
  const CreateStudentModule({super.key, this.data});

  @override
  ConsumerState<CreateStudentModule> createState() => _CreateStudentModuleState();
}

class _CreateStudentModuleState extends ConsumerState<CreateStudentModule> {

  late final TextEditingController _nameController;
  late final TextEditingController _notesController;

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
    ref.listen(studentFormProvider(widget.data).select((e) => e.status), (_, next) {
      NawiFormUtils.handleSubmitStatus(
        status: next,
        onSuccess: () {
          ref.read(studentFormProvider(widget.data).notifier).clearAll();
          _nameController.clear();
          _notesController.clear();
          ref.read(selectableElementForSearchProvider.notifier).state = Student;
          ref.read(tabMenuProvider.notifier).goTo(NawiMenuTabs.search);
        },
      );
    });

    return SingleChildScrollView(
      child: Column(
        children: [
      
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.data == null ? NawiColorUtils.primaryColor : Colors.blue.shade400,
                  ),
                  onPressed: formNotifier.isValid ? () async => await formNotifier.submit(idToEdit: widget.data?.id) : null,
                  child: Text(widget.data == null ? "Agregar" : "Editar")
                  // color: widget.data == null ? NawiColorUtils.primaryColor : Colors.blue.shade400,
                  // controller: _submitBtnController,
                  // proccess: formNotifier.isValid ? () async => await formNotifier.submit(idToEdit: widget.data?.id) : null,
                  // label: Text(widget.data == null ? "Agregar" : "Editar"),
                  // onReset: () => formNotifier.setStatus(SubmitStatus.idle),
                ),
              )
            ],
          ),
      
          const SizedBox(height: 20),
      
          TextFormField(
            controller: _nameController,
            onChanged: formNotifier.setName,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              labelText: 'Nombre',
              hintText: 'Nombre del estudiante',
              errorText: formNotifier.nameErrorText,
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
      
          SegmentedButton<StudentAge>(
            segments: NawiGeneralUtils.studentAges.map(
              (e) => ButtonSegment(value: e, label: Text(e.name))
            ).toList(),
            selected: { studentFormState.age },
            onSelectionChanged: formNotifier.setAge,
            multiSelectionEnabled: false,
          ),
      
          const SizedBox(height: 70),
      
      
          // if(NawiGeneralUtils.isKeyboardVisible(context)) Padding(
          //   padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
          // )
        ],
      ),
    );
  }
}