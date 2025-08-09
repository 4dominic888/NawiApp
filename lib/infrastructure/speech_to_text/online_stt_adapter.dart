import 'package:nawiapp/core/ports/speech_to_text/speech_to_text_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

interface class OnlineSTTAdapter implements SpeechToTextService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  @override
  Future<bool> init({Function(String status)? onStatus}) {
    return _speech.initialize(onStatus: onStatus);
  }

  @override
  Future<void> start({required Function(String recognized) onResult}) {
    return _speech.listen(
      listenOptions: stt.SpeechListenOptions(
        cancelOnError: false,
        partialResults: false,
        listenMode: stt.ListenMode.dictation,
      ),
      onResult: (val) {
        if (val.finalResult) {
          onResult(val.recognizedWords.trim());
        }
      },
    );
  }

  @override
  Future<void> stop() => _speech.stop();
}