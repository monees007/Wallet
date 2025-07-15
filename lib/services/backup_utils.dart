// lib/services/backup_utils.dart

import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

// This is a helper class to pass both arguments to the compute function.
class EncryptionPayload {
  final String jsonData;
  final String password;
  EncryptionPayload(this.jsonData, this.password);
}

// This function will run in the background to encrypt data.
Uint8List encryptDataForBackup(EncryptionPayload payload) {
  final key = encrypt.Key.fromUtf8(payload.password.padRight(32).substring(0, 32));
  final iv = encrypt.IV.fromSecureRandom(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final encrypted = encrypter.encrypt(payload.jsonData, iv: iv);
  return Uint8List.fromList(iv.bytes + encrypted.bytes);
}

// This is a helper class for decryption payload.
class DecryptionPayload {
  final Uint8List encryptedData;
  final String password;
  DecryptionPayload(this.encryptedData, this.password);
}

// This function will run in the background to decrypt data.
String decryptDataForRestore(DecryptionPayload payload) {
  final key = encrypt.Key.fromUtf8(payload.password.padRight(32).substring(0, 32));
  final iv = encrypt.IV(payload.encryptedData.sublist(0, 16));
  final encryptedBytes = payload.encryptedData.sublist(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  return encrypter.decrypt(encrypt.Encrypted(encryptedBytes), iv: iv);
}