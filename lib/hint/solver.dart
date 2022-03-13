import 'dart:collection';
import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:slide_puzzle/data/game_state.dart';

/// A top-level helper function for solving the puzzle on a new isolate.
List<String> _computeSolve(List<String> pieces) {
  // Construct the puzzle from serialized pieces.
  final rootState = GameState(
    level: 0,
    boardSize: const Coordinates(4, 5),
    pieces: pieces.map((s) => Piece.fromJson(convert.jsonDecode(s))).toList(),
  );
  // Solve the puzzle.
  final solution = Solver.solveSync(rootState);
  // Serialize the solution and return it.
  return solution.map((s) => convert.jsonEncode(s.toJson())).toList();
}

class Solver {
  /// Spawns a new isolate to solve the puzzle.
  static Future<List<Move>> solve(GameState rootState) async {
    assert(rootState.pieces.length == 10);
    assert(rootState.boardSize == const Coordinates(4, 5),
        'TODO: solver is not yet generalized to handle different board sizes.');
    // Serialize puzzle pieces from the game state.
    final pieces = rootState.pieces.map((p) => convert.jsonEncode(p.toJson()));
    // Spawn an isolate to solve the puzzle.
    final solution = await compute(_computeSolve, pieces.toList());
    // Deserialize the solution and return it.
    return solution.map((s) => Move.fromJson(convert.jsonDecode(s))).toList();
  }

  /// Solves the puzzle using breadth-first search approach. Might take a few
  /// seconds to complete.
  static List<Move> solveSync(GameState rootState) {
    final queue = Queue<_Step>();
    final visited = HashSet<String>();
    queue.addAll(_listLegalSteps(state: rootState, prevStep: null));

    while (queue.isNotEmpty) {
      final step = queue.removeFirst();
      // Check if this step is already in a winning state.
      if (step.state.hasWon()) {
        // Trace back from the winning state to the root state.
        final result = <Move>[];
        _Step? s = step;
        while (s != null) {
          result.add(s.move);
          s = s.prevStep;
        }
        return result.reversed.toList();
      }
      // Keep exploring and add unvisited steps to the queue.
      final nextSteps = _listLegalSteps(state: step.state, prevStep: step);
      for (final _Step newStep in nextSteps) {
        // Extract a short string representing the state.
        final String gist = _snapshot(newStep.state);
        final unvisited = visited.add(gist);
        if (unvisited) {
          queue.add(newStep);
        }
      }
    }
    // No possible solution.
    return [];
  }

