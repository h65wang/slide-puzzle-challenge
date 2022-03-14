import 'dart:math';

import 'package:flutter/material.dart';

import '../data/board_config.dart';
import '../level_transition/cao_3d.dart';

class TutorialTransition extends AnimatedWidget {
  final Animation<double> animation;
  final Widget child;

  const TutorialTransition({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;
    final v = animation.value;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (v < 1)
          for (final piece in _FallingPieceConfig.pieces)
            Align(
              alignment: Alignment(
                sin(piece.direction) * (v + piece.progression) * 2,
                cos(piece.direction) * (v + piece.progression) * 2,
              ),
              child: Transform.scale(
                scale: (v + piece.progression),
                child: Cao3D(
                  width: unitSize * piece.width,
                  height: unitSize * piece.height,
                  depth: unitSize * 0.2,
                  rotateX: piece.rx,
                  rotateY: v * piece.ry + pi * 0.75,
                  label: piece.label,
                ),
              ),
            ),
        Transform.scale(
          scale: Curves.easeIn.transform(v),
          child: child,
        ),
      ],
    );
  }
}

class _FallingPieceConfig {
  final double width, height;
  final double direction; // radians
  final double progression; // how much of its animation is already completed
  final double rx, ry;
  final String label;

  _FallingPieceConfig({
    required this.width,
    required this.height,
    required this.direction,
    required this.progression,
    required this.rx,
    required this.ry,
    required this.label,
  });

  static final pieces = [
    _FallingPieceConfig(
      height: 2,
      width: 2,
      direction: 0.6,
      progression: 0.0,
      rx: 0.4,
      ry: -pi * 3.3,
      label: '曹操',
    ),
    _FallingPieceConfig(
      height: 1,
      width: 3,
      direction: 3.5,
      progression: 0.0,
      rx: -0.4,
      ry: pi * 4.9,
      label: '关羽',
    ),
    _FallingPieceConfig(
      height: 3,
      width: 1,
      direction: 3.8,
      progression: 0.05,
      rx: -0.3,
      ry: pi * 2.3,
      label: '黄\n忠',
    ),
    _FallingPieceConfig(
      height: 3,
      width: 1,
      direction: 5.7,
      progression: 0.15,
      rx: 0.3,
      ry: pi * 3.9,
      label: '张\n飞',
    ),
    _FallingPieceConfig(
      height: 3,
      width: 1,
      direction: 2.3,
      progression: 0.1,
      rx: -0.3,
      ry: -pi * 1.3,
      label: '马\n超',
    ),
    _FallingPieceConfig(
      height: 3,
      width: 1,
      direction: 0.9,
      progression: 0.05,
      rx: 0.3,
      ry: -pi * 1.9,
      label: '赵\n云',
    ),
    _FallingPieceConfig(
      height: 1,
      width: 1,
      direction: 5.9,
      progression: 0.05,
      rx: 0.4,
      ry: pi * 3.7,
      label: '春',
    ),
    _FallingPieceConfig(
      height: 1,
      width: 1,
      direction: 2.9,
      progression: 0.1,
      rx: -0.4,
      ry: -pi * 2.1,
      label: '夏',
    ),
    _FallingPieceConfig(
      height: 1,
      width: 1,
      direction: 1.3,
      progression: 0.15,
      rx: -0.3,
      ry: -pi * 3.1,
      label: '秋',
    ),
    _FallingPieceConfig(
      height: 1,
      width: 1,
      direction: 4.2,
      progression: 0.2,
      rx: -0.3,
      ry: pi * 7.9,
      label: '冬',
    ),
    _FallingPieceConfig(
      height: 1,
      width: 2,
      direction: 5.0,
      progression: 0.15,
      rx: 0.2,
      ry: pi * 3.3,
      label: '王叔',
    ),
  ];
}
