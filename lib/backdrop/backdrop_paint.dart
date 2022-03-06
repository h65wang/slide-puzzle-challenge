import 'dart:math';

import 'package:flutter/material.dart';

class BackdropPaint extends StatefulWidget {
  final BackdropController? controller;

  const BackdropPaint({Key? key, this.controller}) : super(key: key);

  @override
  _BackdropPaintState createState() => _BackdropPaintState();
}

class _BackdropPaintState extends State<BackdropPaint>
    with SingleTickerProviderStateMixin {
  late final _backdropController = widget.controller ?? BackdropController();
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  late final _painter = _FallingDotsPainter(
    animationController: _animationController,
    controller: _backdropController,
  );

  @override
  void dispose() {
    _animationController.dispose();
    _backdropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _painter,
    );
  }
}

class BackdropController {
  final ValueNotifier<bool> _colorful = ValueNotifier(false);

  /// Makes the backdrop colorful; used for level-transition.
  void celebrate() => _colorful.value = true;

  void dispose() => _colorful.dispose();
}

class _FallingDotsPainter extends CustomPainter {
  final BackdropController controller;

  _FallingDotsPainter({
    required AnimationController animationController,
    required this.controller,
  }) : super(repaint: animationController) {
    controller._colorful.addListener(() {
      if (controller._colorful.value) {
        controller._colorful.value = false;
        for (final snake in _snakes) {
          snake.celebrate();
        }
      }
    });
  }

  late final List<_Snake> _snakes = List.generate(200, _Snake.new);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);

    for (final snake in _snakes) {
      snake.tick(size.height);
      snake.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// A vertical line of falling dots, similar to a moving snake in a snake game.
class _Snake {
  static const gridSize = 20.0;
  final Random rnd;
  final int index; // the column index of this snake on screen

  late int length; // the total length of the snake
  late double sizeVariance; // the size factor of each snake dot
  late bool colorful; // it's colorful when celebrating, green otherwise
  late double speed;
  late double y;

  _Snake(this.index) : rnd = Random() {
    reset();
    // Get some random starting positions to make the first frame look natural.
    y = _rndBetween(-200, 100);
  }

  /// When a snake reaches the bottom, it's reset to the top with new stats.
  reset() {
    length = _rndBetween(10, 20).toInt(); // the length of the snake
    sizeVariance = _rndBetween(0.2, 0.6); // the size of each dot
    colorful = false; // the snake is usually all green and not colorful
    // Speed is related to snake size. Smaller snakes seem farther away from
    // the camera, so we make them move slower, to create a parallax effect.
    speed = sizeVariance * 0.8;
    // Leave some space at the top, so they aren't instantly visible.
    y = _rndBetween(-50, -10);
  }

  /// A special reset to create longer, faster, and more colorful snakes.
  celebrate() {
    reset();
    length *= 3;
    speed *= 4;
    colorful = true;
  }

  Size get dotSize => Size(gridSize * sizeVariance, gridSize * sizeVariance);

  /// Moves the snake forward. This calculation is always performed even if the
  /// snake is currently off-screen. This is because the user might resize the
  /// window any time, and a previously visible snake might become invisible
  /// and then visible again, we don't want to lose state when that happens.
  tick(double screenHeight) {
    if ((y - length) * gridSize > screenHeight) {
      // the tail of the snake is off-screen, reset it
      reset();
    }
    y += speed;
  }

  paint(Canvas canvas, Size size) {
    final left = index * gridSize;
    if (left > size.width || y < 0) {
      // this snake is entirely off-screen, skip painting
      return;
    }

    for (int i = 0; i < length; i++) {
      final top = (y - i).floor() * gridSize;
      if (top > size.height) {
        // this dot is off-screen, skip painting
        continue;
      }
      canvas.drawRect(
        Offset(left, top) & dotSize,
        Paint()..color = _getColor(i),
      );
    }
  }

  Color _getColor(int i) {
    if (colorful) return Colors.primaries[i % 18];

    if (i == 0) return Colors.white;
    return Color.lerp(
      const Color(0xff00ff00),
      const Color(0x0000ff00),
      i / length,
    )!;
  }

  double _rndBetween(num min, num max) {
    return min + rnd.nextDouble() * (max - min);
  }
}
