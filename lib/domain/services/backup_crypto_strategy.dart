import 'dart:typed_data';

abstract class BackupCryptoStrategy {
  Uint8List encrypt(Uint8List data);
  Uint8List decrypt(Uint8List encryptedData);
}