import 'package:flutter/material.dart';

import 'board_config.dart';

class ShinyText extends StatefulWidget {
  final String label;

  const ShinyText({Key? key, required this.label}) : super(key: key);

  @override
  State<ShinyText> createState() => _ShinyTextState();
}

class _ShinyTextState extends State<ShinyText>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = BoardConfig.of(context).unitSize * 0.4;
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final v = _controller.value;
        return Text(
          widget.label,
          style: TextStyle(
            fontSize: fontSize,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: const [
                  Color(0xffD6F599),
                  Colors.white,
                  Color(0xffD6F599),
                ],
                stops: [v, v + 0.1, v + 0.2],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                tileMode: TileMode.decal,
              ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
              ..style = PaintingStyle.fill
              ..strokeWidth = 5
              ..color = Colors.white,
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