  /// Hashes the game state to a short string. Identical layouts are hashed to
  /// the same string, even if text decorative texts on pieces are different.
  /// This means, a 2x1 piece is treated the same as another 2x1 piece, even
  /// if their display texts are different.
  static String _snapshot(GameState state) {
    // int s = 0;
    // for (int i = 0; i < 5; i++) {
    //   for (int j = 0; j < 4; j++) {
    //     // We use ~/ 10 to get the piece type of the cell. Possible values are
    //     // 0 (empty cell) and 1-4 (four different kinds of pieces).
    //     // Since 4 is '100' in binary, we can left-shift the sum by as little
    //     // as 3 bits (multiply by 8). This prevents integer overflow.
    //     s = s * 8 + (cells[i][j] ~/ 10);
    //   }
    // }
    // // Surprisingly, HashSet<String> is faster than HashSet<int> in Dart.
    // // See question: https://stackoverflow.com/questions/71443337
    // return '$s';

    // The approach above runs faster but when compiled for flutter web,
    // the js integer won't be big enough to hold the sum, so we use a
    // string-based solution for better cross-platform compatibility.
    final List<List<int>> cells = _project(state.pieces);
    List<String> s = [];
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 4; j++) {
        final type = cells[i][j] ~/ 10;
        s.add('$type');
      }
    }
    return s.join();
  }

  /// Projects pieces onto the board, and returns a 5x4 array representing
  /// the state of the board, with 0 indicating an empty cell, otherwise:
  /// The last digit is the piece id, and the tens digit is the type.
  /// 10s: 1x1 piece, e.g. '18' = a 1x1 piece with id 8.
  /// 20s: 2x1 (tall) piece, e.g. '24' = a 2x1 piece with id 4.
  /// 30s: 1x2 (wide) piece, e.g. '31' = a 1x2 piece with id 1.
  /// 40s: 2x2 piece, e.g. '40' = a 2x2 piece with id 0.
  static List<List<int>> _project(List<Piece> pieces) {
    List<List<int>> cells = [
      for (int i = 0; i < 5; i++) [0, 0, 0, 0],
    ];

    for (int i = 0; i <= 9; i++) {
      final piece = pieces[i];
      int type;
      if (piece.id == 0) {
        type = 4;
      } else if (piece.id == 1) {
        type = 3;
      } else if (piece.id <= 5) {
        type = 2;
      } else {
        type = 1;
      }
      for (final loc in piece.locations) {
        cells[loc.y][loc.x] = type * 10 + piece.id;
      }
    }
    return cells;
  }

  static _listLegalSteps({required GameState state, required _Step? prevStep}) {
    final List<List<int>> cells = _project(state.pieces);
    final probableMoves = <Move>[];

    // Find the two empty cells, and add their nearby pieces to `probableMoves`.
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 4; j++) {
        if (cells[i][j] == 0) {
          // For the empty spot at (i, j) right now, check:
          // * its top piece might move down:
          if (i > 0 && cells[i - 1][j] != 0) {
            final pieceId = cells[i - 1][j] % 10;
            probableMoves.add(Move(pieceId, 0, 1));
          }
          // * its bottom piece might move up:
          if (i < 5 - 1 && cells[i + 1][j] != 0) {
            final pieceId = cells[i + 1][j] % 10;
            probableMoves.add(Move(pieceId, 0, -1));
          }
          // * its left piece might move right:
          if (j > 0 && cells[i][j - 1] != 0) {
            final pieceId = cells[i][j - 1] % 10;
            probableMoves.add(Move(pieceId, 1, 0));
          }
          // * its right piece might move left:
          if (j < 4 - 1 && cells[i][j + 1] != 0) {
            final pieceId = cells[i][j + 1] % 10;
            probableMoves.add(Move(pieceId, -1, 0));
          }
        }
      }
    }

    // Check all the probable moves, and add the legal ones to `legalSteps`.
    final legalSteps = <_Step>[];
    for (final move in probableMoves) {
      // Find the piece by id, with assumption that pieces are sorted by id.
      final piece = state.pieces[move.pieceId];
      // Make sure our assumption is correct. Otherwise, we'd have to use
      // the much slower `singleWhere` method to find it.
      assert(piece.id == move.pieceId);
      // Ensure that the piece can indeed move in the given direction.
      if (!state.canMove(piece, move.x, move.y)) continue;
      // Calculate the game state after making this move.
      final newState = state.copyWith(
        pieces: List.generate(10, (i) {
          if (i != piece.id) return state.pieces[i];
          return state.pieces[i].copyWith(
            x: piece.x + move.x,
            y: piece.y + move.y,
          );
        }),
      );
      // Add it to `legalSteps`.
      legalSteps.add(_Step(prevStep, move, newState));
    }
    return legalSteps;
  }
}

/// An intermediate step used when exploring possible game states.
class _Step {
  final _Step? prevStep; // previous step, used for backtracking
  final Move move; // the move that led to this step
  final GameState state; // the current game state (after `move` is applied)

  _Step(this.prevStep, this.move, this.state);
}

/// Describes a move: which piece, and which direction.
/// For example: "Move(0, -1, 0)" means the piece with id 0 should move left.
/// When a game is solved, the solution is a list of moves.
class Move {
  final int pieceId;
  final int x;
  final int y;

  Move(this.pieceId, this.x, this.y);

  Move.fromJson(Map<String, dynamic> json)
      : pieceId = json['pieceId'] as int,
        x = json['x'] as int,
        y = json['y'] as int;

  Map<String, dynamic> toJson() => {
        'pieceId': pieceId,
        'x': x,
        'y': y,
      };
}
