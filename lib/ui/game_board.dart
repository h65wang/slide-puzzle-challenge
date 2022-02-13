import 'package:flutter/material.dart';

import '../game_state.dart';
import 'board_decoration.dart';
import 'board_config.dart';
import 'board_piece.dart';

class GameBoard extends StatefulWidget {
  final GameState gameState;
  final VoidCallback onWin;

  const GameBoard({Key? key, required this.gameState, required this.onWin})
      : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard>
    with SingleTickerProviderStateMixin {
  late final GameState _gameState = widget.gameState;

  final GlobalKey _globalKey = GlobalKey();
  bool hasWon = false;

  Duration _slidingSpeed = Duration.zero;

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;

    // Every game piece inside the game board.
    final boardPieces = Stack(
      // Use a `GlobalKey` to keep widget state during level-ending animation
      key: _globalKey,
      // Do not clip, because pieces need to fly out when level ends
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: unitSize * _gameState.boardSize.x,
          height: unitSize * _gameState.boardSize.y,
        ),
        for (final p in _gameState.pieces)
          _buildAnimatedPositioned(
            left: p.x * unitSize,
            top: p.y * unitSize,
            child: BoardPieceShadow(piece: p),
          ),
        for (final p in _gameState.pieces)
          _buildAnimatedPositioned(
            left: p.x * unitSize,
            top: p.y * unitSize,
            child: BoardPieceAttachment(piece: p),
          ),
        for (final p in _gameState.pieces)
          _buildAnimatedPositioned(
            left: p.x * unitSize,
            top: p.y * unitSize,
            child: BoardPiece(
              piece: p,
              onSwipeLeft: () => _move(p, -1, 0),
              onSwipeRight: () => _move(p, 1, 0),
              onSwipeUp: () => _move(p, 0, -1),
              onSwipeDown: () => _move(p, 0, 1),
            ),
          ),
      ],
    );

    if (hasWon) {
      return boardPieces;
    } else {
      return BoardDecoration(child: boardPieces);
    }
  }

  Widget _buildAnimatedPositioned({
    required double left,
    required double top,
    required child,
  }) =>
      AnimatedPositioned(
        duration: _slidingSpeed,
        curve: Curves.easeOut,
        left: left,
        top: top,
        child: child,
      );

  _move(Piece piece, int dx, int dy) async {
    if (!_gameState.canMove(piece, dx, dy)) return;

    final duration = BoardConfig.of(context).slideDuration;

    _slidingSpeed = duration; // set a moving speed
    setState(() {
      // let the piece move
      piece.x += dx;
      piece.y += dy;
    });
    await Future.delayed(duration); // wait for sliding animation to complete

    if (_gameState.hasWon()) {
      // Level ending animation: set every other pieces (except the core piece)
      // backwards, and set the core piece slightly backwards too.
      _gameState.pieces.where((p) => p.id != 0).forEach((p) => p.y -= 18);
      _gameState.pieces.singleWhere((p) => p.id == 0).y -= 2;
      // Notify the user that he has won.
      widget.onWin();
      setState(() => hasWon = true);
      await Future.delayed(duration); // wait for level-ending animation
    }
    // Reset the `Duration` of `AnimatedPositioned` when no pieces are moving.
    // This is to avoid implicit animations from triggering when users resize
    // the app window.
    _slidingSpeed = Duration.zero;
  }
}
