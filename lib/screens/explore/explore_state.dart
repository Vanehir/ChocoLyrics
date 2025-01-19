import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';

sealed class ExploreState {
  const ExploreState();
}

class ExploreInitial extends ExploreState {
  const ExploreInitial();
}

class ExploreLoading extends ExploreState {
  const ExploreLoading();
}

class ExploreLoaded extends ExploreState {
  final List<dynamic> items;
  final SpotifySearchType activeFilter;
  final Set<String> favoriteIds;
  final String query;
  
  const ExploreLoaded({
    required this.items,
    required this.activeFilter,
    required this.favoriteIds,
    required this.query,
  });
}

class ExploreError extends ExploreState {
  final String message;
  
  const ExploreError(this.message);
}