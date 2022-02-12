import 'package:flutter/material.dart';
import 'package:slide_puzzle/ui/matrix_backdrop.dart';

import 'game_state.dart';
import 'ui/board_config.dart';
import 'ui/game_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slide Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
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
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  )..forward(from: 0.0);

  final _levels = [
    GameState.level1(),
    GameState.level2(),
    GameState.level3(),
  ];

  int _levelIndex = 0;

  @override
  Widget build(BuildContext context) {
    final shortEdge = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      body: BoardConfig(
        edgePadding: 2,
        gridSize: shortEdge / 6,
        child: Stack(
          key: ValueKey(_levelIndex),
          children: [
            const RepaintBoundary(
              child: MatrixBackdrop(),
            ),
            ScaleTransition(
              scale: _controller,
              child: SizeTransition(
                // turns: Tween(begin: 0.0, end: 2.0).animate(_controller),
                sizeFactor: _controller,
                child: Center(
                  child: GameBoard(
                    gameState: _levels[_levelIndex % _levels.length],
                    onWin: () async {
                      await Future.delayed(const Duration(milliseconds: 500));
                      _controller.reverse();
                      await Future.delayed(const Duration(milliseconds: 500));
                      setState(() {
                        _levelIndex++;
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
