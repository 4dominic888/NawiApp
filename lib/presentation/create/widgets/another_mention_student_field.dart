import 'package:flutter/material.dart';
import 'package:mention_tag_text_field/mention_tag_text_field.dart';
import 'package:nawiapp/data/mappers/student_mapper.dart';
import 'package:nawiapp/domain/models/student/entity/student_age.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/presentation/create/widgets/button_speech_field.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class AnotherMentionStudentField extends StatefulWidget {
  const AnotherMentionStudentField({ super.key });

  @override
  State<AnotherMentionStudentField> createState() => _AnotherMentionStudentFieldState();
}

class _AnotherMentionStudentFieldState extends State<AnotherMentionStudentField> {

  String? mentionValue;
  final _speechController = TextEditingController();
  final _taggerController = MentionTagTextEditingController();

  final _rawData = [
    StudentSummary(id: '*', name: "Jose Pablo", age: StudentAge.threeYears),
    StudentSummary(id: '*', name: "Maria Fernanda", age: StudentAge.fiveYears),
    StudentSummary(id: '*', name: "Joel", age: StudentAge.fourYears),
    StudentSummary(id: '*', name: "Mario", age: StudentAge.fourYears),
    StudentSummary(id: '*', name: "Raul", age: StudentAge.fiveYears),
    StudentSummary(id: '*', name: "Anita", age: StudentAge.threeYears),
    StudentSummary(id: '*', name: "Julio Jose", age: StudentAge.fiveYears),
    StudentSummary(id: '*', name: "Mariano", age: StudentAge.fourYears),
    StudentSummary(id: '*', name: "Noel", age: StudentAge.threeYears),
    StudentSummary(id: '*', name: "Pedro Manuel", age: StudentAge.threeYears),
  ];

  List<StudentSummary> searchResults = [];

  List<StudentSummary> requestData(String? query) {
    query = query?.trim().toLowerCase();
    return _rawData.where((e) => e.mentionLabel.contains(query ?? '')).take(5).toList();
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
                  if(!value) searchResults.clear();
                },
                child: MentionTagTextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  controller: _taggerController,
                  // initialMentions: [],
                  onTapOutside: (event) {
                    
                  },
                  onMention: (value) {
                    setState(() { mentionValue = value; searchResults.clear(); });
                    if(value == null) return;

                    //* Request
                    final requested = requestData(value.substring(1));
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
        )
      ),
    
      persistentFooterButtons: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("Aceptar"),
            
          ),
        )
      ],

    );
  }

  @override
  void dispose() {
    _speechController.dispose();
    _taggerController.dispose();
    super.dispose();
  }
}