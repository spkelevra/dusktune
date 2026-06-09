/// Search screen — search songs by title or artist.
library;

import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/audio_player.dart';
import '../services/music_library.dart';
import '../screens/now_playing_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Song> _results = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() => _isSearching = true);
    final library = MusicLibrary();
    await library.init();
    final results = await library.search(query);
    if (mounted) {
      setState(() {
        _results = results;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Search bar
        SliverAppBar(
          expandedHeight: 100,
          floating: false,
          pinned: true,
          title: TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search songs or artists...',
              hintStyle: const TextStyle(color: Colors.white54),
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
            ),
            onChanged: (value) => _search(value),
          ),
        ),

        // Results
        if (_isSearching)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_results.isEmpty && _searchController.text.isNotEmpty)
          const SliverFillRemaining(
            child: Center(
              child: Text(
                'No results found',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = _results[index];
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(4),
                      image: song.hasArtwork
                          ? DecorationImage(
                              image: song.artImage!,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                  title: Text(
                    song.title,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    song.artist ?? 'Unknown Artist',
                    style: const TextStyle(color: Colors.white54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    await AudioPlayerService.playSong(song);
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NowPlayingScreen(song: song),
                        ),
                      );
                    }
                  },
                );
              },
              childCount: _results.length,
            ),
          ),
      ],
    );
  }
}
