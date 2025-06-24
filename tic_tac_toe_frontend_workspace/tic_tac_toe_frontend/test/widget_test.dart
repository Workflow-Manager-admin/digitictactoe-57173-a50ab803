import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_frontend/main.dart';

void main() {
  testWidgets('App builds and shows main elements', (WidgetTester tester) async {
    // Build the app and pump a frame.
    await tester.pumpWidget(const MyApp());

    // Check for AppBar/title.
    expect(find.text('Tic Tac Toe'), findsWidgets);

    // Check for main game title.
    expect(find.text('Minimalist Tic Tac Toe'), findsOneWidget);

    // Check the game board and "Restart" button.
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Restart'), findsOneWidget);

    // Check for initial status message.
    expect(find.text('Player X starts!'), findsOneWidget);
  });
}
