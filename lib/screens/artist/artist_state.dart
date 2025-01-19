import 'package:choco_lyrics/data/models/song.dart';

sealed class ArtistState {
  const ArtistState();
}

class ArtistInitial extends ArtistState {
  const ArtistInitial();
}

class ArtistLoading extends ArtistState {
  const ArtistLoading();
}

class ArtistLoaded extends ArtistState {
  final List<Song> topSongs;
  
  const ArtistLoaded({
    required this.topSongs,
  });
}

class ArtistError extends ArtistState {
  final String message;
  
  const ArtistError(this.message);
}