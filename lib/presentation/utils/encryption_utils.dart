import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:encrypt/encrypt.dart';
import 'package:smartuaq/core/common/log.dart';

const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';

class EncryptionUtils {
  static late encrypt.IV iv;
  late String aesEncryptionKey;
  static late encrypt.Encrypter encrypter;
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(_rnd.nextInt(chars.length))));
  EncryptionUtils() {
    aesEncryptionKey = 'bewicFaJgDnlURlX'; //getRandomString(16);
    printLog(aesEncryptionKey);
    iv = encrypt.IV.fromUtf8(aesEncryptionKey);
    encrypter = Encrypter(
        AES(Key.fromUtf8(aesEncryptionKey), mode: AESMode.ctr, padding: null));
  }

  String encryptAES(String text) => encrypter.encrypt(text, iv: iv).base64;

  String decryptAES(String encrypted) {
    final Uint8List encryptedBytesWithSalt = base64.decode(encrypted);
    final Uint8List encryptedBytes = encryptedBytesWithSalt.sublist(
      0,
      encryptedBytesWithSalt.length,
    );
    final String decrypted =
        encrypter.decrypt64(base64.encode(encryptedBytes), iv: iv);
    return decrypted;
  }
}
