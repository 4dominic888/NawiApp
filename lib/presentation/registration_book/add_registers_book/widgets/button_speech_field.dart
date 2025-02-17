import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:manual_speech_to_text/manual_speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class ButtonSpeechField extends StatefulWidget {
  const ButtonSpeechField({super.key, required this.controller, this.onPlay});

  final TextEditingController controller;
  final void Function()? onPlay;

  @override
  State<ButtonSpeechField> createState() => _ButtonSpeechFieldState();
}

class _ButtonSpeechFieldState extends State<ButtonSpeechField> {

  late ManualSttController _sttController;
  bool _isListening = false;
  late ManualSttState _currentState;

  @override
  void initState() {
    super.initState();
    _currentState = ManualSttState.stopped;
    _sttController = ManualSttController(context)..listen(
      onListeningTextChanged: (str) => setState(() => widget.controller.text = str),
      onListeningStateChanged: (state) => setState(() => _currentState = state)
    )
    ..permanentDenialDialogTitle = "Permisos del micrófono requerido"
    ..permanentDenialDialogContent = "La función de voz a texto necesita permisos del micrófono para funcionar"
    ..handlePermanentlyDeniedPermission(() async {
      await showDialog(context: context, builder: (context) => AlertDialog(
        
        title: const Text("Los permisos del micrófono estan desactivados permanentemente"),
        content: const Text(
          "Es necesario activarlo en las configuraciones del dispositivo, para acceder a la funcionalidad de voz a texto.\n\n¿Le gustaría activarlo ahora?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancelar")),
          TextButton(onPressed: () { Navigator.of(context).pop(); openAppSettings(); }, child: const Text("Aceptar"))
        ],
      ));
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        GestureDetector(
          onTap: () {
            setState(() {
              _isListening = !_isListening;
        
              if(_isListening) {
                widget.onPlay?.call();
                if(_currentState == ManualSttState.stopped) _sttController.startStt();
                if(_currentState == ManualSttState.paused) _sttController.resumeStt();
              }
              else {
                _sttController.pauseStt();
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
      ],
    );
  }

  @override
  void dispose() {
    _sttController.dispose();
    super.dispose();
  }
}