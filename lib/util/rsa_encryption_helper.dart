import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/asymmetric/oaep.dart';
import 'package:pointycastle/asymmetric/rsa.dart';

class RSAEncryptionHelper {
  final RSAPublicKey publicKey;
  final RSAPrivateKey? privateKey;

  RSAEncryptionHelper({required String publicKeyPem, String? privateKeyPem})
    : publicKey = CryptoUtils.rsaPublicKeyFromPem(publicKeyPem),
      privateKey =
          privateKeyPem != null
              ? CryptoUtils.rsaPrivateKeyFromPem(privateKeyPem)
              : null;

  String encrypt(Map<String, String> data) {
    final jsonData = json.encode(data);
    final jsonBytes = utf8.encode(jsonData);

    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

    final encrypted = encryptor.process(jsonBytes);
    return base64Encode(encrypted);
  }

  Map<String, dynamic> decrypt(String base64Encrypted) {
    if (privateKey == null) {
      throw ArgumentError("Private key required for decryption.");
    }

    final encryptedBytes = base64Decode(base64Encrypted);

    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey!));

    final decryptedBytes = decryptor.process(encryptedBytes);
    final jsonString = utf8.decode(decryptedBytes);
    return json.decode(jsonString);
  }
}
