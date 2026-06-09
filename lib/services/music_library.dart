/// Music library service — queries device music via [on_audio_query].
library;

import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../models/song.dart';

class MusicLibrary {
  late final OnAudioQuery _audioQuery;

  MusicLibrary() : _audioQuery = OnAudioQuery();

  /// Check if storage/audio permission is granted.
  Future<bool> hasPermission() async {
    return await _audioQuery.permissionsStatus();
  }

  /// Request storage/audio permission from the user.
  Future<bool> requestPermission() async {
    final result = await _audioQuery.permissionsRequest();
    debugPrint('MusicLibrary: permission result = $result');
    return result;
  }

  /// Initialize and query all songs from device, including album art.
  Future<List<Song>> init() async {
    final List<SongModel> songModels = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );

    var songs = songModels.map((sm) => Song.fromSongModel(sm)).toList();

    // Fetch album art for each song (with caching by album ID)
    final Map<int, Uint8List?> artCache = {};
    for (var i = 0; i < songs.length; i++) {
      final sm = songModels[i];

      // Use album ID as cache key so same album only queries once
      if (sm.albumId != null && !artCache.containsKey(sm.albumId)) {
        try {
          artCache[sm.albumId!] = await _audioQuery.queryArtwork(
            sm.albumId!,
            ArtworkType.AUDIO,
            format: ArtworkFormat.JPEG,
            size: 300,
          );
        } catch (e) {
          debugPrint('MusicLibrary: failed to query art for album ${sm.albumId}: $e');
          artCache[sm.albumId!] = null;
        }
      }

      // Apply cached artwork to song
      if (sm.albumId != null && artCache.containsKey(sm.albumId)) {
        final bytes = artCache[sm.albumId!];
        songs[i] = songs[i].copyWith(artworkBytes: bytes);
      }
    }

    debugPrint('MusicLibrary: loaded ${songs.length} songs');
    return songs;
  }

  /// Search songs by query string.
  Future<List<Song>> search(String query) async {
    if (query.isEmpty) return init();

    final List<SongModel> songModels = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );

    // Filter client-side (on_audio_query doesn't have built-in search)
    final lower = query.toLowerCase();
    final filtered = songModels.where((sm) {
      return sm.title.toLowerCase().contains(lower) ||
          (sm.artist?.toLowerCase().contains(lower) ?? false) ||
          (sm.album?.toLowerCase().contains(lower) ?? false);
    }).toList();

    return filtered.map((sm) => Song.fromSongModel(sm)).toList();
  }
}
