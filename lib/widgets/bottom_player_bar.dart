/// Compact bottom player bar shown on the home screen.
library;

/// Displays the currently playing song with a play/pause button and
/// progress indicator. Tapping opens the full Now Playing screen.

import 'package:flutter/material.dart';
import '../models/song.dart';

class BottomPlayerBar extends StatelessWidget {
  final Song currentSong;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final VoidCallback onPlayPause;
  final VoidCallback onTapToExpand;

  const BottomPlayerBar({
    super.key,
    required this.currentSong,
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.onPlayPause,
    required this.onTapToExpand,
  });

  @override
  Widget build(BuildContext context) {
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return GestureDetector(
      onTap: onTapToExpand,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          border: Border(top: BorderSide(color: Colors.grey[800]!)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Thin progress bar at the top.
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white70),
              minHeight: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Song info — expandable.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentSong.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          currentSong.artist ?? 'Unknown Artist',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Play/Pause button.
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white70,
                      size: 32,
                    ),
                    onPressed: onPlayPause,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
