import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// 무작위 Nonce 생성 (원문)
String generateRawNonce() {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  final random = Random.secure();
  return List.generate(
    32,
    (index) => charset[random.nextInt(charset.length)],
  ).join();
}

/// Nonce를 SHA-256으로 해싱 (애플 전달용)
String sha256Hash(String rawNonce) {
  final bytes = utf8.encode(rawNonce);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
