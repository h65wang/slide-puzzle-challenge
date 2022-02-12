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

  late final _painter = SnakeBackdropPainter(controller: _controller);

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

class SnakeBackdropPainter extends CustomPainter {
  SnakeBackdropPainter({required controller}) : super(repaint: controller);

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

class MatrixBackdropPainter extends CustomPainter {
  MatrixBackdropPainter({required controller}) : super(repaint: controller);

  final List<Line> _lines = List.generate(200, Line.new);

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
  static const candidates = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final Random rnd;
  final List<String> letters;
  final int index;

  Line(this.index)
      : rnd = Random(),
        letters = candidates.split('') {
    letters.shuffle(rnd);
    final length = rnd.nextInt(40) + 40;
    while (letters.length < length) {
      letters.add(letters[rnd.nextInt(letters.length)]);
    }
    reset();
    currentLetters = rnd.nextInt(letters.length);
  }

  int counter = 0;
  int ticksPerLetter = 30;
  int currentLetters = 0;
  int visibleLetters = 0;
  double fontSizeFactor = 0.95; // 0.9~1.0
  double opacity = 0.75; // 0.5~1.0

  reset() {
    counter = 0;
    ticksPerLetter = (rnd.nextDouble() * 8 + 2).toInt();
    currentLetters = 0;
    visibleLetters = rnd.nextInt(20) + 10;
    fontSizeFactor = rnd.nextDouble() * 0.1 + 0.9; // 0.9 - 1.0
    opacity = rnd.nextDouble() * 0.5 + 0.5; // 0.5 - 1.0
  }

  tick() {
    counter++;
    if (counter > ticksPerLetter) {
      if (currentLetters < letters.length) {
        currentLetters++;
        counter = 0;
      } else {
        reset();
      }
    }
  }

  paint(Canvas canvas, Size size) {
    final w = size.width / 20;

    for (int i = 0; i < currentLetters; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: letters[i],
          style: TextStyle(
            color: getColor(i, currentLetters),
            fontSize: w * fontSizeFactor,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 0);

      tp.paint(
        canvas,
        Offset(index * w, i * w),
      );
    }
  }

  Color getColor(int curr, int total) {
    final countFromEnd = total - curr;

    if (countFromEnd == 1) return Colors.white;

    return Color.lerp(
      const Color(0x0000ff00),
      const Color(0xff00ff00),
      (visibleLetters - countFromEnd) / visibleLetters,
    )!;
  }
}
