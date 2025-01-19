import 'package:choco_lyrics/themes/colors/colors.dart';
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
  final ScrollController _scrollController = ScrollController();
  List<String>? _lyrics;
  bool _isLoading = true;
  bool _hasError = false;
  final Set<int> _selectedLines = {};
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _fetchLyrics();
    
    _scrollController.addListener(() {
      final shouldBeScrolled = _scrollController.offset > 0;
      if (shouldBeScrolled != _isScrolled) {
        setState(() {
          _isScrolled = shouldBeScrolled;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String get _artistNames {
    return widget.song.artists.map((artist) => artist.name).join(', ');
  }

  Future<void> _fetchLyrics() async {
    try {
      final lyrics = await _lrcLibRepository.getLyrics(
        artistName: _artistNames,
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

  void _toggleLineSelection(int index) {
    setState(() {
      if (_selectedLines.contains(index)) {
        _selectedLines.remove(index);
      } else {
        _selectedLines.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: beige,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: _isScrolled ? darkBrown : beige,
        padding: EdgeInsetsDirectional.zero,  // Remove default padding
        leading: CupertinoNavigationBarBackButton(
          color: _isScrolled ? beige : darkBrown,
          onPressed: () => Navigator.of(context).pop(),
        ),
        border: Border(
          bottom: BorderSide(
            color: _isScrolled ? darkBrown : beige,
            width: 0,
          ),
        ),
        middle: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.song.name,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: _isScrolled ? beige : darkBrown,
              ),
            ),
            Text(
              _artistNames,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: _isScrolled ? beige.withAlpha(179) : darkBrownShadow,
              ),
            ),
          ],
        ),
      ),
      child: _isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : _hasError
              ? const Center(child: Text('Error loading lyrics'))
              : _lyrics == null
                  ? const Center(child: Text('Lyrics not found'))
                  : SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 16.0, bottom: 100.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _lyrics!.asMap().entries.map((entry) {
                          int index = entry.key;
                          String line = entry.value;
                          bool isSelected = _selectedLines.contains(index);
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: GestureDetector(
                              onTap: () => _toggleLineSelection(index),
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
                    ),
    );
  }
}