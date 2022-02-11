import 'dart:math';

import 'package:flutter/material.dart';

class MatrixBackdrop extends StatefulWidget {
  const MatrixBackdrop({Key? key}) : super(key: key);

  @override
  _MatrixBackdropState createState() => _MatrixBackdropState();
}

class _MatrixBackdropState extends State<MatrixBackdrop>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  late final MatrixBackdropPainter _painter =
      MatrixBackdropPainter(controller: _controller);

  @override
  void dispose() {
    _controller.dispose();
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

class MatrixBackdropPainter extends CustomPainter {
  MatrixBackdropPainter({required controller}) : super(repaint: controller);

  late final List<Snake> _lines = List.generate(200, Snake.new);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);

    for (final line in _lines) {
      line.tick(size.height);
      line.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Snake {
  static const dotSize = 20.0;
  final Random rnd;
  final int index; // the column index of this snake on screen

  late int length; // the total length of the snake
  late double sizeVariance; // the size factor of each snake dot
  late double speed;
  late double y;
  late bool colorful;

  Snake(this.index) : rnd = Random() {
    reset();
    colorful = true;
    speed = rndBetween(1.0, 2.0);
    length = rndBetween(20, 80).toInt();
  }

  reset() {
    length = rndBetween(10, 20).toInt();
    sizeVariance = rndBetween(0.3, 0.5);
    speed = rndBetween(0.05, 0.5);
    y = 0;
    colorful = false;
  }

  tick(double screenHeight) {
    if ((y - (length * 2)) * dotSize < screenHeight) {
      y += speed;
    } else {
      reset();
    }
  }

  paint(Canvas canvas, Size size) {
    if (index * dotSize > size.width) return;
    for (int i = 0; i < length; i++) {
      canvas.drawRect(
        Offset(index * dotSize, (y - i).floor() * dotSize) &
            Size(
              dotSize * sizeVariance,
              dotSize * sizeVariance,
            ),
        Paint()..color = getColor(i),
      );
    }
  }

  Color getColor(int i) {
    if (colorful) return Colors.primaries[i % 18];

    if (i == 0) return Colors.white;
    return Color.lerp(
      const Color(0xff00ff00),
      const Color(0x0000ff00),
      i / length,
    )!;
  }

  double rndBetween(num min, num max) {
    return min + rnd.nextDouble() * (max - min);
  }
}
