import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nawiapp/domain/classes/credential_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class SecureCredentialManager {
  final _storage = FlutterSecureStorage();
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
      _storage.write(key: _authCode, value: _hashCode(data.authCode)),
      _storage.write(key: _mode, value: data.mode.index.toString()),
      prefs.setBool(_tutorialSeen, true)
    ]);
  }

  Future<bool> validCredential(CredentialData data) async {
    final storedHashedPin = await _storage.read(key: _authCode);
    if (storedHashedPin == null) return false;

    final inputHashed = _hashCode(data.authCode);
    return storedHashedPin == inputHashed;
  }

  // TODO: Borrar cuando esto funcione bien
  @Deprecated('Cuando todo funcione correctamente, borrar')
  Future<void> deleteAll() async {
    await _storage.deleteAll();
    await prefs.remove(_tutorialSeen);
  }
}