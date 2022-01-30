import 'package:flutter/material.dart';

class GameState {
  final List<Piece> pieces;
  final Pair boardSize;

  GameState.level0()
      : boardSize = const Pair(4, 5),
        pieces = [
          Piece(1, label: '黄忠', width: 1, height: 2, x: 0, y: 0),
          Piece(2, label: '曹操', width: 2, height: 2, x: 2, y: 0),
          Piece(5, label: '关羽', width: 2, height: 1, x: 1, y: 3),
          Piece(9, label: '秋', width: 1, height: 1, x: 0, y: 4),
          Piece(10, label: '冬', width: 1, height: 1, x: 3, y: 4),
        ];

  GameState.level1()
      : boardSize = const Pair(4, 5),
        pieces = [
          Piece(1, label: '黄忠', width: 1, height: 2, x: 0, y: 0),
          Piece(2, label: '曹操', width: 2, height: 2, x: 1, y: 0),
          Piece(3, label: '张飞', width: 1, height: 2, x: 3, y: 0),
          Piece(4, label: '马超', width: 1, height: 2, x: 0, y: 2),
          Piece(5, label: '关羽', width: 2, height: 1, x: 1, y: 2),
          Piece(6, label: '赵云', width: 1, height: 2, x: 3, y: 2),
          Piece(7, label: '春', width: 1, height: 1, x: 1, y: 3),
          Piece(8, label: '夏', width: 1, height: 1, x: 2, y: 3),
          Piece(9, label: '秋', width: 1, height: 1, x: 0, y: 4),
          Piece(10, label: '冬', width: 1, height: 1, x: 3, y: 4),
        ];

  move(Piece piece, int dx, int dy) {
    final destX = piece.x + dx;
    final destY = piece.y + dy;

    print('Trying to move ${piece.label} to ($destX, $destY).');

    // Make sure it's within the bounds of the board.
    if (destX < 0 ||
        destX >= boardSize.x ||
        destY < 0 ||
        destY >= boardSize.y) {
      return;
    }

    // Make sure no other pieces are in the way.
    final dest = Piece.occupying(
      destX,
      destY,
      piece.width,
      piece.height,
    );

    List<Pair> others = pieces
        .where((p) => p.id != piece.id)
        .map((p) => p.spots)
        .expand((i) => i)
        .toList();

    final collision = dest.any(others.contains);

    if (collision) {
      print('collision');
      return;
    }

    // Move the piece to its destination.
    piece.x = destX;
    piece.y = destY;
  }
}

class Piece {
  final int id;
  final String label;
  final int width, height;
  int x, y;
  MaterialColor color;

  Piece(
    this.id, {
    required this.label,
    required this.width,
    required this.height,
    required this.x,
    required this.y,
    this.color = Colors.red,
  }) {
    color = Colors.primaries[id % Colors.primaries.length];
  }

  List<Pair> get spots => occupying(x, y, width, height);

  static List<Pair> occupying(int x, int y, int width, int height) {
    return [
      for (int i = 0; i < width; i++)
        for (int j = 0; j < height; j++) Pair(x + i, y + j),
    ];
  }
}

class Pair {
  final int x;
  final int y;

  const Pair(this.x, this.y);

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  String toString() => 'Position($x, $y)';
}
