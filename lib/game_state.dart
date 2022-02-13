import 'level_data.dart';

class GameState {
  final Pair boardSize;
  late final List<Piece> pieces;

  GameState.level(int level) : boardSize = const Pair(4, 5) {
    switch (level % 3) {
      case 0:
        print('Entering level 1');
        pieces = LevelData.level1();
        break;
      case 1:
        print('Entering level 2');
        pieces = LevelData.level2();
        break;
      case 2:
        print('Entering level 3');
        pieces = LevelData.level3();
        break;
      default:
        throw 'Invalid level selection: $level';
    }
  }

  GameState.numbersPuzzle()
      : boardSize = const Pair(4, 4),
        pieces = [
          Piece(1, label: '1', width: 1, height: 1, x: 0, y: 0),
          Piece(2, label: '2', width: 1, height: 1, x: 1, y: 0),
          Piece(3, label: '3', width: 1, height: 1, x: 2, y: 0),
          Piece(4, label: '4', width: 1, height: 1, x: 3, y: 0),
          Piece(5, label: '5', width: 1, height: 1, x: 0, y: 1),
          Piece(6, label: '6', width: 1, height: 1, x: 1, y: 1),
          Piece(7, label: '7', width: 1, height: 1, x: 2, y: 1),
          Piece(8, label: '8', width: 1, height: 1, x: 3, y: 1),
          Piece(9, label: '9', width: 1, height: 1, x: 0, y: 2),
          Piece(10, label: '10', width: 1, height: 1, x: 1, y: 2),
          Piece(11, label: '11', width: 1, height: 1, x: 2, y: 2),
          Piece(12, label: '12', width: 1, height: 1, x: 3, y: 2),
          Piece(13, label: '13', width: 1, height: 1, x: 0, y: 3),
          Piece(14, label: '14', width: 1, height: 1, x: 1, y: 3),
          Piece(15, label: '15', width: 1, height: 1, x: 2, y: 3),
        ];

  bool canMove(Piece piece, int dx, int dy) {
    final destX = piece.x + dx;
    final destY = piece.y + dy;

    print('Trying to move ${piece.label} to ($destX, $destY).');

    // Make sure it's within the bounds of the board.
    if (destX < 0 ||
        destX + (piece.width - 1) >= boardSize.x ||
        destY < 0 ||
        destY + (piece.height - 1) >= boardSize.y) {
      return false;
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
      return false;
    }

    // Looks like we are allowed to make this move.
    return true;
  }

  bool hasWon() {
    final cc = pieces.singleWhere((p) => p.id == 0);
    return cc.x == 1 && cc.y == 3;
  }
}

class Piece {
  final int id;
  final String label;
  final int width, height;
  int x, y;

  Piece(
    this.id, {
    required this.label,
    required this.width,
    required this.height,
    required this.x,
    required this.y,
  });

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
