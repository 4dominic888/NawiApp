import 'package:nawiapp/core/ports/speech_to_text/mic_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NawiOptions {
  final SharedPreferences prefs;

  NawiOptions._({required this.prefs});
  static Future<NawiOptions> init() async => NawiOptions._(prefs: await SharedPreferences.getInstance());

  static const String _microphoneMode = 'microphoneMode';
  Future<void> setMicrophoneMode(MicMode mode) async => await prefs.setString(_microphoneMode, mode.value);
  // Future<void> setToggleToSpeakMicrophoneMode(bool mode) async => await prefs.setString(_microphoneMode, MicMode.toggleToSpeak.value);
  // Future<void> setHoldToSpeakMicrophoneMode(bool mode) async => await prefs.setString(_microphoneMode, MicMode.holdToSpeak.value);
  String get microphoneMode {
    final String? mode = prefs.getString(_microphoneMode);
    if(mode == null) return MicMode.holdToSpeak.value;
    return mode;
  }
}