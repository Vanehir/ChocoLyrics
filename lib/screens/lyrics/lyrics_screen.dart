import 'package:choco_lyrics/screens/lyrics/lyrics_cubit.dart';
import 'package:choco_lyrics/screens/lyrics/lyrics_state.dart';
import 'package:choco_lyrics/themes/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/data/repositories/lrclib/lrclib_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LyricsScreen extends StatelessWidget {
  final Song song;

  const LyricsScreen({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LyricsCubit(
        lrcLibRepository: LrcLibRepository(),
        song: song,
      )..fetchLyrics(),
      child: const LyricsView(),
    );
  }
}

class LyricsView extends StatelessWidget {
  const LyricsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LyricsCubit, LyricsState>(
      builder: (context, state) {
        final cubit = context.read<LyricsCubit>();

        return CupertinoPageScaffold(
          backgroundColor: beige,
          navigationBar: CupertinoNavigationBar(
            backgroundColor:
                state is LyricsLoaded && state.isScrolled ? darkBrown : beige,
            padding: EdgeInsetsDirectional.zero,
            leading: CupertinoNavigationBarBackButton(
              color:
                  state is LyricsLoaded && state.isScrolled ? beige : darkBrown,
              onPressed: () => Navigator.of(context).pop(),
            ),
            border: Border(
              bottom: BorderSide(
                color: state is LyricsLoaded && state.isScrolled
                    ? darkBrown
                    : beige,
                width: 0,
              ),
            ),
            middle: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cubit.song.name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: state is LyricsLoaded && state.isScrolled
                        ? beige
                        : darkBrown,
                  ),
                ),
                Text(
                  cubit.artistNames,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: state is LyricsLoaded && state.isScrolled
                        ? beige.withAlpha(179)
                        : darkBrownShadow,
                  ),
                ),
              ],
            ),
          ),
          child: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, LyricsState state) {
    if (state is LyricsLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    if (state is LyricsError || state is LyricsInitial) {
      return Center(
        child: Text(
          'Lyrics not found',
          style: TextStyle(
            color: darkBrown,
            fontSize: 16,
            fontFamily: 'Roboto',
          ),
        ),
      );
    }

    if (state is LyricsLoaded) {
      return SingleChildScrollView(
        controller: context.read<LyricsCubit>().scrollController,
        padding: const EdgeInsets.only(top: 16.0, bottom: 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: state.lyrics.asMap().entries.map((entry) {
            int index = entry.key;
            String line = entry.value;
            bool isSelected = state.selectedLines.contains(index);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () =>
                    context.read<LyricsCubit>().toggleLineSelection(index),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isSelected ? darkBrown : beige,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 3.5,
                      ),
                      child: Text(
                        line,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: isSelected ? beige : darkBrown,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    return const Center(child: Text('Lyrics not found'));
  }
}
