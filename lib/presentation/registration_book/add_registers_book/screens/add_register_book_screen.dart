import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/result.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';
import 'package:nawiapp/presentation/registration_book/add_registers_book/widgets/mention_student_form_field.dart';
import 'package:nawiapp/presentation/widgets/loading_process_button.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class AddRegisterBookScreen extends StatefulWidget {
  const AddRegisterBookScreen({super.key, this.idToEdit});

  final String? idToEdit;

  @override
  State<AddRegisterBookScreen> createState() => _AddRegisterBookScreenState();
}

class _AddRegisterBookScreenState extends State<AddRegisterBookScreen> {

  final _registerBookService = GetIt.I<RegisterBookServiceBase>();

  final _formKey = GlobalKey<FormState>();
  final _actionKey = GlobalKey<FormFieldState<RegisterBook>>();
  final _typeRegisterKey = GlobalKey<FormFieldState<RegisterBookType>>();
  final _btnController = RoundedLoadingButtonController();

  bool _isUpdatable = false;
  RegisterBook? _getData;
  late final Future<Result<RegisterBook>> _future;

  @override
  void initState() {
    super.initState();
    _future = _registerBookService.getOne(widget.idToEdit ?? '0');
  }

  Future<void> onSubmit() async {
    if(_formKey.currentState!.validate()) {

      final Result<Object> result;
      final registerBook = RegisterBook(
        action: _actionKey.currentState!.value!.action,
        mentions: _actionKey.currentState!.value!.mentions,
        type: _typeRegisterKey.currentState!.value!
      );

      if(_isUpdatable) { //* Editar
        result = await _registerBookService.updateOne(registerBook.copyWith(id: widget.idToEdit!));
      }
      else { //* Crear
        result = await _registerBookService.addOne(registerBook);
      }

      result.onValue(
        onError: (_, message) => _btnController.error(),
        onSuccessfully: (_, message) => _btnController.success()
      );
      
      return;
    }
    _btnController.error();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<RegisterBook>>(
      future: _future,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

        _getData = snapshot.data?.getValue;
        _isUpdatable = _getData != null;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            persistentFooterButtons: [
              LoadingProcessButton(
                controller: _btnController,
                width: MediaQuery.of(context).size.width,
                label: Text("${_isUpdatable ? "Editar" : "Crear"} registro"),
                color: _isUpdatable ? Colors.lightBlueAccent.shade100 : Theme.of(context).colorScheme.inversePrimary,
                proccess: onSubmit,
              ),
            ],
            appBar: AppBar(
              leading: const BackButton(),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text("${widget.idToEdit != null ? "Editar" : "Crear"} registro de estudiante"),
            ),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16,32,16,16),
                child: MentionStudentFormField(
                  formFieldKey: _actionKey,
                  registerBook: _getData,
                  typeRegisterFormFieldKey: _typeRegisterKey
                )
              )
            )
          )
        );
      }
    );
  }
}