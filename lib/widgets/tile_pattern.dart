/// Generates unique monochrome patterns from song titles for the Top 9 grid.
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Creates a deterministic [Canvas] painter from a string seed (song title).
/// All colors are strictly shades of black/grey — no color tints.
class TitlePatternPainter extends CustomPainter {
  final String seed;

  TitlePatternPainter(this.seed) : _hash = _computeHash(seed);

  static int _computeHash(String s) {
    int h = 0;
    for (int i = 0; i < s.codeUnits.length; i++) {
      h = ((h << 5) - h + s.codeUnits[i]) & 0xFFFFFFFF;
    }
    return h;
  }

  final int _hash;

  /// Returns a deterministic random from the hash.
  double _rand(int index) {
    var state = (_hash + index * 2654435761) & 0xFFFFFFFF;
    return (state % 10000) / 10000.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // Background: dark grey gradient (no color tints)
    final bg1 = 18 + _rand(0).round() * 15;   // 18-33 range
    final bg2 = 8 + _rand(1).round() * 12;     // 8-20 range

    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = Color.fromRGBO(bg1, bg1, bg1, 1.0),
    );

    // Subtle gradient overlay
    final gradPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          Color.fromRGBO(bg2, bg2, bg2, 0.8),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), gradPaint);

    // Pattern type (0-4) determines the geometric style
    final patternType = (_hash % 5);
    final lineAlpha = 0.08 + _rand(6) * 0.12;
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: lineAlpha)
      ..strokeWidth = 0.8 + _rand(7) * 1.5
      ..style = PaintingStyle.stroke;

    switch (patternType) {
      case 0: // Concentric circles
        for (int i = 0; i < 6; i++) {
          final radius = (10 + i * (w / 14)) * (0.7 + _rand(10 + i) * 0.3);
          canvas.drawCircle(center, radius, linePaint);
        }
        break;

      case 1: // Diagonal lines
        for (int i = -8; i < 8; i++) {
          final offset = i * (w / 8) * (0.6 + _rand(20 + i.abs()) * 0.4);
          canvas.drawLine(
            Offset(offset, 0),
            Offset(offset + w, h),
            linePaint,
          );
        }
        break;

      case 2: // Horizontal bars (replaces dot grid)
        final numBars = 5 + (_hash % 6);
        for (int i = 0; i < numBars; i++) {
          final barY = h * (i + 1) / (numBars + 1);
          final barH = 2.0 + _rand(30 + i) * 4;
          canvas.drawRect(
            Rect.fromLTWH(0, barY - barH / 2, w, barH),
            Paint()
              ..color = Colors.white.withValues(alpha: lineAlpha * (0.5 + _rand(40 + i) * 0.5))
              ..style = PaintingStyle.fill,
          );
        }
        break;

      case 3: // Horizontal waves
        for (int i = 0; i < 8; i++) {
          final baseY = h * (i + 1) / 9;
          final path = Path();
          path.moveTo(0, baseY);
          for (double x = 0; x <= w; x += 5) {
            final y = baseY + math.sin(x * 0.03 + _rand(40 + i) * 6) * (6 + _rand(50 + i) * 10);
            path.lineTo(x, y);
          }
          canvas.drawPath(path, linePaint);
        }
        break;

      case 4: // Radial lines from center
        final numLines = 6 + (_hash % 8);
        for (int i = 0; i < numLines; i++) {
          final angle = (i / numLines) * math.pi * 2 + _rand(60 + i) * 0.3;
          final len = w * 0.7 * (0.5 + _rand(70 + i) * 0.5);
          canvas.drawLine(
            center,
            Offset(
              center.dx + math.cos(angle) * len,
              center.dy + math.sin(angle) * len,
            ),
            linePaint,
          );
        }
        break;
    }

    // Large initial letter of the title overlaid subtly
    if (seed.isNotEmpty) {
      final letter = seed[0].toUpperCase();
      final textPainter = TextPainter(
        text: TextSpan(
          text: letter,
          style: TextStyle(
            fontSize: w * 0.55,
            fontWeight: FontWeight.w100,
            color: Colors.white.withValues(alpha: 0.04 + _rand(80) * 0.05),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(TitlePatternPainter oldDelegate) => seed != oldDelegate.seed;
}

/// Widget that displays a monochrome geometric pattern based on song title.
class TitlePattern extends StatelessWidget {
  final String title;

  const TitlePattern({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TitlePatternPainter(title),
      size: Size.infinite,
    );
  }
}
