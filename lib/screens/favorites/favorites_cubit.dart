import 'package:choco_lyrics/screens/favorites/favorites_state.dart';
import 'package:choco_lyrics/ui/favorites/favorite_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoriteHandler _favoriteHandler;
  
  FavoritesCubit({
    required FavoriteHandler favoriteHandler,
  }) : _favoriteHandler = favoriteHandler,
       super(const FavoritesInitial());

  Set<String> getFavoriteIds() {
    return state is FavoritesLoaded 
        ? (state as FavoritesLoaded).favoriteIds 
        : {};
  }

  Future<void> loadFavorites() async {
    final favorites = await _favoriteHandler.getFavorites();
    emit(FavoritesLoaded(favorites.toSet()));
  }

  Future<void> toggleFavorite(String id) async {
    final currentFavorites = getFavoriteIds();
    
    if (currentFavorites.contains(id)) {
      await _favoriteHandler.removeFavorite(id);
      currentFavorites.remove(id);
    } else {
      await _favoriteHandler.addFavorite(id);
      currentFavorites.add(id);
    }
    
    emit(FavoritesLoaded(currentFavorites));
  }
}