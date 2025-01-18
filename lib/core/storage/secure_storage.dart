import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> setItem({required String key, required String item}) async {
    await _storage.write(key: key, value: item);
  }

  Future<String?> getItem({required String key}) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw Exception("Error getting item: $e");
    }
  }

  Future<void> deleteItem({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      log("Error deleting item: $e");
    }
  }

  Future<void> clearStorage() async {
    try {
      await _storage.deleteAll();
      log("Storage cleared successfully!");
    } catch (e) {
      log("Error clearing storage: $e");
    }
  }
}
