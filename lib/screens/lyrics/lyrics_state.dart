// lyrics_state.dart
sealed class LyricsState {
  const LyricsState();
}

class LyricsInitial extends LyricsState {
  const LyricsInitial();
}

class LyricsLoading extends LyricsState {
  const LyricsLoading();
}

class LyricsLoaded extends LyricsState {
  final List<String> lyrics;
  final Set<int> selectedLines;
  final bool isScrolled;
  
  const LyricsLoaded({
    required this.lyrics,
    required this.selectedLines,
    this.isScrolled = false,
  });

  LyricsLoaded copyWith({
    List<String>? lyrics,
    Set<int>? selectedLines,
    bool? isScrolled,
  }) {
    return LyricsLoaded(
      lyrics: lyrics ?? this.lyrics,
      selectedLines: selectedLines ?? this.selectedLines,
      isScrolled: isScrolled ?? this.isScrolled,
    );
  }
}

class LyricsError extends LyricsState {
  final String message;
  
  const LyricsError(this.message);
}