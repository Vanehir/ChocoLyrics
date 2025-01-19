
import 'package:choco_lyrics/data/models/album.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/screens/album/album_state';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlbumCubit extends Cubit<AlbumState> {
  final SpotifyRepository _spotifyRepository;
  final Album album;
  
  AlbumCubit({
    required SpotifyRepository spotifyRepository,
    required this.album,
  }) : _spotifyRepository = spotifyRepository,
       super(const AlbumInitial());

  Future<void> loadSongs() async {
    emit(const AlbumLoading());

    try {
      final searchQuery = '${album.artists.first.name} ${album.name}';
      final dynamic results = await _spotifyRepository.getItemFromSearch(
        query: searchQuery,
        queryParameter: SpotifySearchType.track,
      );

      // Esplicitamente convertiamo i risultati in List<Song>
      if (results is List) {
        final albumSongs = results
            .whereType<Song>()
            .where((song) =>
                song.album.name.toLowerCase() == album.name.toLowerCase())
            .toList();

        emit(AlbumLoaded(songs: albumSongs));
      } else {
        emit(const AlbumError('Invalid response format'));
      }
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }
}