import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/models/register_book/summary/register_book_summary.dart';
import 'package:nawiapp/presentation/features/create/providers/register_book/create_register_book_form_provider.dart';
import 'package:nawiapp/presentation/features/create/widgets/another_mention_student_field.dart';
import 'package:nawiapp/presentation/shared/submit_status.dart';
import 'package:nawiapp/presentation/widgets/another_register_book_element.dart';
import 'package:nawiapp/presentation/widgets/dropdown_menu_form_field.dart';
import 'package:nawiapp/presentation/widgets/loading_process_button.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';
import 'package:nawiapp/utils/nawi_form_utils.dart';
import 'package:nawiapp/utils/nawi_general_utils.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CreateRegisterBookModule extends ConsumerStatefulWidget {

  final RegisterBook? data;
  const CreateRegisterBookModule({ super.key, this.data });

  @override
  ConsumerState<CreateRegisterBookModule> createState() => _CreateRegisterBookModuleState();
}

class _CreateRegisterBookModuleState extends ConsumerState<CreateRegisterBookModule> {

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _actionController;
  late final TextEditingController _notesController;
  final _scrollController = ScrollController();

  final _submitBtnController = RoundedLoadingButtonController();

  void _scrollToBotton() {
    Future.delayed(const Duration(milliseconds: 700), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    final RegisterBook? initialValue = widget.data;
    _actionController = TextEditingController(text: initialValue?.action ?? '');
    _notesController = TextEditingController(text: initialValue?.notes ?? '');
  }

  @override
  void dispose() {
    _actionController.dispose();
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final registerBookFormState = ref.watch(registerBookFormProvider(widget.data).select((e) => e.data));
    final formNotifier = ref.read(registerBookFormProvider(widget.data).notifier);
    ref.listen(registerBookFormProvider(widget.data), (_, next) =>
      NawiFormUtils.handleSubmitStatus(status: next.status, controller: _submitBtnController)
    );

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Vista previa", style: Theme.of(context).textTheme.headlineSmall),
        
            Padding(
              padding: EdgeInsets.all(2),
              child: AnotherRegisterBookElement(
                isPreview: true,
                item: RegisterBookSummary(
                  id: registerBookFormState.id,
                  action: registerBookFormState.action,
                  createdAt: registerBookFormState.createdAt,
                  type: registerBookFormState.type,
                  mentions: registerBookFormState.mentions
                ),
              ),
            ),
        
            Divider(),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${widget.data == null ? "Agregar " : "Editar "} registro",
                    style: Theme.of(context).textTheme.headlineSmall
                  )
                ),
        
                Expanded(
                  child: LoadingProcessButton(
                    color: widget.data == null ? NawiColorUtils.primaryColor : Colors.blue.shade400,
                    controller: _submitBtnController,
                    proccess: formNotifier.isValid ? () async => await formNotifier.submit(idToEdit: widget.data?.id) : null,
                    label: Text(widget.data == null ? "Agregar" : "Editar"),
                    onReset: () => formNotifier.setStatus(SubmitStatus.idle)
                  ),
                )
              ],
            ),
        
            const SizedBox(height: 20),
        
            DropdownMenuFormField<RegisterBookType>(
              initialSelection: widget.data?.type ?? RegisterBookType.register,
              requestFocusOnTap: false,
              label: const Text("Tipo"),
              width: MediaQuery.of(context).size.width,
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: NawiColorUtils.secondaryColor.withAlpha(110),
              ),
              onSelected: formNotifier.setType,
              dropdownMenuEntries: RegisterBookType.values.map(
                (e) => DropdownMenuEntry(value: e, label: e.name, leadingIcon: switch (e) {
                  RegisterBookType.register => const Icon(Icons.app_registration_rounded),
                  RegisterBookType.anecdotal => const Icon(Icons.star),
                  RegisterBookType.incident => const Icon(Icons.warning)
                })
              ).toList(),
            ),
        
            const SizedBox(height: 20),
        
            TextFormField(
              controller: _actionController,
              maxLines: 3,
              readOnly: true,
              onTap: () async {
                final actionMentionsRecord = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AnotherMentionStudentField(
                    action: registerBookFormState.action,
                    mentions: registerBookFormState.mentions,
                  ))
                );
        
                if(actionMentionsRecord != null) {
                  formNotifier.setAction(actionMentionsRecord.$1);
                  _actionController.text = actionMentionsRecord.$1;
                  formNotifier.setMentions(actionMentionsRecord.$2);
                }
              },            
              decoration: InputDecoration(
                labelText: 'Acción',
                hintText: 'Presione este campo para comenzar a registrar la acción',
                filled: true,
                fillColor: NawiColorUtils.secondaryColor.withAlpha(110),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                errorText: formNotifier.actionErrorText,
                suffix: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _actionController.clear();
                    formNotifier.clearMentions();
                    formNotifier.clearAction();
                  },
                ),
              )
            ),
        
            const SizedBox(height: 20),
        
            DateTimeFormField(
              initialValue: widget.data?.createdAt ?? registerBookFormState.createdAt,
              firstDate: DateTime(2023),
              lastDate: DateTime.now(),
              onChanged: formNotifier.setTimestamp,
              dateFormat: DateFormat('dd/MM/y hh:mm a'),
              canClear: false,
              decoration: InputDecoration(
                labelText: 'Fecha de creación',
                filled: true,
                fillColor: NawiColorUtils.secondaryColor.withAlpha(110),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                errorText: formNotifier.createdAtErrorText
              ),
            ),
        
            const SizedBox(height: 20),
        
            TextFormField(
              controller: _notesController,
              onTap: _scrollToBotton,
              onChanged: formNotifier.setNotes,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Notas',
                hintText: 'Ingrese detalles adicionales (Opcional)',
                suffix: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _notesController.clear();
                    formNotifier.clearNotes();
                  }
                ),
                filled: true,
                fillColor: NawiColorUtils.secondaryColor.withAlpha(110),
                floatingLabelBehavior: FloatingLabelBehavior.always
              ),
            ),
          
            if(NawiGeneralUtils.isKeyboardVisible(context)) Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 1.1)
            )
          ],
        ),
      ),
    );
  }
}