import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/gcm.dart';

class AESUtil {
  static String encryptWithAESGCM(
    Map<String, String> data,
    Uint8List keyBytes,
  ) {
    Uint8List generateRandomIV() {
      final rand = Random.secure();
      return Uint8List.fromList(
        List.generate(12, (_) => rand.nextInt(256)),
      ); // 96-bit IV
    }

    final plainText = utf8.encode(jsonEncode(data));
    final nonce = generateRandomIV();

    final cipher = GCMBlockCipher(AESEngine())..init(
      true,
      AEADParameters(
        KeyParameter(keyBytes),
        128,
        nonce,
        Uint8List(0),
      ), // tag size = 128 bits
    );

    final encrypted = cipher.process(Uint8List.fromList(plainText));

    // Combine nonce + ciphertext
    final combined = Uint8List.fromList(nonce + encrypted);
    return base64Encode(combined);
  }

  static String decryptWithAESGCM(String base64Data, Uint8List keyBytes) {
    final combined = base64Decode(base64Data);
    final nonce = combined.sublist(0, 12);
    final cipherText = combined.sublist(12);

    final cipher = GCMBlockCipher(AESEngine())..init(
      false,
      AEADParameters(KeyParameter(keyBytes), 128, nonce, Uint8List(0)),
    );

    final decrypted = cipher.process(cipherText);
    return utf8.decode(decrypted);
  }
}
