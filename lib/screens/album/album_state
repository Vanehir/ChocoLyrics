import 'package:choco_lyrics/data/models/song.dart';

sealed class AlbumState {
  const AlbumState();
}

class AlbumInitial extends AlbumState {
  const AlbumInitial();
}

class AlbumLoading extends AlbumState {
  const AlbumLoading();
}

class AlbumLoaded extends AlbumState {
  final List<Song> songs;
  
  const AlbumLoaded({
    required this.songs,
  });
}

class AlbumError extends AlbumState {
  final String message;
  
  const AlbumError(this.message);
}