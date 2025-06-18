import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nawiapp/domain/services/backup_crypto_strategy.dart';

class BackupCryptoAes256 implements BackupCryptoStrategy {

  final String _encryptionKey = dotenv.env['ENCRYPTION_KEY']!;
  final String _iv = dotenv.env['ENCRYPTION_IV']!;
  late IV ivParam;

  Encrypter _setEncrypter() {
    final key = Key.fromUtf8(_encryptionKey);
    ivParam = IV.fromUtf8(_iv);
    return Encrypter(AES(key, mode: AESMode.cbc));
  }

  @override
  Uint8List encrypt(Uint8List data) {
    final encrypter = _setEncrypter();
    final encrypted = encrypter.encryptBytes(data, iv: ivParam);
    return Uint8List.fromList(encrypted.bytes);
  }

  @override
  Uint8List decrypt(Uint8List encryptedData) {
    final encrypter = _setEncrypter();
    final decrypted = encrypter.decryptBytes(
      Encrypted(encryptedData),
      iv: ivParam,
    );
    return Uint8List.fromList(decrypted);
  }
}