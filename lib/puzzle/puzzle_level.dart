import 'dart:async';

import 'package:flutter/material.dart';

import '../hint/hint.dart';
import '../data/game_state.dart';
import '../board/board_decoration.dart';
import '../data/board_config.dart';
import 'puzzle_piece.dart';

/// This widget represents a single level of the puzzle.
class PuzzleLevel extends StatefulWidget {
  final int level;
  final void Function(int level, int steps) onWin;

  const PuzzleLevel({Key? key, required this.level, required this.onWin})
      : super(key: key);

  @override
  State<PuzzleLevel> createState() => _PuzzleLevelState();
}

class _PuzzleLevelState extends State<PuzzleLevel>
    with SingleTickerProviderStateMixin {
  late final GameState _gameState = GameState.level(widget.level);

  Timer? _hintTimer;

  @override
  initState() {
    super.initState();
    _gameState.stepCounter.addListener(() {
      if (_gameState.stepCounter.value == 0) {
        // The user pressed the reset button.
        setState(() {});
      }
      _hintTimer?.cancel();
    });

    // Show a hint on the first level if the user has not moved yet.
    if (widget.level == 1) {
      _hintTimer ??= Timer.periodic(const Duration(seconds: 2), (_) {
        Hint.show(context, _gameState);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _hintTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;

    // Every puzzle piece inside the game board.
    final puzzlePieces = Stack(
      // Do not clip, because pieces need to fly out when level ends
      clipBehavior: Clip.none,
      children: [
        // Use a non-positioned child to help `Stack` determine its size.
        SizedBox(
          width: unitSize * _gameState.boardSize.x,
          height: unitSize * _gameState.boardSize.y,
        ),
        // First, draw all the piece shadows, so they are behind everything.
        for (final p in _gameState.pieces)
          _AnimatedPieceComponent(
            piece: p,
            child: PuzzlePieceShadow(piece: p),
          ),
        // Next, draw all the piece attachments.
        for (final p in _gameState.pieces)
          _AnimatedPieceComponent(
            piece: p,
            child: PuzzlePieceAttachment(piece: p),
          ),
        // Lastly, draw pieces so they are on top of shadows and attachments.
        for (final p in _gameState.pieces)
          _AnimatedPieceComponent(
            piece: p,
            child: CompositedTransformTarget(
              link: BoardConfig.of(context).layerLinks[p.id],
              child: PuzzlePiece(
                piece: p,
                gameState: _gameState,
                onMove: _onMove,
              ),
            ),
          ),
      ],
    );

    return BoardDecoration(
      gameState: _gameState,
      child: puzzlePieces,
    );
  }

  void _onMove() async {
    // Increment the step counter.
    _gameState.stepCounter.value += 1;
    // Check if the puzzle is solved.
    if (_gameState.hasWon()) {
      // Let's all take a moment to admire Cao Cao at the exit spot.
      await Future.delayed(const Duration(milliseconds: 300));
      // Then we'll notify our parent, to begin level transition animation.
      widget.onWin(_gameState.level, _gameState.stepCounter.value);
      // At the same time, we rapidly push the core piece (Cao Cao) forward,
      // so it will be out of view. Meanwhile, our parent will fabricate a
      // 3D version at the same spot to fill in.
      _gameState.pieces.singleWhere((p) => p.id == 0).move(0, 1000);
    }
  }
}

/// This is a wrapper for pieces, shadows, and attachments.
/// It wraps the child in [AnimatedPositioned] and [ValueListenableBuilder].
class _AnimatedPieceComponent extends StatefulWidget {
  final Piece piece;
  final Widget child;

  const _AnimatedPieceComponent({
    Key? key,
    required this.piece,
    required this.child,
  }) : super(key: key);

  @override
  State<_AnimatedPieceComponent> createState() =>
      _AnimatedPieceComponentState();
}

class _AnimatedPieceComponentState extends State<_AnimatedPieceComponent> {
  /// A cache of device screen size from the last frame.
  ///
  /// This is updated in the `build` method every time it's rebuilt.
  /// When the rebuilt is caused by user resizing the app window,
  /// we should not trigger the implicit animation of pieces moving.
  /// To achieve this, we check if the new screen size is different from
  /// the cached value, and if so, we set the animation duration to zero.
  Size? _size;

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;

    // Use a `ValueListenableBuilder` so each piece will monitor its own
    // position, and animate when being moved.
    // This is to reduce unnecessarily rebuilding all pieces that would
    // otherwise be caused by global `set state` in the parent widget.
    return ValueListenableBuilder(
      valueListenable: widget.piece.coordinates,
      builder: (BuildContext context, Coordinates value, Widget? child) {
        final size = MediaQuery.of(context).size;
        // Skip the animation if app screen size has changed.
        final duration = size != _size
            ? Duration.zero
            : BoardConfig.of(context).slideDuration;
        _size = size;
        return AnimatedPositioned(
          duration: duration,
          curve: Curves.easeOut,
          left: value.x * unitSize,
          top: value.y * unitSize,
          child: widget.child,
        );
      },
    );
  }
}
