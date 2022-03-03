import 'package:flutter/material.dart';

import '../data/board_config.dart';

/// Displays 3 down arrows to indicate the exit location.
class ExitArrows extends StatefulWidget {
  const ExitArrows({Key? key}) : super(key: key);

  @override
  _ExitArrowsState createState() => _ExitArrowsState();
}

class _ExitArrowsState extends State<ExitArrows>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
    upperBound: 4,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;
    final color = BoardConfig.of(context).corePieceColor1;

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final v = _controller.value.truncate();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < 3; i++)
              Icon(
                Icons.arrow_drop_down,
                size: unitSize * 0.3,
                color: i == v ? Colors.white : color,
              )
          ],
        );
      },
    );
  }
}
