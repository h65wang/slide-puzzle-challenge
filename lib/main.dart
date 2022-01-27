import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
  final Map<int, Offset> _gameState = {
    1: const Offset(0.0, 0.0),
    2: const Offset(1.0, 0.0),
    3: const Offset(2.0, 0.0),
    4: const Offset(0.0, 1.0),
    5: const Offset(1.0, 1.0),
    6: const Offset(2.0, 1.0),
    7: const Offset(0.0, 2.0),
    8: const Offset(1.0, 2.0),
  };

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    for (int i = 1; i < 9; i++) {
      final Offset offset = _gameState[i]! * 100;
      children.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          left: offset.dx,
          top: offset.dy,
          child: Piece(
            index: i,
            onSwipeLeft: () => _move(i, const Offset(-1, 0)),
            onSwipeRight: () => _move(i, const Offset(1, 0)),
            onSwipeUp: () => _move(i, const Offset(0, -1)),
            onSwipeDown: () => _move(i, const Offset(0, 1)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Slide Puzzle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Stack(
          children: children,
        ),
      ),
    );
  }

  _move(int index, Offset offset) {
    final destination = _gameState[index]! + offset;

    print('Trying to move $index to $destination');

    for (final o in _gameState.values) {
      if (o == destination) {
        // setState(() {
        //   _gameState[index] = _gameState[index]! + offset / 4;
        //   Future.delayed(const Duration(milliseconds: 100), () {
        //     setState(() {
        //       _gameState[index] = _gameState[index]! - offset / 4;
        //     });
        //   });
        // });
        return;
      }
    }

    if (destination.dx < 0 || destination.dx > 2) return;
    if (destination.dy < 0 || destination.dy > 2) return;

    setState(() => _gameState[index] = destination);
  }
}

class Piece extends StatelessWidget {
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeUp;
  final VoidCallback onSwipeDown;

  const Piece({
    Key? key,
    required this.index,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onSwipeUp,
    required this.onSwipeDown,
  }) : super(key: key);

  final int index;

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
        width: 100,
        height: 100,
        color: Colors.blue[index * 100],
        child: Center(
          child: Text(
            '$index',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      ),
    );
  }
}
