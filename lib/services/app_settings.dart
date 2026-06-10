/// Persistent storage for user preferences using shared_preferences.
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const String _kAppName = 'app_name';
  static const String _kPlayCounts = 'play_counts_v1'; // bump suffix on schema change

  /// Load saved app name, or return default.
  static Future<String> loadAppName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAppName) ?? 'dusktune';
  }

  /// Save app name persistently.
  static Future<void> saveAppName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAppName, name);
  }

  /// Load play counts map: song ID → count.
  static Future<Map<int, int>> loadPlayCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPlayCounts);
    if (raw == null || raw.isEmpty) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(int.parse(k), v as int));
    } catch (_) {
      return {};
    }
  }

  /// Save play counts map persistently.
  static Future<void> savePlayCounts(Map<int, int> counts) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(counts.map((k, v) => MapEntry(k.toString(), v)));
    await prefs.setString(_kPlayCounts, raw);
  }
}
