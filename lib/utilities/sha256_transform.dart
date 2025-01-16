import 'dart:convert';
import 'package:crypto/crypto.dart';

Future<String> generateSha256Hash(String plain) async {
  var bytes = utf8.encode(plain);
  var digest = sha256.convert(bytes);
  return digest.toString();
}