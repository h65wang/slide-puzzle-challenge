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

  late final _painter = MatrixBackdropPainter(_controller);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _painter,
    );
  }
}

class MatrixBackdropPainter extends CustomPainter {
  MatrixBackdropPainter(controller) : super(repaint: controller);

  final List<Line> _lines = List.generate(
    20,
    (index) => Line(index: index, message: '1234567890'),
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
  final Random rnd;
  final List<String> letters;
  final int index;

  Line({required this.index, required String message})
      : rnd = Random(),
        letters = message.split('') {
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
