import 'dart:math';

import 'package:flutter/material.dart';

import 'ui/board_config.dart';
import 'ui/backdrop_paint.dart';
import 'ui/puzzle_level.dart';

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
  static const levelTransitionDuration = Duration(milliseconds: 300);

  // Controls the level-transition animation.
  late final _controller = AnimationController(
    vsync: this,
    duration: levelTransitionDuration,
  )..forward(from: 0.0);

  int _currentLevel = 1;

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
            // Background: a custom painter wrapped in a repaint boundary
            // because the rest of the app usually updates at different times.
            const RepaintBoundary(
              child: BackdropPaint(),
            ),
            // A single level of the puzzle, wrapped in some animation widgets
            // used for transitioning between levels.
            ScaleTransition(
              scale: _controller,
              child: SizeTransition(
                sizeFactor: _controller,
                child: Center(
                  child: PuzzleLevel(
                    level: _currentLevel,
                    onWin: () async {
                      await Future.delayed(levelTransitionDuration);
                      _controller.reverse();
                      await Future.delayed(levelTransitionDuration);
                      setState(() => _currentLevel++);
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
