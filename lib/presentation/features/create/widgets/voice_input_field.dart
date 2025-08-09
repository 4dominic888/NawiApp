import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/core/ports/speech_to_text/mic_mode.dart';
import 'package:nawiapp/presentation/features/create/providers/speech_to_text_provider.dart';

class VoiceInputField extends ConsumerWidget {
  final TextEditingController textController;
  final double radius;

  const VoiceInputField({
    super.key,
    required this.textController,
    required this.radius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(speechToTextServiceNotifierProvider(textController));
    final notifier = ref.read(speechToTextServiceNotifierProvider(textController).notifier);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        PopupMenuButton<MicMode>(
          onSelected: notifier.changeMicMode,
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
          onTapDown: state.micMode == MicMode.holdToSpeak ? (_) => notifier.startListening() : null,
          onTapUp: state.micMode == MicMode.holdToSpeak ? (_) => notifier.stopListening() : null, 
          onTapCancel: state.micMode == MicMode.holdToSpeak ? notifier.stopListening : null,
          onTap: state.micMode == MicMode.toggleToSpeak ? notifier.toggleListening : null,
          child: AvatarGlow(
            animate: state.isListening,
            duration: const Duration(milliseconds: 2000),
            glowRadiusFactor: 0.6,
            repeat: true,
            glowColor: Colors.black.withAlpha(100),
            child: CircleAvatar(
              radius: radius * 0.6,
              backgroundColor: state.isListening ? Colors.red : Colors.blue,
              child: Icon(
                Icons.mic,
                color: Colors.white,
                size: radius * 0.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          state.micMode == MicMode.holdToSpeak
              ? 'Modo: Mantener para hablar'
              : state.isListening
                  ? 'Grabando... toca para detener'
                  : 'Modo: Tocar para hablar',
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }

}
