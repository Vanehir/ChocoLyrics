import 'package:choco_lyrics/data/models/song.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState {
  final HomeStatus status;
  final List<Song> topHits;
  final List<Song> top50Global;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.topHits = const [],
    this.top50Global = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Song>? topHits,
    List<Song>? top50Global,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      topHits: topHits ?? this.topHits,
      top50Global: top50Global ?? this.top50Global,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}