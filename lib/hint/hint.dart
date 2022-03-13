import 'package:flutter/material.dart';
import 'package:slide_puzzle/puzzle/puzzle_piece.dart';

import '../data/board_config.dart';
import '../data/game_state.dart';
import 'solver.dart';

class Hint {
  /// Hints the next move by showing an animating overlay.
  static show(BuildContext context, GameState gameState) async {
    final watch = Stopwatch()..start();
    final solution = await Solver.solve(gameState);
    watch.stop();
    print('Optimal solution has ${solution.length} steps, '
        'found in ${watch.elapsedMilliseconds} ms.');
    if (solution.isEmpty) return;

    // Release CPU, let it process everything in the event queue. This is
    // especially useful for web builds, where isolate is not supported.
    await Future.delayed(Duration.zero);

    final move = solution.first;
    final entry = OverlayEntry(
      builder: (_) => IgnorePointer(
        child: _HintOverlay(
          piece: gameState.pieces.singleWhere((p) => p.id == move.pieceId),
          move: move,
          config: BoardConfig.of(context),
        ),
      ),
    );
    Overlay.of(context)?.insert(entry);
    await Future.delayed(const Duration(seconds: 1));
    entry.remove();
  }
}

/// A translucent overlay that hints the next move.
///
/// It appears on top of the hinted piece using `CompositedTransformFollower`,
/// and animates towards the correct position while slowly fading out.
class _HintOverlay extends StatefulWidget {
  final Piece piece;
  final Move move;
  final BoardConfig config;

  const _HintOverlay({
    Key? key,
    required this.piece,
    required this.move,
    required this.config,
  }) : super(key: key);

  @override
  _HintOverlayState createState() => _HintOverlayState();
}

class _HintOverlayState extends State<_HintOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the layer link associated with this puzzle piece id.
    final link = widget.config.layerLinks[widget.piece.id];
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final v = widget.config.unitSize * _controller.value;
        return CompositedTransformFollower(
          link: link,
          offset: Offset(widget.move.x * v, widget.move.y * v),
          child: Opacity(
            opacity: Curves.easeIn.transform(1 - _controller.value),
            child: child,
          ),
        );
      },
      child: BoardConfig(
        unitSize: widget.config.unitSize,
        hideTexts: widget.config.hideTexts,
        child: Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            child: PuzzlePiece(piece: widget.piece, disableGestures: true),
          ),
        ),
      ),
    );
  }
}
