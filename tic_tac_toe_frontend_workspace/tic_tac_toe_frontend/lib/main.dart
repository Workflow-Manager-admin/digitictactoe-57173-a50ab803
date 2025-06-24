import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({Key? key}) : super(key: key);

  // PUBLIC_INTERFACE
  /// Build the MaterialApp with a light blue background scaffold color for the theme.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1565C0),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFFDD835),
        ),
        scaffoldBackgroundColor: const Color(0xFFE3F2FD), // Light blue background
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TicTacToeHomePage(),
    );
  }
}

class TicTacToeHomePage extends StatefulWidget {
  const TicTacToeHomePage({Key? key}) : super(key: key);

  @override
  State<TicTacToeHomePage> createState() => _TicTacToeHomePageState();
}

class _TicTacToeHomePageState extends State<TicTacToeHomePage> {
  static const int boardSize = 3;
  List<List<String>> board = List.generate(boardSize, (_) => List.filled(boardSize, ''));
  bool xTurn = true;
  String resultMessage = '';
  bool gameOver = false;

  // PUBLIC_INTERFACE
  /// Resets the game board, turn, and results.
  void _resetGame() {
    setState(() {
      board = List.generate(boardSize, (_) => List.filled(boardSize, ''));
      xTurn = true;
      resultMessage = '';
      gameOver = false;
    });
  }

  // PUBLIC_INTERFACE
  /// Handles a tap on a board cell.
  void _handleTap(int i, int j) {
    if (board[i][j] == '' && !gameOver) {
      setState(() {
        board[i][j] = xTurn ? 'X' : 'O';
        if (_checkWinner(i, j)) {
          resultMessage = 'Player ${xTurn ? "X" : "O"} wins!';
          gameOver = true;
        } else if (_checkDraw()) {
          resultMessage = 'It\'s a draw!';
          gameOver = true;
        } else {
          xTurn = !xTurn;
        }
      });
    }
  }

  // PUBLIC_INTERFACE
  /// Checks if the most recent move resulted in a win.
  bool _checkWinner(int x, int y) {
    final player = board[x][y];

    // Check row
    if (board[x].every((cell) => cell == player)) return true;

    // Check column
    if (List.generate(boardSize, (i) => board[i][y]).every((cell) => cell == player)) return true;

    // Check diagonal
    if (x == y && List.generate(boardSize, (i) => board[i][i]).every((cell) => cell == player)) return true;

    // Check anti-diagonal
    if (x + y == boardSize - 1 &&
        List.generate(boardSize, (i) => board[i][boardSize - 1 - i]).every((cell) => cell == player)) {
      return true;
    }

    return false;
  }

  // PUBLIC_INTERFACE
  /// Checks if the game board is completely filled without a winner.
  bool _checkDraw() {
    for (var row in board) {
      if (row.contains('')) return false;
    }
    return true;
  }

  // PUBLIC_INTERFACE
  /// Builds the visual board grid UI.
  Widget _buildBoard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < boardSize; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int j = 0; j < boardSize; j++) _buildCell(i, j),
            ],
          ),
      ],
    );
  }

  // PUBLIC_INTERFACE
  /// Builds a single board cell as a tappable widget.
  Widget _buildCell(int i, int j) {
    return GestureDetector(
      onTap: () => _handleTap(i, j),
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFF1565C0),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            board[i][j],
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: board[i][j] == 'X'
                  ? const Color(0xFF1565C0)
                  : board[i][j] == 'O'
                      ? const Color(0xFFFDD835)
                      : Colors.transparent,
              shadows: [
                Shadow(
                  blurRadius: 6,
                  color: Colors.black.withAlpha((0.17 * 255).toInt()),
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // PUBLIC_INTERFACE
  /// Displays the current game status or result.
  Widget _buildStatus() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        resultMessage.isEmpty
            ? 'Turn: Player ${xTurn ? "X" : "O"}'
            : resultMessage,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1565C0),
          shadows: [
            Shadow(
              blurRadius: 3,
              color: Colors.black.withAlpha((0.12 * 255).toInt()),
              offset: const Offset(1, 1),
            ),
          ],
        ),
      ),
    );
  }

  // PUBLIC_INTERFACE
  /// Button to restart the game.
  Widget _buildRestartButton() {
    return ElevatedButton(
      onPressed: _resetGame,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 3,
      ),
      child: const Text('Restart Game'),
    );
  }

  // PUBLIC_INTERFACE
  /// Build method: wraps the body with the new light blue background, keeps controls visually clear.
  @override
  Widget build(BuildContext context) {
    // Scaffold inherits the theme's scaffoldBackgroundColor (light blue).
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // Main body area, center the content, leave implicit background as defined in theme.
      body: Center(
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatus(),
              _buildBoard(),
              const SizedBox(height: 24),
              _buildRestartButton(),
            ],
          ),
        ),
      ),
    );
  }
}
