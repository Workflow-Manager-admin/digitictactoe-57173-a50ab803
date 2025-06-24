import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

///
/// PUBLIC_INTERFACE
/// The root widget for the Tic Tac Toe application.
/// Applies a minimalistic light theme and launches the main game page.
///
class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF1565C0), // Deep Blue
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF1565C0), // Deep Blue
          secondary: const Color(0xFFFDD835), // Yellow
          surface: Colors.white,
          error: const Color(0xFFB00020),
          onPrimary: Colors.white,
          onSecondary: Colors.black87,
          onSurface: Colors.black87,
          onError: Colors.white,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 18),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1565C0),
            foregroundColor: Colors.white,
            minimumSize: const Size(120, 44),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ),
      home: const TicTacToePage(),
    );
  }
}

/// Enum representing the two players
enum Player { x, o }

/// Helper function to convert Player enum to symbol string
String playerSymbol(Player? player) =>
    player == Player.x ? "X" : player == Player.o ? "O" : "";

///
/// PUBLIC_INTERFACE
/// Main Game Screen for Tic Tac Toe
///
class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  // 3x3 board, null when unoccupied; otherwise Player.x or Player.o.
  List<Player?> board = List<Player?>.filled(9, null);
  Player currentPlayer = Player.x;
  String statusMessage = 'X\'s turn';
  bool gameOver = false;
  int? winningLine; // Index of the win pattern if any: 0..7

  /// Patterns: 3 in a row (by index positions on flattened grid)
  static const List<List<int>> winPatterns = <List<int>>[
    [0, 1, 2], // Row 0
    [3, 4, 5], // Row 1
    [6, 7, 8], // Row 2
    [0, 3, 6], // Col 0
    [1, 4, 7], // Col 1
    [2, 5, 8], // Col 2
    [0, 4, 8], // Diag
    [2, 4, 6], // Diag
  ];

  /// Resets the board for a new game.
  // PUBLIC_INTERFACE
  void newGame() {
    setState(() {
      board = List<Player?>.filled(9, null);
      currentPlayer = Player.x;
      gameOver = false;
      statusMessage = 'X\'s turn';
      winningLine = null;
    });
  }

  /// Handles a tap on the board at index [i]
  void handleTap(int i) {
    if (gameOver || board[i] != null) {
      return;
    }
    setState(() {
      board[i] = currentPlayer;
      int? winResult = getWinner(board);
      if (winResult != null) {
        gameOver = true;
        winningLine = winResult;
        statusMessage =
            '${playerSymbol(board[winPatterns[winResult][0]])} wins!';
      } else if (board.every((cell) => cell != null)) {
        // Draw
        gameOver = true;
        statusMessage = 'It\'s a draw!';
      } else {
        // Next turn
        currentPlayer = currentPlayer == Player.x ? Player.o : Player.x;
        statusMessage = '${playerSymbol(currentPlayer)}\'s turn';
      }
    });
  }

  /// Returns the index of winning line if someone has won; otherwise null.
  int? getWinner(List<Player?> b) {
    for (int i = 0; i < winPatterns.length; i++) {
      final a = winPatterns[i];
      final Player? p = b[a[0]];
      if (p != null && b[a[1]] == p && b[a[2]] == p) {
        return i;
      }
    }
    return null;
  }

  /// Returns the appropriate border for each cell for a perfect 3x3 grid.
  Border _getCellBorder(int index) {
    int row = index ~/ 3;
    int col = index % 3;
    const borderColor = Colors.black54;
    BorderSide thin = const BorderSide(color: borderColor, width: 1);
    BorderSide none = BorderSide.none;

    return Border(
      left: col == 0 ? none : thin,
      top: row == 0 ? none : thin,
      right: col == 2 ? none : thin,
      bottom: row == 2 ? none : thin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorLightGrey = Colors.grey[200]!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
        centerTitle: true,
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status/result display
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  statusMessage,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: statusMessage.contains("wins")
                            ? const Color(0xFF1565C0)
                            : (statusMessage.contains("draw")
                                ? Color(0xFFFF7043)
                                : Colors.black87),
                      ),
                ),
              ),
              // Game board - Updated: consistent minimal grid with clear borders and tight layout
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    color: colorLightGrey,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      bool highlight = false;
                      if (winningLine != null &&
                          winPatterns[winningLine!].contains(i)) {
                        highlight = true;
                      }
                      return GestureDetector(
                        onTap: () => handleTap(i),
                        child: Container(
                          // Removed unnecessary margin for tight grid alignment
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: _getCellBorder(i),
                            borderRadius: BorderRadius.zero,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 135),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.zero,
                              border: highlight
                                  ? Border.all(
                                      color: const Color(0xFFFDD835),
                                      width: 4,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 170),
                                transitionBuilder: (child, anim) =>
                                    ScaleTransition(
                                  scale: anim,
                                  child: child,
                                ),
                                child: Text(
                                  playerSymbol(board[i]),
                                  key: ValueKey(board[i]),
                                  style: TextStyle(
                                    color: board[i] == Player.x
                                        ? const Color(0xFF1565C0)
                                        : board[i] == Player.o
                                            ? const Color(0xFFFF7043)
                                            : Colors.black54,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Restart button
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text("New Game"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDD835),
                    foregroundColor: Colors.black87,
                    elevation: 0,
                  ),
                  onPressed: newGame,
                ),
              ),
              // Credit footer
              const SizedBox(height: 18),
              const Text(
                "By Kavia AI \u2014 Minimal Design",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
