import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mention_tag_text_field/mention_tag_text_field.dart';
import 'package:nawiapp/data/mappers/student_mapper.dart';
import 'package:nawiapp/domain/classes/filter/student_filter.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/presentation/features/create/widgets/button_speech_field.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class AnotherMentionStudentField extends StatefulWidget {

  final String? action;
  final Iterable<StudentSummary>? mentions;

  const AnotherMentionStudentField({ super.key, this.action, this.mentions });

  @override
  State<AnotherMentionStudentField> createState() => _AnotherMentionStudentFieldState();
}

class _AnotherMentionStudentFieldState extends State<AnotherMentionStudentField> {

  String? mentionValue;
  final _speechController = TextEditingController();
  final _taggerController = MentionTagTextEditingController();

  final _studentService = GetIt.I<StudentServiceBase>();

  List<StudentSummary> _searchResultsContainer = [];

  Future<List<StudentSummary>> requestData(String? query) async {
    query = query?.trim().toLowerCase();
    final searchResult = await _studentService.getAllPaginated(pageSize: 5, currentPage: 0, params: StudentFilter(nameLike: query));
    late final List<StudentSummary> searchedStudents;
    searchResult.onValue(
      withPopup: false,
      onSuccessfully: (data, _) => searchedStudents = data.data.toList(),
      onError: (_, __) => searchedStudents = [],
    );
    return searchedStudents;
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
    _speechController.addListener(() => _taggerController.setText = _speechController.text);
    _taggerController.setText = widget.action ?? '';
  }

  @override
  void dispose() {
    _speechController.dispose();
    _taggerController.dispose();
    super.dispose();
  }

  void onMention(String? query) async {
    setState(() { mentionValue = query; _searchResultsContainer.clear(); });
    if(query == null) return;

    //* Request search by query
    final requested = await requestData(query.substring(1));
    setState(() => _searchResultsContainer = requested);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Campo de acción"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ButtonSpeechField(controller: _speechController),

              const SizedBox(height: 15),

              Focus(
                onFocusChange: (value) {
                  if(!value) _searchResultsContainer.clear();
                },
                child: MentionTagTextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  controller: _taggerController,
                  initialMentions: (widget.mentions ?? [])
                    .map((e) => ("@${e.mentionLabel}", e, null))
                    .toList(),
                  onMention: onMention,
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
                  itemCount: _searchResultsContainer.length,
                  itemBuilder: (context, index) {
                    final item = _searchResultsContainer[index];
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
        )
      ),
    
      persistentFooterButtons: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context, (
              _taggerController.getText,
              _taggerController.mentions.cast<StudentSummary>()
            )),
            child: const Text("Aceptar"),
          ),
        )
      ],
    );
  }
}