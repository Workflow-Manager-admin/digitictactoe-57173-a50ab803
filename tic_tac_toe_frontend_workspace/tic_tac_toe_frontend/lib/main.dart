import 'package:flutter/material.dart';

// Color palette (light theme)
const Color kPrimaryColor = Color(0xFF1565C0);
const Color kSecondaryColor = Color(0xFFFDD835);
const Color kAccentColor = Color(0xFFFF7043);
const Color kGridLineColor = Color(0xFFB0BEC5); // subtle gray for grid
const Color kBackgroundColor = Color(0xFFF8FAFB);

void main() {
  runApp(const TicTacToeApp());
}

/// The root widget of the Tic Tac Toe Flutter application.
/// Displays a centered game board, game status/result, and controls.
class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
          error: kAccentColor,
          surface: kBackgroundColor,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: kPrimaryColor,
          ),
        ),
        scaffoldBackgroundColor: kBackgroundColor,
        buttonTheme: ButtonThemeData(
          buttonColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const TicTacToeHomePage(),
    );
  }
}

/// The home page which keeps all game logic/state and provides the UI structure.
class TicTacToeHomePage extends StatefulWidget {
  const TicTacToeHomePage({super.key});

  @override
  State<TicTacToeHomePage> createState() => _TicTacToeHomePageState();
}

enum Player { X, O }

enum GameState { playing, draw, win }

class _TicTacToeHomePageState extends State<TicTacToeHomePage> {
  static const int _boardSize = 3;
  static const double _boardPadding = 20.0;
  static const double _cellSpacing = 8.0;

  List<List<Player?>> _board = List.generate(3, (_) => List.filled(3, null));
  Player _currentPlayer = Player.X;
  GameState _gameState = GameState.playing;
  Player? _winner;

  /// Resets the entire board for a new game.
  // PUBLIC_INTERFACE
  void _restartGame() {
    setState(() {
      _board = List.generate(_boardSize, (_) => List.filled(_boardSize, null));
      _currentPlayer = Player.X;
      _gameState = GameState.playing;
      _winner = null;
    });
  }

  /// Handles a player tapping a cell to make a move.
  void _handleMove(int row, int col) {
    if (_board[row][col] != null || _gameState != GameState.playing) {
      return;
    }
    setState(() {
      _board[row][col] = _currentPlayer;
      if (_checkWin(_currentPlayer)) {
        _gameState = GameState.win;
        _winner = _currentPlayer;
      } else if (_board.every((rowList) => rowList.every((cell) => cell != null))) {
        _gameState = GameState.draw;
        _winner = null;
      } else {
        _currentPlayer = _currentPlayer == Player.X ? Player.O : Player.X;
      }
    });
  }

  /// Checks whether the current player has won the game.
  bool _checkWin(Player player) {
    // Rows & Columns
    for (int i = 0; i < _boardSize; i++) {
      // Rows
      if (_board[i].every((cell) => cell == player)) return true;
      // Columns
      if (_board.every((row) => row[i] == player)) return true;
    }
    // Diagonals
    if (List.generate(_boardSize, (i) => _board[i][i]).every((cell) => cell == player)) {
      return true;
    }
    if (List.generate(_boardSize, (i) => _board[i][_boardSize - 1 - i]).every((cell) => cell == player)) {
      return true;
    }
    return false;
  }

  String get _statusMessage {
    switch (_gameState) {
      case GameState.playing:
        return "Player ${_currentPlayer == Player.X ? "X" : "O"}'s turn";
      case GameState.win:
        return "Player ${_winner == Player.X ? "X" : "O"} wins!";
      case GameState.draw:
        return "It's a draw!";
    }
  }

  /// UI builder for each cell in the Tic Tac Toe board
  Widget _buildCell(int row, int col) {
    final Player? cellValue = _board[row][col];
    return InkWell(
      onTap: () => _handleMove(row, col),
      borderRadius: BorderRadius.circular(10),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: cellValue == null
              ? const SizedBox.shrink()
              : Text(
                  cellValue == Player.X ? "X" : "O",
                  key: ValueKey(cellValue),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 44,
                    color: cellValue == Player.X ? kPrimaryColor : kAccentColor,
                  ),
                ),
        ),
      ),
    );
  }

  /// UI: Main build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        title: const Text(
          'Tic Tac Toe',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _boardPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Game status/result
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _statusMessage,
                      key: ValueKey(_statusMessage),
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: _gameState == GameState.win
                            ? kAccentColor
                            : ( _gameState == GameState.draw ? kSecondaryColor : kPrimaryColor),
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),

                // Game Board (Centered)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Table(
                      border: TableBorder.symmetric(
                        inside: BorderSide(
                          color: kGridLineColor,
                          width: 2.2,
                        ),
                      ),
                      children: List.generate(
                        _boardSize,
                        (row) => TableRow(
                          children: List.generate(
                            _boardSize,
                            (col) => TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(_cellSpacing),
                                child: _buildCell(row, col),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Spacing below board
                const SizedBox(height: 30),

                // New/Restart button (always visible)
                SizedBox(
                  width: 160,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _restartGame,
                    style: ElevatedButton.styleFrom(
                      // Use outlined style for minimalism
                      backgroundColor: Colors.white,
                      foregroundColor: kPrimaryColor,
                      side: const BorderSide(color: kPrimaryColor, width: 1.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _gameState == GameState.playing ? "Restart" : "New Game",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Minimalist footer (optional)
                const Text(
                  'A minimal Tic Tac Toe game',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: kGridLineColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
