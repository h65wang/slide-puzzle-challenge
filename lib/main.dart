import 'package:flutter/material.dart';

import 'game_state.dart';

void main() {
  runApp(const MyApp());
}

double gridSize = 80;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GameState _gameState = GameState.level1();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slide Puzzle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Stack(
          children: [
            for (final p in _gameState.pieces)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: p.x * gridSize,
                top: p.y * gridSize,
                child: BoardPieceAttachment(
                  piece: p,
                ),
              ),
            for (final p in _gameState.pieces)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: p.x * gridSize,
                top: p.y * gridSize,
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
      ),
    );
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
        width: piece.width * gridSize,
        height: piece.height * gridSize,
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
        border: Border.all(color: piece.color.shade200, width: 1),
        borderRadius: BorderRadius.circular(4),
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
          width: piece.width * gridSize,
          height: piece.height * gridSize,
        ),
      ],
    );
  }
}
