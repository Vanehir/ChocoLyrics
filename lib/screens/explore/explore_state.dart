import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';

sealed class ExploreState {
  final SpotifySearchType activeFilter;
  
  const ExploreState({
    required this.activeFilter,
  });
}

class ExploreInitial extends ExploreState {
  const ExploreInitial() : super(activeFilter: SpotifySearchType.track);
}

class ExploreLoading extends ExploreState {
  const ExploreLoading({required super.activeFilter});
}

class ExploreLoaded extends ExploreState {
  final List<dynamic> items;
  final Set<String> favoriteIds;
  final String query;
  
  const ExploreLoaded({
    required this.items,
    required super.activeFilter,
    required this.favoriteIds,
    required this.query,
  });
}

class ExploreError extends ExploreState {
  final String message;
  
  const ExploreError(
    this.message, {
    required super.activeFilter,
  });
}