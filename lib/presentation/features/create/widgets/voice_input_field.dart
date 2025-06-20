import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/infrastructure/nawi_options.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceInputField extends StatefulWidget {
  final TextEditingController textController;
  final double radius;

  const VoiceInputField({
    super.key,
    required this.textController,
    required this.radius,
  });

  @override
  State<VoiceInputField> createState() => _VoiceInputFieldState();
}

class _VoiceInputFieldState extends State<VoiceInputField> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _shouldKeepListening = false;
  MicMode _micMode = MicMode.values.firstWhere((e) => e.value == GetIt.I<NawiOptions>().microphoneMode);

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _startListening() async {
    final available = await _speech.initialize(
      onStatus: (value) {
        if (value == 'done' && _shouldKeepListening) {
          _restartListening();
        }
      },
    );

    if (available) {
      _shouldKeepListening = true;
      _restartListening();
    }
  }

  void _restartListening() {
    if (!_shouldKeepListening) return;

    setState(() => _isListening = true);

    _speech.listen(
      listenOptions: stt.SpeechListenOptions(
        cancelOnError: false,
        partialResults: false,
        listenMode: stt.ListenMode.dictation,
      ),
      onResult: (val) {
        if (val.finalResult) {
          setState(() {
            final String recognized = val.recognizedWords.trim();
            final controller = widget.textController;
            final needsSpace = controller.text.isNotEmpty && !controller.text.endsWith(' ');
            final updatedText = needsSpace
                ? '${controller.text} $recognized'
                : '${controller.text}$recognized';

            controller.text = updatedText;
            controller.selection = TextSelection.collapsed(offset: updatedText.length);
          });
        }
      },
    );
  }

  void _stopListening() {
    _shouldKeepListening = false;
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        PopupMenuButton<MicMode>(
          onSelected: (mode) async {
            GetIt.I<NawiOptions>().setMicrophoneMode(mode);
            setState(() => _micMode = mode);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: MicMode.holdToSpeak,
              child: Text("Mantener para hablar"),
            ),
            const PopupMenuItem(
              value: MicMode.toggleToSpeak,
              child: Text("Tocar para hablar"),
            ),
          ],
          child: const Align(
            alignment: Alignment.centerRight,
            child: Column(
              children: [
                Icon(Icons.settings),
                Text("Modo", style: TextStyle(fontSize: 12, color: Colors.black),),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTapDown: _micMode == MicMode.holdToSpeak ? (_) => _startListening() : null,
          onTapUp: _micMode == MicMode.holdToSpeak ? (_) => _stopListening() : null,
          onTapCancel: _micMode == MicMode.holdToSpeak ? _stopListening : null,
          onTap: _micMode == MicMode.toggleToSpeak ? _toggleListening : null,
          child: AvatarGlow(
            animate: _isListening,
            duration: const Duration(milliseconds: 2000),
            glowRadiusFactor: 0.6,
            repeat: true,
            glowColor: Colors.black.withAlpha(100),
            child: CircleAvatar(
              radius: widget.radius * 0.6,
              backgroundColor: _isListening ? Colors.red : Colors.blue,
              child: Icon(
                Icons.mic,
                color: Colors.white,
                size: widget.radius * 0.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          _micMode == MicMode.holdToSpeak
              ? 'Modo: Mantener para hablar'
              : _isListening
                  ? 'Grabando... toca para detener'
                  : 'Modo: Tocar para hablar',
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }
}
