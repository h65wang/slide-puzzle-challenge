import 'dart:ui';

import 'package:flutter/material.dart';

import '../game_state.dart';
import 'board_piece.dart';

double gridSize = 80;

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
    final game = SizedBox(
      width: gridSize * _gameState.boardSize.x,
      height: gridSize * _gameState.boardSize.y,
      child: Stack(
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
                onSwipeLeft: () => setState(() => _gameState.move(p, -1, 0)),
                onSwipeRight: () => setState(() => _gameState.move(p, 1, 0)),
                onSwipeUp: () => setState(() => _gameState.move(p, 0, -1)),
                onSwipeDown: () => setState(() => _gameState.move(p, 0, 1)),
              ),
            ),
        ],
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xffdcdcb2),
            width: 4,
          ),
        ),
        // color: Colors.yellow,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.white.withOpacity(0.1),
                width: gridSize * _gameState.boardSize.x,
                height: gridSize * _gameState.boardSize.y,
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                final v = CurveTween(curve: Curves.easeOutBack)
                    .transform(_controller.value);
                return ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment(0.8, -0.5 + v * 0.1),
                      end: const Alignment(-1, 0.5),
                      colors: [
                        Colors.transparent,
                        ColorTween(
                          begin: const Color(0x5fffff00),
                          end: const Color(0x6fffff00),
                        ).transform(v)!,
                        ColorTween(
                          begin: const Color(0x86ffff00),
                          end: const Color(0x94ffff00),
                        ).transform(v)!,
                        ColorTween(
                          begin: const Color(0x4fffff00),
                          end: const Color(0x3fffff00),
                        ).transform(v)!,
                        Colors.transparent,
                      ],
                      stops: [
                        0,
                        0.4 + v * 0.04,
                        0.5 + v * -0.02,
                        0.6 + v * 0.03,
                        1.0,
                      ],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.softLight,
                  // blendMode: BlendMode.lighten,
                  child: child,
                );
              },
              child: game,
            ),
          ],
        ),
      ),
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
}
