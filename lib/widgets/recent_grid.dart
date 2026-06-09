/// Recent songs grid — 3-column grid of recently played tracks.
library;

import 'package:flutter/material.dart';
import '../models/song.dart';
import '../widgets/song_tile.dart';

class RecentGrid extends StatelessWidget {
  final List<Song> recentSongs;

  const RecentGrid({super.key, required this.recentSongs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.85, // Slightly taller for title below art
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        itemCount: recentSongs.length,
        itemBuilder: (context, index) {
          final song = recentSongs[index];
          return SongTile(song: song);
        },
      ),
    );
  }
}
