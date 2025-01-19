import 'package:choco_lyrics/screens/explore/explore_state.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/favorites/favorites_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final SpotifyRepository _spotifyRepository;
  final FavoritesCubit _favoritesCubit;

  ExploreCubit({
    required SpotifyRepository spotifyRepository,
    required FavoritesCubit favoritesCubit,
  })  : _spotifyRepository = spotifyRepository,
        _favoritesCubit = favoritesCubit,
        super(const ExploreInitial());

  SpotifySearchType _activeFilter = SpotifySearchType.track;

  Future<void> searchItems(String query) async {
    if (query.isEmpty) return;

    emit(ExploreLoading(activeFilter: _activeFilter));

    try {
      final results = await _spotifyRepository.getItemFromSearch(
        query: query,
        queryParameter: _activeFilter,
      );

      emit(ExploreLoaded(
        items: results,
        activeFilter: _activeFilter,
        favoriteIds: _favoritesCubit.getFavoriteIds(),
        query: query,
      ));
    } catch (e) {
      emit(ExploreError('Error during search', activeFilter: _activeFilter));
    }
  }

  void toggleFilter(SpotifySearchType filter) {
    _activeFilter = filter;

    if (state is ExploreLoaded) {
      final currentState = state as ExploreLoaded;
      emit(ExploreLoading(activeFilter: filter));
      if (currentState.query.isNotEmpty) {
        searchItems(currentState.query);
      }
    } else {
      emit(ExploreLoading(activeFilter: filter));
    }
  }
}
