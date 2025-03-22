import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mention_tag_text_field/mention_tag_text_field.dart';
import 'package:nawiapp/domain/classes/student_filter.dart';
import 'package:nawiapp/domain/models/register_book.dart';
import 'package:nawiapp/domain/models/student.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/presentation/registration_book/add_registers_book/widgets/button_speech_field.dart';
import 'package:nawiapp/infrastructure/nawi_utils.dart';

class MentionStudentFormField extends StatefulWidget {
  const MentionStudentFormField({super.key, required this.formFieldKey});

  final Key formFieldKey;

  @override
  State<MentionStudentFormField> createState() => _MentionStudentFormFieldState();
}

class _MentionStudentFormFieldState extends State<MentionStudentFormField> {

  final RegisterBook _value = RegisterBook.empty();

  /// Controlador que maneja especificamente el texto resultante del widget de voz a texto
  final _speechController = TextEditingController();

  final _taggerController = MentionTagTextEditingController();

  Color Function(bool hasError) get errorColor => (bool hasError) => hasError ? Colors.red : Colors.black;
  final _studentService = GetIt.I<StudentServiceBase>();

  Future<List<StudentDAO>> requestData(String? query) async {
    final result = await _studentService.getAllPaginated(pageSize: 5, currentPage: 0, params: StudentFilter(nameLike: query));
    late final List<StudentDAO> output;
    result.onValue(
      withPopup: false,
      onSuccessfully: (data, message) => output = data.data.toList(),
      onError: (error, message) => output = [],
    );
    return output;
  }

  void cleanController() {
    _taggerController.setText = "";
    final length = _taggerController.mentions.length;
    if(length == 0) return;
    for (int i = length - 1; i >= 0; i--) {
      _taggerController.remove(index: i);
    }
  }

  //* Some variables
  String? mentionValue;
  List<StudentDAO> searchResults = [];

  @override
  void initState() {
    super.initState();
    _speechController.addListener(() => _taggerController.setText = _speechController.text);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<RegisterBook>(
      key: widget.formFieldKey,
      builder: (formState) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ButtonSpeechField(controller: _speechController, onPlay: cleanController,),
                const SizedBox(height: 15),

                Focus(
                  onFocusChange: (value) {
                    if(!value) searchResults.clear();
                  },
                  child: MentionTagTextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1, maxLines: 5, controller: _taggerController,
                    onTapOutside: (event) {
                      formState.didChange(_value.copyWith(
                        action: _taggerController.getText,
                        mentions: _taggerController.mentions.cast<StudentDAO>()
                      ));
                    },
                    onMention: (value) async {
                      //* Limpiando el widget de elementos antes de colocar los datos
                      formState.didChange(_value.copyWith(
                        action: _taggerController.getText,
                        mentions: _taggerController.mentions.cast<StudentDAO>()
                      ));

                      setState(() { mentionValue = value; searchResults.clear(); });
                      if(value == null) return;

                      //* Request
                      final requested = await requestData(value.substring(1));
                      setState(() => searchResults = requested);
                    },
                    mentionTagDecoration: MentionTagDecoration(
                      mentionStart: ['@'],
                      allowDecrement: false,
                      allowEmbedding: false,
                      showMentionStartSymbol: true,
                      maxWords: null
                    ),
                    decoration: InputDecoration(
                      errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attractions),
                      hintText: "Acción realizada, coloca @ para indicar a los estudiantes...",
                      suffix: IconButton(icon: const Icon(Icons.clear), onPressed: cleanController)
                    ),
                    validator: (value) {
                      value = value?.trim();
                      if(value == null || value.isEmpty) return "Campo requerido";
                      if(value.length <= 2) return "Campo demasiado corto";
                      return null;
                    },
                  ),
                ),
        
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final item = searchResults[index];
                      return ListTile(
                        onTap: () {
                          _taggerController.addMention(label: item.mentionLabel, data: item);
                          setState(() => mentionValue = null);
                        },
                        leading: CircleAvatar(
                          backgroundColor: NawiColor.iconColorMap(item.age.value, withOpacity: true),
                          child: Icon(Icons.person, color: NawiColor.iconColorMap(item.age.value)),
                        ),
                        subtitle: Text(item.age.name),
                        title: Text(item.mentionLabel)
                      );
                    },
                  )
                )
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  void dispose() {
    _speechController.dispose();
    _taggerController.dispose();
    super.dispose();
  }
}