abstract class SpeechToTextService {
  Future<bool> init({Function(String status)? onStatus});
  Future<void> start({ required Function(String recognized) onResult });
  Future<void> stop();
}