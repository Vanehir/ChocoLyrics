sealed class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoaded extends FavoritesState {
  final Set<String> favoriteIds;
  
  const FavoritesLoaded(this.favoriteIds);
}