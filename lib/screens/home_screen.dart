/// Home screen — main landing page with recent songs and navigation.
library;

import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/audio_player.dart';
import '../widgets/recent_grid.dart';
import '../widgets/section_header.dart';
import '../screens/library_screen.dart';
import '../screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Song> allSongs;

  const HomeScreen({super.key, required this.allSongs});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Song> get recentSongs => widget.allSongs.take(9).toList();

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeTab(),
      const SearchScreen(),
      LibraryScreen(songs: widget.allSongs),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A1A1A),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        // App bar
        SliverAppBar(
          expandedHeight: 100,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'DuskTune',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
          ),
        ),

        // Recent section
        if (recentSongs.isNotEmpty) ...[
          const SliverToBoxAdapter(child: SectionHeader(title: 'Recent')),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: RecentGrid(recentSongs: recentSongs),
            ),
          ),
        ],

        // All songs section
        if (widget.allSongs.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'All Songs',
              onSeeAll: () {
                setState(() => _currentIndex = 2);
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = widget.allSongs[index];
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
                  },
                );
              },
              childCount: widget.allSongs.length,
            ),
          ),
        ],

        // Bottom padding for player bar
        const SliverToBoxAdapter(child: SizedBox(height: 64)),
      ],
    );
  }
}
