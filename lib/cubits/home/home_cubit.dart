import 'package:choco_lyrics/cubits/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_constants.dart';

class HomeCubit extends Cubit<HomeState> {
  final SpotifyRepository _spotifyRepository;

  HomeCubit({
    required SpotifyRepository spotifyRepository,
  })  : _spotifyRepository = spotifyRepository,
        super(const HomeState());

  Future<void> loadPlaylists() async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final topHitsPlaylist = await _spotifyRepository.getPlaylist(
        idPlaylist: todayTopHits,
      );
      final top50GlobalPlaylist = await _spotifyRepository.getPlaylist(
        idPlaylist: top50GlobalId,
      );

      emit(state.copyWith(
        status: HomeStatus.success,
        topHits: topHitsPlaylist,
        top50Global: top50GlobalPlaylist,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  void reset() {
    emit(const HomeState());
  }
}