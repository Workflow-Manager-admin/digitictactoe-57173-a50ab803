import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tic_tac_toe_frontend/main.dart';

void main() {
  testWidgets('TicTacToeApp builds smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TicTacToeApp());

    // Verify that the title shows and game board renders.
    expect(find.text('Tic Tac Toe'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget); // Restart Game button present
    expect(find.textContaining('Player'), findsOneWidget); // Should show turn or result
  });
}
