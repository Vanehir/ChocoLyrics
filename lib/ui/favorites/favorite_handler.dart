import 'dart:convert';
import 'dart:developer';

import 'package:choco_lyrics/core/storage/secure_storage.dart';

const String favoritesKey = 'favorites';

class FavoriteHandler {
  final SecureStorage secureStorage = SecureStorage();

  Future<List<String>> getFavorites() async {
  final String? stringFavorites = await secureStorage.getItem(key: favoritesKey);
  log('Raw favorites from storage: $stringFavorites'); // Debug print
  final List<dynamic> favorites = jsonDecode(stringFavorites ?? '[]');
  log('Decoded favorites: $favorites'); // Debug print
  return favorites.cast<String>();
}

  Future<void> addFavorite(String id) async {
    final String? stringFavorites =
        await secureStorage.getItem(key: favoritesKey);
    final List<dynamic> favorites = jsonDecode(stringFavorites ?? '[]');
    favorites.add(id);
    await secureStorage.setItem(key: favoritesKey, item: jsonEncode(favorites));
  }

  Future<void> removeFavorite(String id) async {
    final String? stringFavorites =
        await secureStorage.getItem(key: favoritesKey);
    final List<dynamic> favorites = jsonDecode(stringFavorites ?? '[]');
    favorites.remove(id);
    await secureStorage.setItem(key: favoritesKey, item: jsonEncode(favorites));
  }

  
}