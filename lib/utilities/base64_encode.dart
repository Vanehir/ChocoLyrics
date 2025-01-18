import 'dart:convert';

String base64EncodeString(String input) {
  final bytes = utf8.encode(input);
  return base64Encode(bytes);
} 