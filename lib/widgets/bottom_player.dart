/// Bottom player bar — persistent mini-player shown at the bottom of screens.
library;

import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/audio_player.dart';
import '../screens/now_playing_screen.dart';

class BottomPlayer extends StatefulWidget {
  final Song song;

  const BottomPlayer({super.key, required this.song});

  @override
  State<BottomPlayer> createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    AudioPlayerService.playbackState.listen((state) {
      if (mounted) setState(() => _isPlaying = state?.playing ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.song;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NowPlayingScreen(song: song),
          ),
        );
      },
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          border: Border(
            top: BorderSide(color: Colors.white10, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Album art thumbnail
            Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.all(8),
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

            // Song info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      song.artist ?? 'Unknown Artist',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            // Play/pause button
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                size: 36,
                color: Colors.white,
              ),
              onPressed: AudioPlayerService.togglePlayPause,
            ),

            // Skip next
            IconButton(
              icon: const Icon(Icons.skip_next, size: 28, color: Colors.white70),
              onPressed: AudioPlayerService.skipToNext,
            ),

            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
