import 'dart:math';

import 'package:flutter/material.dart';

import 'game_state.dart';
import 'ui/backdrop_paint.dart';
import 'ui/board_config.dart';
import 'ui/game_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Slide Puzzle',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Controls the level-transition animation.
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  )..forward(from: 0.0);

  int _currentLevel = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final unitSize = min(screenSize.width / 6, screenSize.height / 8);

    return Scaffold(
      body: BoardConfig(
        unitSize: unitSize,
        child: Stack(
          key: ValueKey(_currentLevel),
          children: [
            const RepaintBoundary(
              child: BackdropPaint(),
            ),
            ScaleTransition(
              scale: _controller,
              child: SizeTransition(
                sizeFactor: _controller,
                child: Center(
                  child: GameBoard(
                    gameState: GameState.level(_currentLevel),
                    onWin: () async {
                      await Future.delayed(const Duration(milliseconds: 1000));
                      _controller.reverse();
                      await Future.delayed(const Duration(milliseconds: 300));
                      setState(() {
                        _currentLevel++;
                      });
                      _controller.forward();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
