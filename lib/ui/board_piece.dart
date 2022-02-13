import 'package:flutter/material.dart';
import 'board_config.dart';
import 'shiny_text.dart';
import '../game_state.dart';

class BoardPiece extends StatelessWidget {
  final Piece piece;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;

  const BoardPiece({
    Key? key,
    required this.piece,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onSwipeDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;

    return GestureDetector(
      onHorizontalDragEnd: (_) {
        final v = _.primaryVelocity;
        if (v != null) {
          v > 0 ? onSwipeRight?.call() : onSwipeLeft?.call();
        }
      },
      onVerticalDragEnd: (_) {
        final v = _.primaryVelocity;
        if (v != null) {
          v > 0 ? onSwipeDown?.call() : onSwipeUp?.call();
        }
      },
      child: Container(
        width: unitSize * 0.99 + (piece.width - 1) * unitSize,
        height: unitSize * 0.99 + (piece.height - 1) * unitSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: piece.id == 0
                ? [
                    BoardConfig.of(context).corePieceColor1,
                    BoardConfig.of(context).corePieceColor2,
                  ]
                : [
                    BoardConfig.of(context).pieceColor1,
                    BoardConfig.of(context).pieceColor2,
                  ],
          ),
          borderRadius: BorderRadius.circular(unitSize * 0.04),
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
    final unitSize = BoardConfig.of(context).unitSize;

    final decoration = DecoratedBox(
      decoration: BoxDecoration(
        color: BoardConfig.of(context).pieceAttachmentColor,
        borderRadius: BorderRadius.circular(unitSize * 0.04),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: unitSize * -0.1,
          right: unitSize * 0.1,
          child: SizedBox(
            width: piece.width * unitSize * 0.8,
            height: piece.height * unitSize * 0.2,
            child: decoration,
          ),
        ),
        Positioned(
          top: unitSize * 0.1,
          right: unitSize * -0.1,
          child: SizedBox(
            width: piece.width * unitSize * 0.2,
            height: piece.height * unitSize * 0.8,
            child: decoration,
          ),
        ),
        SizedBox(
          width: piece.width * unitSize * 0.99,
          height: piece.height * unitSize * 0.99,
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
    final unitSize = BoardConfig.of(context).unitSize;
    return Container(
      width: piece.width * unitSize * 0.99,
      height: unitSize * 1.05 + (piece.height - 1) * unitSize,
      decoration: BoxDecoration(
        color: BoardConfig.of(context).pieceShadowColor,
        borderRadius: BorderRadius.circular(unitSize * 0.04),
      ),
    );
  }
}
