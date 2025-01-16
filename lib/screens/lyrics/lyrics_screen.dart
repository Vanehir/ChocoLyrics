import 'package:flutter/cupertino.dart';
import 'package:choco_lyrics/data/models/song.dart';
import 'package:choco_lyrics/data/repositories/lrclib/lrclib_repository.dart';

class LyricsScreen extends StatefulWidget {
  final Song song;

  const LyricsScreen({super.key, required this.song});

  @override
  _LyricsScreenState createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  final LrcLibRepository _lrcLibRepository = LrcLibRepository();
  List<String>? _lyrics;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchLyrics();
  }

  Future<void> _fetchLyrics() async {
    try {
      final lyrics = await _lrcLibRepository.getLyrics(
        artistName: widget.song.artists.map((artist) => artist.name).join(', '),
        songName: widget.song.name,
      );
      setState(() {
        _lyrics = lyrics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.song.name),
      ),
      child: SafeArea(
        child: _isLoading
            ? Center(child: CupertinoActivityIndicator())
            : _hasError
                ? Center(child: Text('Error loading lyrics'))
                : _lyrics == null
                    ? Center(child: Text('Lyrics not found'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _lyrics!.map((line) => Text(line)).toList(),
                        ),
                      ),
      ),
    );
  }
}
