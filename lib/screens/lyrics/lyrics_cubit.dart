// lyrics_cubit.dart
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/data/repositories/lrclib/lrclib_repository.dart';
import 'package:choco_lyrics/screens/lyrics/lyrics_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LyricsCubit extends Cubit<LyricsState> {
  final LrcLibRepository _lrcLibRepository;
  final Song song;
  final ScrollController scrollController = ScrollController();
  
  LyricsCubit({
    required LrcLibRepository lrcLibRepository,
    required this.song,
  }) : _lrcLibRepository = lrcLibRepository,
       super(const LyricsInitial()) {
    _initScrollController();
  }

  void _initScrollController() {
    scrollController.addListener(() {
      if (state is LyricsLoaded) {
        final currentState = state as LyricsLoaded;
        final shouldBeScrolled = scrollController.offset > 0;
        
        if (shouldBeScrolled != currentState.isScrolled) {
          emit(currentState.copyWith(isScrolled: shouldBeScrolled));
        }
      }
    });
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }

  String get artistNames {
    return song.artists.map((artist) => artist.name).join(', ');
  }

  Future<void> fetchLyrics() async {
  emit(const LyricsLoading());

  try {
    final lyrics = await _lrcLibRepository.getLyrics(
      artistName: artistNames,
      songName: song.name,
    );

    if (lyrics != null && lyrics.isNotEmpty) {  // Verifichiamo anche che non sia vuota
      emit(LyricsLoaded(
        lyrics: lyrics,
        selectedLines: {},
      ));
    } else {
      emit(const LyricsError('Lyrics not found'));  // Cambiamo il messaggio di errore
    }
  } catch (e) {
    emit(const LyricsError('Lyrics not found'));  // Uniformiamo il messaggio di errore
  }
}

  void toggleLineSelection(int index) {
    if (state is LyricsLoaded) {
      final currentState = state as LyricsLoaded;
      final updatedSelection = Set<int>.from(currentState.selectedLines);
      
      if (updatedSelection.contains(index)) {
        updatedSelection.remove(index);
      } else {
        updatedSelection.add(index);
      }
      
      emit(currentState.copyWith(selectedLines: updatedSelection));
    }
  }
}