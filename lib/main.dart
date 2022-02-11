import 'package:flutter/material.dart';
import 'package:slide_puzzle/ui/matrix_backdrop.dart';

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

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shortEdge = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      body: BoardConfig(
        edgePadding: 2,
        gridSize: shortEdge / 6,
        child: Stack(
          children: const [
            RepaintBoundary(
              child: MatrixBackdrop(),
            ),
            Align(
              alignment: Alignment(0, 0),
              child: GameBoard(),
            ),
          ],
        ),
      ),
    );
  }
}
