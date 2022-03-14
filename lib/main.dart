import 'dart:math';

import 'package:flutter/material.dart';

import 'level_transition/level_end_transition.dart';
import 'data/board_config.dart';
import 'backdrop/backdrop_paint.dart';
import 'puzzle/puzzle_level.dart';
import 'tutorial/tutorial_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Slide Puzzle: Escape of Cao Cao',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Controls the backdrop painter to trigger color change.
  late final _backdropController = BackdropController();

  // Controls the level entrance animation.
  late final _levelBeginController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  // Controls the level exit animation.
  late final _levelEndController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  // The current level being played, with 0 being the tutorial.
  int _currentLevel = 0;

  // Whether the user has chosen to hide decorative texts on puzzle pieces.
  // This is provided as an option in the tutorial dialog, for devices that
  // do not have necessary fonts installed to correctly display these texts.
  bool _hideTexts = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // Calculate unit size: side-length (in logic pixels) of a 1x1 tile.
    final unitSize = min(screenSize.width / 6, screenSize.height / 8);
    return Scaffold(
      body: BoardConfig(
        unitSize: unitSize,
        hideTexts: _hideTexts,
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
                onDismiss: (bool hideTexts) {
                  setState(() => _hideTexts = hideTexts);
                  _advanceToNextLevel();
                },
              ),
            if (_currentLevel > 0)
              Center(
                child: ScaleTransition(
                  scale: CurveTween(curve: Curves.easeOut)
                      .animate(_levelBeginController),
                  child: LevelEndTransition(
                    animation: _levelEndController,
                    child: PuzzleLevel(
                      // A single level of the puzzle.
                      key: ValueKey(_currentLevel),
                      level: _currentLevel,
                      onWin: _onLevelCompleted,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _advanceToNextLevel() {
    _levelBeginController.forward(from: 0.0);
    setState(() => _currentLevel++);
  }

  void _onLevelCompleted(int level, int steps) async {
    // Make the background colorful.
    _backdropController.celebrate();
    // Play animation: game board falling down and 3D piece spinning.
    await _levelEndController.forward();
    // Take a short break at the empty screen.
    await Future.delayed(const Duration(milliseconds: 300));
    // Reset the animation controller for the next time.
    _levelEndController.reset();
    // Continue on to the next level.
    _advanceToNextLevel();
  }
}
