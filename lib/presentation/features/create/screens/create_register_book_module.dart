import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/presentation/features/create/providers/register_book/create_register_book_form_provider.dart';
import 'package:nawiapp/presentation/features/create/providers/register_book/initial_register_book_form_data_provider.dart';
import 'package:nawiapp/presentation/features/create/screens/another_create_action.dart';
import 'package:nawiapp/presentation/features/home/extra/menu_tabs.dart';
import 'package:nawiapp/presentation/features/home/providers/tab_index_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/selectable_element_for_search_provider.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';
import 'package:nawiapp/utils/nawi_form_utils.dart';

class CreateRegisterBookModule extends ConsumerStatefulWidget {

  final RegisterBook? data;
  const CreateRegisterBookModule({ super.key, this.data });

  @override
  ConsumerState<CreateRegisterBookModule> createState() => _CreateRegisterBookModuleState();
}

class _CreateRegisterBookModuleState extends ConsumerState<CreateRegisterBookModule> {

  late final TextEditingController _actionController;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final RegisterBook? initialValue = widget.data;
    _actionController = TextEditingController(text: initialValue?.action ?? '');
  }

  @override
  void dispose() {
    _actionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final registerBookFormState = ref.watch(registerBookFormProvider(widget.data).select((e) => e.data));
    final formNotifier = ref.read(registerBookFormProvider(widget.data).notifier);
    
    ref.listen(registerBookFormProvider(widget.data).select((e) => e.status), (_, next) =>
      NawiFormUtils.handleSubmitStatus(
        status: next,
        onSuccess: () {
          ref.read(registerBookFormProvider(widget.data).notifier).clearAll();
          _actionController.clear();
          ref.read(selectableElementForSearchProvider.notifier).state = RegisterBook;
          ref.read(tabMenuProvider.notifier).goTo(NawiMenuTabs.search);
        },
      )
    );

    ref.listen(initialRegisterBookFormDataProvider.select((e) => e?.action), (_, next) {
      _actionController.text = next ?? '';
    });

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
      
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.data == null ? NawiColorUtils.primaryColor : Colors.blue.shade400
                  ),
                  onPressed: formNotifier.isValid ? () async => await formNotifier.submit(idToEdit: widget.data?.id) : null,
                  child: Text(widget.data == null ? "Agregar" : "Editar"),
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

          Wrap(
            spacing: 10,
            runSpacing: 10,
                children: (registerBookFormState.mentions.toSet()).map((student) => 
                  Chip(
                    label: Text(student.name, style: const TextStyle(fontSize: 10)),
                    backgroundColor: NawiColorUtils.studentColorByAge(student.age.value).withAlpha(80),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold)
                  )
                ).toList(),
          ),

          const SizedBox(height: 20),
      
          TextFormField(
            controller: _actionController,
            maxLines: 6,
            readOnly: true,
            onTap: () async {
              final actionMentionsRecord = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AnotherCreateAction(
                  action: registerBookFormState.action,
                  mentions: registerBookFormState.mentions,
                ))
                // MaterialPageRoute(builder: (context) => MentionStudentField(
                //   action: registerBookFormState.action,
                //   mentions: registerBookFormState.mentions,
                // ))
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
      
          const SizedBox(height: 60)
        ],
      ),
    );
  }
}