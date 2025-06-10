import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/presentation/features/create/widgets/voice_input_field.dart';
import 'package:nawiapp/presentation/features/search/widgets/multi_select_student_field.dart';

class AnotherCreateAction extends StatefulWidget {
  
  final String? action;
  final Iterable<StudentSummary>? mentions;
  
  const AnotherCreateAction({ super.key, this.action, this.mentions });

  @override
  State<AnotherCreateAction> createState() => _AnotherCreateActionState();
}

class _AnotherCreateActionState extends State<AnotherCreateAction> {

  List<StudentSummary> _selectedMentions = [];
  final _actionController = TextEditingController();
  double microphoneHeight = 0;

  @override
  void initState() {
    super.initState();
    _selectedMentions.addAll(widget.mentions ?? []);
    _actionController.text = widget.action ?? '';
  }

  @override
  Widget build(BuildContext context) {
    microphoneHeight = MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Campo de acción"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 5,
                  children: [
                    MultiSelectStudentField(
                      initialSelectedStudents: _selectedMentions,
                      onChanged: (data) => _selectedMentions = data,
                    ),
                    
                    Divider(),
                    
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      controller: _actionController,
                      decoration: InputDecoration(
                        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attractions),
                        hintText: "Acción a registrar",
                        suffix: IconButton(icon: const Icon(Icons.clear), onPressed: _actionController.clear)
                      ),
                      validator: (value) {
                        value = value?.trim();
                        if(value == null || value.isEmpty) return "Campo requerido";
                        if(value.length <= 4) return "Campo demasiado corto";
                        return null;
                      },
                    ),
                    
                    Divider(),
                    
                    Flexible(
                      child: Consumer(
                        builder: (_, ref, __) {
                          return ElevatedButton(
                            onPressed: () {
                              if(_selectedMentions.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Debe seleccionar al menos un estudiante")));
                                return;
                              }
                                                
                              Navigator.pop(context, (_actionController.text.trim(), _selectedMentions) );
                            },
                            child: const Text("Aceptar"),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),

              microphoneHeight >= 415 ? Expanded(
                child: LayoutBuilder(
                  builder: (_, boxConstraints) {
                    final radius = (boxConstraints.maxWidth + boxConstraints.maxHeight) / 5;
                    return Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: SizedBox.expand(
                        child: VoiceInputField(
                          textController: _actionController,
                          radius: radius,
                        ),
                      ),
                    );
                  }
                ),
              ) : const SizedBox.shrink(),
              
            ],
          ),
        )
      ),
    );
  }
}