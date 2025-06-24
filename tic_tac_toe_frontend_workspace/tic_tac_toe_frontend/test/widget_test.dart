import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_frontend/main.dart';

void main() {
  testWidgets('TicTacToeApp builds and shows main elements', (WidgetTester tester) async {
    // Build the app and pump a frame.
    await tester.pumpWidget(const TicTacToeApp());

    // Check for AppBar/title.
    expect(find.text('Tic Tac Toe'), findsWidgets);

    // Check for New Game button.
    expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);

    // Check the game board is displayed.
    expect(find.byType(GridView), findsOneWidget);

    // Check for initial status message.
    expect(find.text('X\'s turn'), findsOneWidget);

    // Check for credit/footer.
    expect(find.textContaining('Minimal Design'), findsOneWidget);
  });
}
