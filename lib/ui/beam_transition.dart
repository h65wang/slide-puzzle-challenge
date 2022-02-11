import 'package:flutter/material.dart';

class BeamTransition extends AnimatedWidget {
  final Animation<double> animation;
  final Widget child;

  const BeamTransition({
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
