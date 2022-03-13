import 'dart:math';

import 'package:flutter/material.dart';

import '../data/board_config.dart';
import 'cao_3d.dart';

/// An explicit animation widget that takes care of the level-end animation.
/// It creates a 3D animation of "Cao Cao" piece, while fading out its child
/// (puzzle board) with perspective rotation and scaling transformations.
class LevelEndTransition extends AnimatedWidget {
  final Animation<double> animation;
  final Widget child;

  LevelEndTransition({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key, listenable: animation);

  late final Animation<double> angle =
      Tween(begin: 0.0, end: -1.05 /* 60 degree in radian */)
          .chain(CurveTween(curve: Curves.easeOut))
          // .chain(CurveTween(curve: Interval(0.0, 0.5)))
          .animate(animation);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final unitSize = BoardConfig.of(context).unitSize;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // The game board falling down and flying away in the background.
        Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002) // set perspective
            ..rotateX(angle.value) // fall down
            ..scale(1.0 - animation.value), // fly away
          alignment: Alignment.center,
          child: IgnorePointer(
            // Prevents user interaction while animating.
            // The puzzle has been solved, don't un-solve it!
            ignoring: animation.value > 0,
            child: child,
          ),
        ),
        if (animation.value > 0)
          Positioned(
            // Set `left` at 1.3 units to match Cao on the board: 0.3 units
            // for the board padding, and 1 unit for the piece left of it.
            left: unitSize * 1.3,
            // First set `top` at 4 units to match Cao on the board, then
            // slowly move it back 3 units to the center of the screen, and
            // continue half of a screen height, to make it go beyond edge.
            top: unitSize * 4 -
                animation.value * (unitSize * 3 + screenHeight / 2),
            child: Cao3D(
              width: unitSize * 2,
              height: unitSize * 2,
              depth: unitSize * 0.2,
              rotateX: animation.value * -1 - 0.1,
              rotateY: animation.value * 6 * pi,
            ),
          ),
      ],
    );
  }
}
