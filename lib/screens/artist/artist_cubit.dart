import 'package:choco_lyrics/data/models/artist.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/artist/artist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArtistCubit extends Cubit<ArtistState> {
  final SpotifyRepository _spotifyRepository;
  final Artist artist;
  static const int maxSongs = 20;
  
  ArtistCubit({
    required SpotifyRepository spotifyRepository,
    required this.artist,
  }) : _spotifyRepository = spotifyRepository,
       super(const ArtistInitial());

  Future<void> loadTopSongs() async {
    emit(const ArtistLoading());

    try {
      final results = await _spotifyRepository.getItemFromSearch(
        query: artist.name,
        queryParameter: SpotifySearchType.track,
      );

      final artistSongs = results
          .whereType<Song>()
          .where((song) => song.artists.any((songArtist) =>
              songArtist.name.toLowerCase() == artist.name.toLowerCase()))
          .take(maxSongs)
          .toList();

      emit(ArtistLoaded(topSongs: artistSongs));
        } catch (e) {
      emit(ArtistError(e.toString()));
    }
  }
}