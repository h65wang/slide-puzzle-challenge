import 'package:flutter/material.dart';
import 'package:slide_puzzle/MatrixBackdrop.dart';

import 'game_board.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: const Text('Slide Puzzle'),
      ),
      body: Stack(
        children: [
          Image.network(
            'https://cdn.wallpapersafari.com/84/1/Ufhvua.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          RepaintBoundary(
            child: const MatrixBackdrop(),
          ),
          const Align(
            alignment: Alignment(0, -0.5),
            child: GameBoard(),
          ),
        ],
      ),
    );
  }
}
