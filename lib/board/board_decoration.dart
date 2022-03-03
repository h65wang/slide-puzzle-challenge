import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/game_state.dart';
import '../data/board_config.dart';
import 'exit_arrows.dart';
import 'info_display.dart';

/// A widget that decorates the game board with blur and beam effects. It also
/// includes the header row [InfoDisplay] and the footer [ExitArrows].
class BoardDecoration extends StatefulWidget {
  final GameState gameState;
  final Widget child;

  const BoardDecoration({
    Key? key,
    required this.gameState,
    required this.child,
  }) : super(key: key);

  @override
  _BoardDecorationState createState() => _BoardDecorationState();
}

class _BoardDecorationState extends State<BoardDecoration>
    with SingleTickerProviderStateMixin {
  late final _beamController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _beamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;

    final thickBorder = BorderSide(
      color: const Color(0x5f2d6665),
      width: unitSize,
    );
    final thinBorder = BorderSide(
      color: const Color(0x5f2d6665),
      width: unitSize * 0.3,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(unitSize * 0.16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: _BeamTransition(
          animation: _beamController,
          child: Stack(
            clipBehavior: Clip.none, // it'll be clipped by ClipRRect anyway
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: thickBorder,
                    bottom: thinBorder,
                    left: thinBorder,
                    right: thinBorder,
                  ),
                ),
                child: ClipRect(
                  child: Padding(
                    padding: EdgeInsets.all(unitSize * 0.01),
                    child: widget.child,
                  ),
                ),
              ),
              InfoDisplay(widget.gameState), // header
              Positioned(
                left: unitSize,
                right: unitSize,
                top: unitSize * 6,
                child: const ExitArrows(),
              ), // footer
            ],
          ),
        ),
      ),
    );
  }
}

class _BeamTransition extends AnimatedWidget {
  final Animation<double> animation;
  final Widget child;

  const _BeamTransition({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final v = CurveTween(curve: Curves.easeOutBack).transform(animation.value);
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment(0.8, -0.5 + v * 0.1),
          end: const Alignment(-1, 0.5),
          colors: [
            Colors.transparent,
            ColorTween(
              begin: const Color(0x5fffff00),
              end: const Color(0x6fffff00),
            ).transform(v)!,
            ColorTween(
              begin: const Color(0x86ffff00),
              end: const Color(0x94ffff00),
            ).transform(v)!,
            ColorTween(
              begin: const Color(0x4fffff00),
              end: const Color(0x3fffff00),
            ).transform(v)!,
            Colors.transparent,
          ],
          stops: [
            0,
            0.4 + v * 0.04,
            0.5 + v * -0.02,
            0.6 + v * 0.03,
            1.0,
          ],
        ).createShader(bounds);
      },
      blendMode: BlendMode.softLight,
      child: child,
    );
  }
}
