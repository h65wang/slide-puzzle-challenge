import 'package:flutter/material.dart';

import '../game_state.dart';
import 'board_decoration.dart';
import 'board_config.dart';
import 'puzzle_piece.dart';

class PuzzleLevel extends StatefulWidget {
  final int level;
  final VoidCallback onWin;

  const PuzzleLevel({Key? key, required this.level, required this.onWin})
      : super(key: key);

  @override
  State<PuzzleLevel> createState() => _PuzzleLevelState();
}

class _PuzzleLevelState extends State<PuzzleLevel>
    with SingleTickerProviderStateMixin {
  late final GameState _gameState = GameState.level(widget.level);

  final GlobalKey _globalKey = GlobalKey();
  bool hasWon = false;

  @override
  initState() {
    super.initState();
    _gameState.stepCounter.addListener(() {
      if (_gameState.stepCounter.value == 0) {
        // The user pressed the reset button.
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;

    // Every puzzle piece inside the game board.
    final puzzlePieces = Stack(
      // Use a `GlobalKey` to keep widget state during level-ending animation
      key: _globalKey,
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
          AnimatedPieceComponent(
            piece: p,
            child: PuzzlePieceShadow(piece: p),
          ),
        // Next, draw all the piece attachments.
        for (final p in _gameState.pieces)
          AnimatedPieceComponent(
            piece: p,
            child: PuzzlePieceAttachment(piece: p),
          ),
        // Lastly, draw pieces so they are on top of shadows and attachments.
        for (final p in _gameState.pieces)
          AnimatedPieceComponent(
            piece: p,
            child: PuzzlePiece(
              piece: p,
              gameState: _gameState,
              onMove: _checkWinCondition,
            ),
          ),
      ],
    );

    if (hasWon) {
      return puzzlePieces;
    } else {
      return BoardDecoration(
        gameState: _gameState,
        child: puzzlePieces,
      );
    }
  }

  _checkWinCondition() async {
    if (_gameState.hasWon()) {
      // Level ending animation: set every other pieces (except the core piece)
      // backwards, and set the core piece slightly backwards too.
      _gameState.pieces.where((p) => p.id != 0).forEach((p) => p.move(0, -18));
      _gameState.pieces.singleWhere((p) => p.id == 0).move(0, -2);
      // Call the parent to advance to the next level.
      widget.onWin();
      setState(() => hasWon = true);
    }
  }
}

class AnimatedPieceComponent extends StatefulWidget {
  final Piece piece;
  final Widget child;

  const AnimatedPieceComponent({
    Key? key,
    required this.piece,
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedPieceComponent> createState() => _AnimatedPieceComponentState();
}

class _AnimatedPieceComponentState extends State<AnimatedPieceComponent> {
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
