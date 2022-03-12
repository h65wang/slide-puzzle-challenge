import 'package:flutter/foundation.dart';

import 'level_data.dart';

class GameState {
  final int level; // current level, final, new level will be a new [GameState]
  final Coordinates boardSize; // the size of the game board, usually 4x5

  late List<Piece> pieces; // the pieces on the board

  ValueNotifier<int> stepCounter = ValueNotifier(0); // total steps used

  GameState({
    required this.level,
    required this.boardSize,
    required this.pieces,
  });

  GameState.level(this.level)
      : boardSize = const Coordinates(4, 5),
        pieces = LevelData.load(level);

  GameState copyWith({List<Piece>? pieces}) {
    return GameState(
      level: level,
      boardSize: boardSize,
      pieces: pieces ?? this.pieces,
    );
  }

  /// Returns whether a piece can be legally moved towards dx dy.
  ///
  /// For example, if dx = 1 and dy = 0, it returns whether the piece can be
  /// moved 1 step to the right. It checks that the piece will still be inside
  /// the board boundary, and verifies no other pieces are in the way.
  bool canMove(Piece piece, int dx, int dy) {
    final destX = piece.x + dx;
    final destY = piece.y + dy;

    // Make sure the destination is within the bounds of the board.
    if (destX < 0 ||
        destX + (piece.width - 1) >= boardSize.x ||
        destY < 0 ||
        destY + (piece.height - 1) >= boardSize.y) {
      return false;
    }

    // Make sure no other pieces are already occupying the destination spot.
    final dest = Piece.occupies(destX, destY, piece.width, piece.height);

    List<Coordinates> others = pieces
        .where((p) => p.id != piece.id)
        .map((p) => p.locations)
        .expand((i) => i)
        .toList();

    final collision = dest.any(others.contains);
    if (collision) {
      return false;
    }

    // Looks like we are allowed to make this move.
    return true;
  }

  /// Returns whether the current game is in a winning state.
  bool hasWon() {
    // Check if the core piece is at the exit location.
    final cc = pieces.singleWhere((p) => p.id == 0);
    return cc.x == 1 && cc.y == 3;
  }

  /// Moves all pieces back to their original positions, and resets the step
  /// counter to 0 (this triggers value notifier).
  void reset() {
    stepCounter.value = 0;
    pieces = LevelData.load(level);
  }
}

class Piece {
  final int id; // should be unique in a level
  final String label; // the display text on the piece
  final int width, height; // the size of the piece, usually 1
  late ValueNotifier<Coordinates> coordinates; // x, y coordinates of the piece

  int get x => coordinates.value.x;

  int get y => coordinates.value.y;

  Piece(
    this.id, {
    required this.label,
    required this.width,
    required this.height,
    required x,
    required y,
  }) : coordinates = ValueNotifier(Coordinates(x, y));

  Piece.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        label = json['label'],
        width = json['width'],
        height = json['height'],
        coordinates = ValueNotifier(Coordinates(json['x'], json['y']));

  Piece copyWith({int? x, int? y}) {
    return Piece(
      id,
      label: label,
      width: width,
      height: height,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  /// Moves the current piece towards dx dy, regardless if it's legal.
  void move(int dx, int dy) => coordinates.value = Coordinates(x + dx, y + dy);

  /// Returns a list of [Coordinates] that this piece occupies.
  List<Coordinates> get locations => occupies(x, y, width, height);

  /// Returns a list of [Coordinates] that a piece occupies.
  static List<Coordinates> occupies(int x, int y, int width, int height) {
    return [
      for (int i = 0; i < width; i++)
        for (int j = 0; j < height; j++) Coordinates(x + i, y + j),
    ];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'width': width,
        'height': height,
        'x': x,
        'y': y,
      };
}

/// The (x, y) coordinates, typically used to represent [Piece] position.
///
/// For example, (0, 0) means it's at the top-left corner of the board.
class Coordinates {
  final int x;
  final int y;

  const Coordinates(this.x, this.y);

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is Coordinates &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  String toString() => 'Coordinate($x, $y)';

  @override
  int get hashCode => '$x,$y'.hashCode;
}
