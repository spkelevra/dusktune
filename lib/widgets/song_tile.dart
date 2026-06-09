/// Song tile widget for displaying a song in lists or grids.
library;

import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/audio_player.dart';
import '../screens/now_playing_screen.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final bool compact; // true = list item, false = grid card

  const SongTile({super.key, required this.song, this.compact = false});

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildListItem(context);
    }
    return _buildGridCard(context);
  }

  /// Grid card for the recent section — square album art.
  Widget _buildGridCard(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Play immediately AND navigate to now-playing screen.
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Square album art container
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(6),
                  image: song.hasArtwork
                      ? DecorationImage(
                          image: song.artImage!,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: !song.hasArtwork
                    ? const Icon(Icons.music_note, size: 32, color: Colors.white24)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Song title
          Expanded(
            flex: 1,
            child: Text(
              song.title,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// List item for library/search results.
  Widget _buildListItem(BuildContext context) {
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
            ? const Icon(Icons.music_note, size: 24, color: Colors.white38)
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
  }

  String _formatDuration(int ms) {
    final duration = Duration(milliseconds: ms);
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
