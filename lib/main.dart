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

double gridSize = 80;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Piece> _pieces = [
    Piece(label: '黄忠', width: 1, height: 2, x: 0, y: 0),
    Piece(label: '曹操', width: 2, height: 2, x: 1, y: 0),
    Piece(label: '张飞', width: 1, height: 2, x: 3, y: 0),
    Piece(label: '马超', width: 1, height: 2, x: 0, y: 2),
    Piece(label: '关羽', width: 2, height: 1, x: 1, y: 2),
    Piece(label: '赵云', width: 1, height: 2, x: 3, y: 2),
    Piece(label: '春', width: 1, height: 1, x: 1, y: 3),
    Piece(label: '夏', width: 1, height: 1, x: 2, y: 3),
    Piece(label: '秋', width: 1, height: 1, x: 0, y: 4),
    Piece(label: '冬', width: 1, height: 1, x: 3, y: 4),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    for (final p in _pieces) {
      children.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          left: p.x * gridSize,
          top: p.y * gridSize,
          child: BoardPiece(
            piece: p,
            onSwipeLeft: () => _move(p, -1, 0),
            onSwipeRight: () => _move(p, 1, 0),
            onSwipeUp: () => _move(p, 0, -1),
            onSwipeDown: () => _move(p, 0, 1),
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

  _move(Piece piece, int dx, int dy) {
    List<Position> occupied = [];
    for (final p in _pieces) {
      if (p.label == piece.label) {
        continue; // self
      }
      occupied.addAll(p.spots);
    }

    final destSpots = Piece.occupying(
      piece.x + dx,
      piece.y + dy,
      piece.width,
      piece.height,
    );

    print(
        'Trying to move ${piece.label} with spots ${piece.spots.join()} to $destSpots');

    final collision = destSpots.any(occupied.contains);

    if (collision) {
      print('collision');
      return;
    }

    setState(() {
      piece.x = piece.x + dx;
      piece.y = piece.y + dy;
    });
  }
}

class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is Position &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  String toString() => 'Position($x, $y)';
}

class Piece {
  final String label; // 曹
  final int width, height;
  int x, y;

  Piece({
    required this.label,
    required this.width,
    required this.height,
    required this.x,
    required this.y,
  });

  List<Position> get spots => occupying(x, y, width, height);

  static List<Position> occupying(int x, int y, int width, int height) {
    return [
      for (int i = 0; i < width; i++)
        for (int j = 0; j < height; j++) Position(x + i, y + j),
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
        width: piece.width * gridSize,
        height: piece.height * gridSize,
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                piece.label,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Opacity(
              opacity: 0.1,
              child: Text(
                '(${piece.x}, ${piece.y})\n'
                'width=${piece.width}\nheight=${piece.height}',
                style: Theme.of(context).textTheme.headline6,
              ),
            )
          ],
        ),
      ),
    );
  }
}
