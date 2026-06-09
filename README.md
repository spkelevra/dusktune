# dusktune

A minimalist dark-mode music player for local audio files on Android.

## Features

- **Library scanning** — Query all songs from device storage with album art
- **Playback controls** — Play, pause, seek, skip with background audio support
- **Search** — Find songs by title or artist instantly
- **Recent tracks** — Quick-access grid of recently played songs
- **Now Playing** — Full-screen playback view with progress bar and transport controls

## Tech Stack

| Package | Purpose |
|---------|---------|
| [on_audio_query](https://pub.dev/packages/on_audio_query) ^2.9.0 | Local media library scanning |
| [just_audio](https://pub.dev/packages/just_audio) ^0.10.5 | Audio playback engine |
| [audio_service](https://pub.dev/packages/audio_service) ^0.18.18 | Background audio + system integration |
| [permission_handler](https://pub.dev/packages/permission_handler) ^11.3.1 | Runtime permission requests |

## Getting Started

```bash
flutter pub get
flutter run
```

Requires Android 13+ with `READ_MEDIA_AUDIO` permissions.

## License

MIT © 2026 spkelevra. See [LICENSE](LICENSE) and [NOTICES](NOTICES).
