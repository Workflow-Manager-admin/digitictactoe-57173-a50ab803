import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

///
/// PUBLIC_INTERFACE
/// Main app entry point using custom color scheme and modern font.
///
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF4A90E2); // cool blue
    final Color secondaryColor = const Color(0xFF50E3C2); // soft teal
    final Color accentColor = const Color(0xFFB8E986); // soft green
    final Color backgroundColor = const Color(0xFFFAFAFA); // very light gray

    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: Colors.white,
          // background and onBackground deprecated
          error: Colors.redAccent,
          onPrimary: Colors.white,
          onSecondary: Colors.black87,
          onSurface: Colors.black87,
          // onBackground deprecated
          onError: Colors.white,
        ),
        textTheme: GoogleFonts.montserratTextTheme().copyWith(
          headlineLarge: GoogleFonts.montserrat(
              fontSize: 38, fontWeight: FontWeight.bold, color: primaryColor),
          headlineMedium: GoogleFonts.montserrat(
              fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor),
          titleLarge: GoogleFonts.montserrat(
              fontSize: 24, fontWeight: FontWeight.w700, color: primaryColor),
          titleMedium: GoogleFonts.montserrat(
              fontSize: 19, fontWeight: FontWeight.w500, color: secondaryColor),
          bodyLarge: GoogleFonts.montserrat(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
          bodyMedium: GoogleFonts.montserrat(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            textStyle: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        appBarTheme: AppBarTheme(
          color: primaryColor,
          titleTextStyle: GoogleFonts.montserrat(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          centerTitle: true,
        ),
      ),
      home: const TicTacToeHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

///
/// PUBLIC_INTERFACE
/// Main home page for Tic Tac Toe game, with minimalist modern look.
///
class TicTacToeHomePage extends StatefulWidget {
  const TicTacToeHomePage({super.key});

  @override
  State<TicTacToeHomePage> createState() => _TicTacToeHomePageState();
}

class _TicTacToeHomePageState extends State<TicTacToeHomePage> {
  static const int boardSize = 3;
  List<List<String>> board = List.generate(boardSize, (_) => List.filled(boardSize, ''));
  String currentPlayer = 'X';
  String statusMessage = 'Player X starts!';
  bool gameEnded = false;

  void _handleTap(int row, int col) {
    if (board[row][col].isEmpty && !gameEnded) {
      setState(() {
        board[row][col] = currentPlayer;
        if (_checkWinner(currentPlayer)) {
          statusMessage = 'Player $currentPlayer wins!';
          gameEnded = true;
        } else if (_isBoardFull()) {
          statusMessage = 'Draw!';
          gameEnded = true;
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          statusMessage = "Player $currentPlayer's turn";
        }
      });
    }
  }

  void _resetGame() {
    setState(() {
      board = List.generate(boardSize, (_) => List.filled(boardSize, ''));
      currentPlayer = 'X';
      statusMessage = 'Player X starts!';
      gameEnded = false;
    });
  }

  bool _isBoardFull() {
    return board.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  bool _checkWinner(String player) {
    // Check rows and columns
    for (int i = 0; i < boardSize; i++) {
      if (board[i].every((cell) => cell == player)) return true;
      if ([for (var row in board) row[i]].every((cell) => cell == player)) return true;
    }

    // Check diagonals
    if ([for (int i = 0; i < boardSize; i++) board[i][i]].every((cell) => cell == player)) return true;
    if ([for (int i = 0; i < boardSize; i++) board[i][boardSize - 1 - i]].every((cell) => cell == player))
      return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe',
            style: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        elevation: 2,
      ),
      backgroundColor: colors.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Minimalist Tic Tac Toe',
              style: theme.textTheme.headlineLarge!
                  .copyWith(color: colors.primary, fontSize: 36),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              statusMessage,
              style: theme.textTheme.titleLarge!.copyWith(
                  color: colors.secondary, fontWeight: FontWeight.w700, fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colors.primary.withAlpha(56), width: 3), // 0.22 * 255 ≈ 56
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withAlpha(23), // 0.09 * 255 ≈ 23
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: List.generate(boardSize, (row) {
                    return Expanded(
                      child: Row(
                        children: List.generate(boardSize, (col) {
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => _handleTap(row, col),
                              child: Container(
                                margin: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: board[row][col].isEmpty
                                      ? colors.surface
                                      : colors.secondary.withAlpha(25), // 0.10 * 255 ≈ 25
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colors.secondary.withAlpha(92), // 0.36 * 255 ≈ 92
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    board[row][col],
                                    style: GoogleFonts.montserrat(
                                      fontSize: 54,
                                      fontWeight: FontWeight.bold,
                                      color: board[row][col] == 'X'
                                          ? colors.primary
                                          : board[row][col] == 'O'
                                              ? colors.secondary
                                              : Colors.black26,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _resetGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.secondary,
                foregroundColor: Colors.black,
                shadowColor: colors.primary.withAlpha(46), // 0.18 * 255 ≈ 46
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 17),
                textStyle: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
