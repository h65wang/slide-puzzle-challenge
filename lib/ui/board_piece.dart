import 'package:flutter/material.dart';
import 'shiny_text.dart';
import '../game_state.dart';

double gridSize = 80;

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
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff357070),
              Color(0xff1f5754),
            ],
          ),
          border: Border.all(
            color: const Color(0xff8ef8fe),
            width: gridSize * 0.005,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(child: ShinyText(label: piece.label)),
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
        color: const Color(0xff1b4d4a),
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
        color: const Color(0xff1e3e40),
        borderRadius: BorderRadius.circular(gridSize * 0.04),
      ),
    );
  }
}
