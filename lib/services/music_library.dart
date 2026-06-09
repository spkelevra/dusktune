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

  /// Initialize and query all songs from device (no artwork).
  Future<List<Song>> init() async {
    final List<SongModel> songModels = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );

    final songs = songModels.map((sm) => Song.fromSongModel(sm)).toList();
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
