import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mention_tag_text_field/mention_tag_text_field.dart';
import 'package:nawiapp/data/mappers/register_book_mapper.dart';
import 'package:nawiapp/data/mappers/student_mapper.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/presentation/features/create/widgets/button_speech_field.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class MentionStudentFormField extends StatefulWidget {
  const MentionStudentFormField({super.key, this.registerBook, required this.formFieldKey, required this.typeRegisterFormFieldKey});

  final RegisterBook? registerBook;
  final Key formFieldKey;
  final GlobalKey<FormFieldState<RegisterBookType>> typeRegisterFormFieldKey;

  @override
  State<MentionStudentFormField> createState() => _MentionStudentFormFieldState();
}

class _MentionStudentFormFieldState extends State<MentionStudentFormField> {

  late final RegisterBook _value;

  /// Controlador que maneja especificamente el texto resultante del widget de voz a texto
  final _speechController = TextEditingController();

  final _taggerController = MentionTagTextEditingController();

  final _studentService = GetIt.I<StudentServiceBase>();

  //* Some variables
  String? mentionValue;
  List<StudentSummary> searchResults = [];

  Future<List<StudentSummary>> requestData(String? query) async {
    final result = await _studentService.getAllPaginated(pageSize: 5, currentPage: 0, params: StudentFilter(nameLike: query));
    late final List<StudentSummary> output;
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

  @override
  void initState() {
    super.initState();
    _value = widget.registerBook ?? RegisterBookMapper.empty();
    _speechController.addListener(() => _taggerController.setText = _speechController.text);
    _taggerController.setText = _value.action;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<RegisterBook>(
      initialValue: _value,
      key: widget.formFieldKey,
      builder: (formState) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ButtonSpeechField(controller: _speechController, onPlay: cleanController),

                const SizedBox(height: 15),

                DropdownButtonFormField<RegisterBookType>(
                  key: widget.typeRegisterFormFieldKey,
                  value: _value.type,
                  decoration: const InputDecoration(
                    labelText: "Selecciona el tipo",
                    prefixIcon: Icon(Icons.type_specimen),
                    border: OutlineInputBorder()
                  ),
                  items: const [
                    DropdownMenuItem(value: RegisterBookType.register, child: Text("Registro")),
                    DropdownMenuItem(value: RegisterBookType.incident, child: Text("Incidente")),
                    DropdownMenuItem(value: RegisterBookType.anecdotal, child: Text("Anecdótico")),
                  ],
                  onChanged: (value) { setState(() {}); }
                ),

                const SizedBox(height: 30),

                Focus(
                  onFocusChange: (value) {
                    if(!value) searchResults.clear();
                  },
                  child: MentionTagTextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1, maxLines: 5, controller: _taggerController,
                    initialMentions: _value.mentions.map((e) => ("@${e.mentionLabel}", e, null)).toList(),
                    onTapOutside: (event) {
                      formState.didChange(_value.copyWith(
                        action: _taggerController.getText,
                        mentions: _taggerController.mentions.cast<StudentSummary>()
                      ));
                    },
                    onMention: (value) async {
                      //* Limpiando el widget de elementos antes de colocar los datos
                      formState.didChange(_value.copyWith(
                        action: _taggerController.getText,
                        mentions: _taggerController.mentions.cast<StudentSummary>()
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
                          backgroundColor: NawiColorUtils.studentColorByAge(item.age.value, withOpacity: true),
                          child: Icon(Icons.person, color: NawiColorUtils.studentColorByAge(item.age.value)),
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