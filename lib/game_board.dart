import 'dart:ui';

import 'package:flutter/material.dart';

import 'game_state.dart';

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
    duration: const Duration(seconds: 1),
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

    return ClipRect(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: SizedBox(
              width: gridSize * _gameState.boardSize.x,
              height: gridSize * _gameState.boardSize.y,
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              final v = CurveTween(curve: Curves.slowMiddle)
                  .transform(_controller.value);
              return ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: const Alignment(0.8, -0.5),
                    end: const Alignment(-1, 0.5),
                    colors: [
                      Colors.transparent,
                      ColorTween(
                        begin: Color(0x5fffff00),
                        end: Color(0x6fffff00),
                      ).transform(v)!,
                      ColorTween(
                        begin: Color(0x76ffff00),
                        end: Color(0x94ffff00),
                      ).transform(v)!,
                      ColorTween(
                        begin: Color(0x4fffff00),
                        end: Color(0x3fffff00),
                      ).transform(v)!,
                      Colors.transparent,
                    ],
                    stops: [
                      0,
                      0.4 + v * 0.02,
                      0.5 + v * -0.02,
                      0.6 + v * 0.02,
                      1.0,
                    ],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.hardLight,
                child: child,
              );
            },
            child: game,
          ),
          ..._buildBorders(),
        ],
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

  List<Widget> _buildBorders() {
    const child = ColoredBox(
      color: Color(0xfff2e7d3),
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
        child: Center(
          child: Text(
            piece.label,
            style: TextStyle(
              fontSize: gridSize * 0.4,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.red,
                  ],
                ).createShader(
                  Rect.fromLTWH(0, 0, gridSize * 5, gridSize * 5),
                )
                ..style = PaintingStyle.fill
                ..strokeWidth = 5
                ..color = Colors.white,
            ),
            textAlign: TextAlign.center,
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
        color: Color(0xff193e3d),
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
