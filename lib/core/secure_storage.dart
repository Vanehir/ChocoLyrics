import 'dart:developer';  
import 'package:flutter_secure_storage/flutter_secure_storage.dart';  

class SecureStorage {  
  final _storage = const FlutterSecureStorage(); 

  Future<void> setItem(String key, String item) async {  
    try {  
      await _storage.write(key: key, value: item);    
    } catch (e) {  
      throw Exception("Error setting item: $e"); 
    }  
  }  

  Future<String?> getItem(String key) async {  
    try {  
      return await _storage.read(key: key);  
    } catch (e) {  
      throw Exception("Error getting item: $e");  
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