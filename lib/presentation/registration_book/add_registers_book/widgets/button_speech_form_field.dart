import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:manual_speech_to_text/manual_speech_to_text.dart';

class ButtonSpeechFormField extends StatefulWidget {
  const ButtonSpeechFormField({super.key, required this.actionKey});

  final GlobalKey<FormFieldState<String>> actionKey;

  @override
  State<ButtonSpeechFormField> createState() => _ButtonSpeechFormFieldState();
}

class _ButtonSpeechFormFieldState extends State<ButtonSpeechFormField> {

  late ManualSttController _sttController;
  bool _isListening = false;
  double _soundLevel = 0.0;
  late ManualSttState _currentState;

  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentState = ManualSttState.stopped;
    _sttController = ManualSttController(context)..listen(
      onListeningStateChanged: (state) => setState(() => _currentState = state),
      onListeningTextChanged: (str) => setState(() => _textController.text = str),
      onSoundLevelChanged: (sound) => setState(() => _soundLevel = sound),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          key: widget.actionKey,
          controller: _textController,
          decoration: const InputDecoration(
            labelText: "Acción realizada",
            prefixIcon: Icon(Icons.attractions),
            border: OutlineInputBorder()
          ),
          validator: (value) {
            if(value == null || value.trim().isEmpty) return "No se ha proporcionado una acción";
            value = value.trim();
            if(value.length <= 2) return "El nombre es demasiado corto";
            return null;
          },
        ),

        const SizedBox(height: 30),

        GestureDetector(
          onTap: () {
            setState(() {
              _isListening = !_isListening;
        
              if(_isListening){
                if(_currentState == ManualSttState.stopped) _sttController.startStt();
                if(_currentState == ManualSttState.paused) _sttController.resumeStt();
              }
              else{
                _sttController.pauseStt();
                _soundLevel = 0;
              }
            });
          },
        
          child: Center(
            child: AvatarGlow(
              animate: _isListening,
              duration: const Duration(milliseconds: 2000),
              glowRadiusFactor: 0.6,
              glowColor: Colors.greenAccent,
              repeat: true,
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: MediaQuery.of(context).size.width / 10,
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width / 11),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        LinearProgressIndicator(value: _soundLevel),

      ],
    );
  }

  @override
  void dispose() {
    _sttController.dispose();
    _textController.dispose();
    super.dispose();
  }
}