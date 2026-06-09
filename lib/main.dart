/// DuskTune — a music player app.
library;

import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'models/song.dart';
import 'services/audio_player.dart';
import 'services/music_library.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioPlayerService.init();
  runApp(const DuskTuneApp());
}

class DuskTuneApp extends StatelessWidget {
  const DuskTuneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuskTune',
      debugShowCheckedModeBanner: false,
      theme: appDarkTheme,
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _isLoading = true;
  List<Song> _songs = [];

  @override
  void initState() {
    super.initState();
    _loadLibrary();
  }

  Future<void> _loadLibrary() async {
    final library = MusicLibrary();

    // Request storage permission before querying.
    final hasPermission = await library.requestPermission();
    if (!hasPermission) {
      // Permission denied — show app with empty library.
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      final songs = await library.init();
      if (mounted) {
        setState(() {
          _songs = songs;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('AppRoot _loadLibrary error: $e');
      // On any query failure, still let the user into the app.
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
          ),
        ),
      );
    }

    return HomeScreen(allSongs: _songs);
  }
}
