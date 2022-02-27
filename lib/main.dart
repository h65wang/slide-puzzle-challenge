import 'dart:math';

import 'package:flutter/material.dart';

import 'ui/board_config.dart';
import 'ui/backdrop_paint.dart';
import 'ui/puzzle_level.dart';
import 'ui/tutorial_dialog.dart';

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
  late final _animationController = AnimationController(
    vsync: this,
    duration: levelTransitionDuration,
  )..forward(from: 0.0);

  late final _backdropController = BackdropController();

  int _currentLevel = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final unitSize = min(screenSize.width / 6, screenSize.height / 8);

    return Scaffold(
      body: BoardConfig(
        unitSize: unitSize,
        child: Stack(
          children: [
            // Background: a custom painter wrapped in a repaint boundary
            // because the rest of the app usually updates at different times.
            RepaintBoundary(
              child: BackdropPaint(
                controller: _backdropController,
              ),
            ),
            if (_currentLevel == 0)
              TutorialDialog(
                onDismiss: () {
                  setState(() {
                    _currentLevel = 1;
                    _backdropController.celebrate();
                  });
                },
              ),
            // A single level of the puzzle, wrapped in some animation widgets
            // used for transitioning between levels.
            if (_currentLevel > 0)
              ScaleTransition(
                scale: _animationController,
                child: SizeTransition(
                  sizeFactor: _animationController,
                  child: Center(
                    child: PuzzleLevel(
                      key: ValueKey(_currentLevel),
                      level: _currentLevel,
                      onWin: _advanceToNextLevel,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _advanceToNextLevel() async {
    await Future.delayed(levelTransitionDuration);
    _backdropController.celebrate();
    _animationController.reverse();
    await Future.delayed(levelTransitionDuration);
    setState(() => _currentLevel++);
    _animationController.forward();
  }
}
