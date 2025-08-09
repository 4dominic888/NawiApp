import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/core/ports/speech_to_text/mic_mode.dart';
import 'package:nawiapp/core/ports/speech_to_text/speech_to_text_service.dart';
import 'package:nawiapp/infrastructure/nawi_options.dart';
import 'package:nawiapp/infrastructure/speech_to_text/online_stt_adapter.dart';

class VoiceState {
  final bool isListening;
  final MicMode micMode;

  VoiceState({this.isListening = false, required this.micMode});

  VoiceState copyWith({bool? isListening, MicMode? micMode}) {
    return VoiceState(
      isListening: isListening ?? this.isListening,
      micMode: micMode ?? this.micMode,
    );
  }
}

class VoiceNotifier extends StateNotifier<VoiceState> {
  
  final SpeechToTextService _service;
  bool _shouldKeepListening = false;
  final Function(String) _onRecognized;

  VoiceNotifier(this._service, this._onRecognized)
      : super(
        VoiceState(
          micMode: MicMode.values.firstWhere((e) => e.value == GetIt.I<NawiOptions>().microphoneMode)
        )
      );

  Future<void> startListening() async {
    final available = await _service.init(
      onStatus: (status) {
        if (status == 'done' && _shouldKeepListening) restartListening();
      },
    );
    if (available) {
      _shouldKeepListening = true;
      restartListening();
    }
  }

  Future<void> restartListening() async {
    if (!_shouldKeepListening) return;
    state = state.copyWith(isListening: true);
    await _service.start(onResult: (recognized) {
      _onRecognized(recognized);
    });
  }

  Future<void> stopListening() async {
    _shouldKeepListening = false;
    await _service.stop();
    state = state.copyWith(isListening: false);
  }

  void toggleListening() {
    if (state.isListening) {
      stopListening();
    } else {
      startListening();
    }
  }

  void changeMicMode(MicMode mode) {
    GetIt.I<NawiOptions>().setMicrophoneMode(mode);
    state = state.copyWith(micMode: mode);
  }
}

final speechToTextServiceNotifierProvider =
    StateNotifierProvider.family<VoiceNotifier, VoiceState, TextEditingController>((ref, textController) {
  return VoiceNotifier(
    OnlineSTTAdapter(),
    (recognized) {
      final needSpace = textController.text.isNotEmpty && !textController.text.endsWith(' ');
      final updatedText = needSpace ? '${textController.text} $recognized' : '${textController.text}$recognized';
      textController.text = updatedText;
      textController.selection = TextSelection.collapsed(offset: updatedText.length);
    },
  );
});