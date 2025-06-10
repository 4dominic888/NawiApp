import 'dart:convert';

import 'package:nawiapp/domain/classes/credential_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class SecureCredentialManager {
  final SharedPreferences prefs;

  SecureCredentialManager._({required this.prefs});
  static Future<SecureCredentialManager> init() async => SecureCredentialManager._(prefs: await SharedPreferences.getInstance());

  static const String _authCode = 'authCode';
  static const String _mode = 'mode';
  static const String _tutorialSeen = 'tutorialSeen';

  bool get tutorialSeen => prefs.getBool(_tutorialSeen) ?? false;

  String _hashCode(String authCode) {
    final bytes = utf8.encode(authCode);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> setCredential(CredentialData data) async {
    await Future.wait([
      prefs.setString(_authCode, _hashCode(data.authCode)),
      prefs.setInt(_mode, data.mode.index),
      prefs.setBool(_tutorialSeen, true)
    ]);
  }

  bool validCredential(CredentialData data) {
    final storedHashedPin = prefs.getString(_authCode);
    if (storedHashedPin == null) return false;

    final inputHashed = _hashCode(data.authCode);
    return storedHashedPin == inputHashed;
  }

  CredentialDataType? getMode() {
    final int? indexStr = prefs.getInt(_mode);
    if(indexStr == null) return null;
    return CredentialDataType.values[indexStr];
  }

  // TODO: Borrar cuando esto funcione bien
  @Deprecated('Cuando todo funcione correctamente, borrar')
  Future<void> deleteAll() async => await prefs.clear();
}