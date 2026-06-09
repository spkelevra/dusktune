/// App theme constants for DuskTune — grey-only palette.
library;

import 'package:flutter/material.dart';

// No blue accent — everything uses greys and white shades.

ThemeData appDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: ColorScheme.dark(
    primary: Colors.white70,
    secondary: Colors.grey[400]!,
    surface: const Color(0xFF1E1E1E),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A1A1A),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white70),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1A1A1A),
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.white70,
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: Colors.white70,
    inactiveTrackColor: Colors.white24,
    thumbColor: Colors.white,
    overlayColor: Colors.white.withValues(alpha: 0.2),
    trackHeight: 3,
  ),
);
