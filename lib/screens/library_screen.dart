/// Library screen — browse all songs in the device library.
library;

import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/audio_player.dart';
import '../screens/now_playing_screen.dart';

class LibraryScreen extends StatelessWidget {
  final List<Song> songs;

  const LibraryScreen({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 80,
          floating: false,
          pinned: true,
          title: const Text('Library'),
        ),
        if (songs.isEmpty)
          const SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.library_music, size: 64, color: Colors.white24),
                  SizedBox(height: 16),
                  Text(
                    'No songs found',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = songs[index];
                return ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(6),
                      image: song.hasArtwork
                          ? DecorationImage(
                              image: song.artImage!,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: !song.hasArtwork
                        ? const Icon(Icons.music_note, size: 20, color: Colors.white38)
                        : null,
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
                  trailing: Text(
                    _formatDuration(song.durationMs),
                    style: const TextStyle(fontSize: 12, color: Colors.white38),
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
              childCount: songs.length,
            ),
          ),
      ],
    );
  }

  String _formatDuration(int ms) {
    final duration = Duration(milliseconds: ms);
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
