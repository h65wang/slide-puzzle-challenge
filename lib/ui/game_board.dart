import 'dart:ui';

import 'package:flutter/material.dart';

import '../game_state.dart';
import 'beam_transition.dart';
import 'board_config.dart';
import 'board_piece.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard>
    with SingleTickerProviderStateMixin {
  final GameState _gameState = GameState.level1();

  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  Widget build(BuildContext context) {
    final gridSize = BoardConfig.of(context).gridSize;
    final edgePadding = BoardConfig.of(context).edgePadding;

    final game = SizedBox(
      width: gridSize * _gameState.boardSize.x + edgePadding * 2,
      height: gridSize * _gameState.boardSize.y + edgePadding * 2,
      child: ClipRect(
        // help to enforce clipping when app window (web browser) is resized
        child: Padding(
          padding: EdgeInsets.all(edgePadding),
          child: Stack(
            clipBehavior: Clip.none, // already clipped using `ClipRect`
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
                    onSwipeLeft: () =>
                        setState(() => _gameState.move(p, -1, 0)),
                    onSwipeRight: () =>
                        setState(() => _gameState.move(p, 1, 0)),
                    onSwipeUp: () => setState(() => _gameState.move(p, 0, -1)),
                    onSwipeDown: () => setState(() => _gameState.move(p, 0, 1)),
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
                color: const Color(0xff2d6665),
                width: 8,
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
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      left: piece.x * gridSize,
      top: piece.y * gridSize,
      child: child,
    );
  }
}
