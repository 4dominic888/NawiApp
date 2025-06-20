import 'package:shared_preferences/shared_preferences.dart';

enum MicMode {
  holdToSpeak("holdToSpeak"),
  toggleToSpeak("toggleToSpeak");

  final String value;
  const MicMode(this.value);
}

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