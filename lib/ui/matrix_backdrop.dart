import 'dart:math';

import 'package:flutter/material.dart';

class MatrixBackdrop extends StatefulWidget {
  final Size size;

  const MatrixBackdrop({Key? key, required this.size}) : super(key: key);

  @override
  _MatrixBackdropState createState() => _MatrixBackdropState();
}

class _MatrixBackdropState extends State<MatrixBackdrop>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  late final MatrixBackdropPainter _painter = MatrixBackdropPainter(
    controller: _controller,
    screenWidth: widget.size.width,
    screenHeight: widget.size.height,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: _painter,
    );
  }
}

class MatrixBackdropPainter extends CustomPainter {
  final double screenWidth, screenHeight;

  MatrixBackdropPainter({
    required controller,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(repaint: controller);

  late final List<Line> _lines = List.generate(
    (screenWidth / Line.dotSize).ceil(),
    (index) => Line(index: index, screenHeight: screenHeight),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);

    for (final line in _lines) {
      line.tick();
      line.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Line {
  static const dotSize = 20.0;
  final double screenHeight;
  final Random rnd;
  final int index;

  late int totalDots;
  late int maxVisibleDots;

  late double currentVisibleDots, speed, sizeVariance;

  Line({required this.index, required this.screenHeight}) : rnd = Random() {
    reset();
    currentVisibleDots = rndBetween(0, totalDots);
  }

  reset() {
    final totalDotsMin = (screenHeight / dotSize).ceil();
    totalDots = rndBetween(totalDotsMin, totalDotsMin * 2).toInt();
    maxVisibleDots = rndBetween(10, 20).toInt();
    currentVisibleDots = 0;
    speed = rndBetween(0.05, 0.5);
    sizeVariance = rndBetween(0.3, 0.5);
  }

  double rndBetween(num min, num max) {
    return min + rnd.nextDouble() * (max - min);
  }

  tick() {
    if (currentVisibleDots < totalDots) {
      currentVisibleDots += speed;
    } else {
      reset();
    }
  }

  paint(Canvas canvas, Size size) {
    for (int i = 0; i < currentVisibleDots; i++) {
      canvas.drawRect(
        Offset(index * dotSize, i * dotSize) &
            Size(
              dotSize * sizeVariance,
              dotSize * sizeVariance,
            ),
        Paint()..color = getColor(i),
      );
    }
  }

  Color getColor(int index) {
    final int countFromEnd = (currentVisibleDots - index).floor();
    if (countFromEnd == 0) return const Color(0xffffffff);
    return Color.lerp(
      const Color(0x0000ff00),
      const Color(0xff00ff00),
      (maxVisibleDots - countFromEnd) / maxVisibleDots,
    )!;
  }
}
