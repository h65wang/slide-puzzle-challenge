import 'package:flutter/material.dart';

import 'game_state.dart';

double gridSize = 80;

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final GameState _gameState = GameState.level1();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: gridSize * _gameState.boardSize.x,
          height: gridSize * _gameState.boardSize.y,
          color: Colors.grey.shade200.withOpacity(0.5),
        ),
        for (final p in _gameState.pieces)
          _buildAnimatedPositioned(
            piece: p,
            child: BoardPieceShadow(piece: p),
          ),
        for (final p in _gameState.pieces)
          _buildAnimatedPositioned(
            piece: p,
            child: BoardPieceAttachment(piece: p),
          ),
        for (final p in _gameState.pieces)
          _buildAnimatedPositioned(
            piece: p,
            child: BoardPiece(
              piece: p,
              onSwipeLeft: () => setState(() => _gameState.move(p, -1, 0)),
              onSwipeRight: () => setState(() => _gameState.move(p, 1, 0)),
              onSwipeUp: () => setState(() => _gameState.move(p, 0, -1)),
              onSwipeDown: () => setState(() => _gameState.move(p, 0, 1)),
            ),
          ),
        ..._buildBorders(),
      ],
    );
  }

  Widget _buildAnimatedPositioned({required Piece piece, required child}) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      left: piece.x * gridSize,
      top: piece.y * gridSize,
      child: child,
    );
  }

  List<Widget> _buildBorders() {
    const child = ColoredBox(
      color: Colors.black,
    );
    return [
      Positioned(
        top: 0,
        bottom: 0,
        left: gridSize * -0.1,
        width: gridSize * 0.1,
        child: child,
      ),
      Positioned(
        top: 0,
        bottom: 0,
        right: gridSize * -0.1,
        width: gridSize * 0.1,
        child: child,
      ),
      Positioned(
        top: gridSize * -0.1,
        height: gridSize * 0.1,
        left: gridSize * -0.1,
        right: gridSize * -0.1,
        child: child,
      ),
      Positioned(
        bottom: gridSize * -0.1,
        height: gridSize * 0.1,
        left: gridSize * -0.1,
        width: gridSize * 1.1,
        child: child,
      ),
      Positioned(
        bottom: gridSize * -0.1,
        height: gridSize * 0.1,
        right: gridSize * -0.1,
        width: gridSize * 1.1,
        child: child,
      ),
    ];
  }
}

class BoardPiece extends StatelessWidget {
  final Piece piece;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeUp;
  final VoidCallback onSwipeDown;

  const BoardPiece({
    Key? key,
    required this.piece,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onSwipeUp,
    required this.onSwipeDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (_) {
        final v = _.primaryVelocity;
        if (v != null) {
          v > 0 ? onSwipeRight() : onSwipeLeft();
        }
      },
      onVerticalDragEnd: (_) {
        final v = _.primaryVelocity;
        if (v != null) {
          v > 0 ? onSwipeDown() : onSwipeUp();
        }
      },
      child: Container(
        width: gridSize * 0.99 + (piece.width - 1) * gridSize,
        height: gridSize * 0.99 + (piece.height - 1) * gridSize,
        decoration: BoxDecoration(
          color: piece.color.shade300,
          border: Border.all(
            color: piece.color.shade200,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            piece.label,
            style: TextStyle(
              fontSize: gridSize * 0.3,
              color: piece.color.shade900,
              shadows: [
                Shadow(
                  color: piece.color.shade100,
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BoardPieceAttachment extends StatelessWidget {
  final Piece piece;

  const BoardPieceAttachment({
    Key? key,
    required this.piece,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final decoration = DecoratedBox(
      decoration: BoxDecoration(
        color: piece.color.shade300,
        borderRadius: BorderRadius.circular(gridSize * 0.04),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: gridSize * -0.1,
          right: gridSize * 0.1,
          child: SizedBox(
            width: piece.width * gridSize * 0.8,
            height: piece.height * gridSize * 0.2,
            child: decoration,
          ),
        ),
        Positioned(
          top: gridSize * 0.1,
          right: gridSize * -0.1,
          child: SizedBox(
            width: piece.width * gridSize * 0.2,
            height: piece.height * gridSize * 0.8,
            child: decoration,
          ),
        ),
        SizedBox(
          width: piece.width * gridSize * 0.99,
          height: piece.height * gridSize * 0.99,
        ),
      ],
    );
  }
}

class BoardPieceShadow extends StatelessWidget {
  final Piece piece;

  const BoardPieceShadow({
    Key? key,
    required this.piece,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: piece.width * gridSize * 0.99,
      height: gridSize * 1.05 + (piece.height - 1) * gridSize,
      decoration: BoxDecoration(
        color: piece.color.shade800,
        borderRadius: BorderRadius.circular(gridSize * 0.04),
      ),
    );
  }
}
