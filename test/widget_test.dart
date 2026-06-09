// Widget tests for DuskTuneApp.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dusktune/main.dart';

void main() {
  testWidgets('DuskTune app boots without crashing', (tester) async {
    await tester.pumpWidget(const DuskTuneApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
