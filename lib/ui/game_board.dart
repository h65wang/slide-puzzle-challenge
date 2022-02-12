import 'dart:ui';

import 'package:flutter/material.dart';

import '../game_state.dart';
import 'beam_transition.dart';
import 'board_config.dart';
import 'board_piece.dart';

class GameBoard extends StatefulWidget {
  static const animationSpeed = Duration(milliseconds: 500);
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
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gridSize = BoardConfig.of(context).gridSize;
    final edgePadding = BoardConfig.of(context).edgePadding;

    final game = SizedBox(
      width: gridSize * _gameState.boardSize.x + edgePadding * 2,
      height: gridSize * _gameState.boardSize.y + edgePadding * 2,
      child: ClipPath(
        clipper: TallRectClipper(),
        // help to enforce clipping when app window (web browser) is resized
        child: Padding(
          padding: EdgeInsets.all(edgePadding),
          child: Stack(
            clipBehavior: Clip.none, // already clipped using `ClipPath`
            children: [
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
                    onSwipeLeft: () => setState(() => _move(p, -1, 0)),
                    onSwipeRight: () => setState(() => _move(p, 1, 0)),
                    onSwipeUp: () => setState(() => _move(p, 0, -1)),
                    onSwipeDown: () => setState(() => _move(p, 0, 1)),
                  ),
                ),
              Positioned(
                left: gridSize,
                right: gridSize,
                top: gridSize * 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < 3; i++)
                      Icon(
                        Icons.arrow_drop_down,
                        size: 18,
                        color: Color(0xff43adad),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: BeamTransition(
          animation: _controller,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0x5f2d6665),
                width: 16,
              ),
            ),
            child: game,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedPositioned({required Piece piece, required child}) {
    final gridSize = BoardConfig.of(context).gridSize;

    return AnimatedPositioned(
      duration: GameBoard.animationSpeed,
      curve: Curves.easeOut,
      left: piece.x * gridSize,
      top: piece.y * gridSize,
      child: child,
    );
  }

  _move(Piece piece, int dx, int dy) {
    _gameState.move(piece, dx, dy);
    final won = _gameState.checkWinCondition();
    if (won) {
      final core = _gameState.pieces.singleWhere((p) => p.id == 0);
      // core.y += 2;
      widget.onWin();
    }
  }
}

/// This is to clip pieces (and their attachments and shadows) to be within
/// the game board, except the bottom (so the core piece can escape).
class TallRectClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    return Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, size.height * 2)
      ..lineTo(size.width, size.height * 2)
      ..lineTo(size.width, 0.0)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}
