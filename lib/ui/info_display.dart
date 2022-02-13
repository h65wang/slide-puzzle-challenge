import 'package:flutter/material.dart';

import 'board_config.dart';

class InfoDisplay extends StatelessWidget {
  const InfoDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;

    return Positioned(
      top: unitSize * 0.25,
      height: unitSize * 0.5,
      left: unitSize * 0.3,
      right: unitSize * 0.3,
      child: Row(
        children: const [
          Expanded(
            child: _DecoratedText('Lv. 1', TextAlign.left),
          ),
          Expanded(
            child: Center(
              child: _ResetButton(),
            ),
          ),
          Expanded(
            child: _DecoratedText('123', TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class _ResetButton extends StatefulWidget {
  const _ResetButton({Key? key}) : super(key: key);

  @override
  _ResetButtonState createState() => _ResetButtonState();
}

class _ResetButtonState extends State<_ResetButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;

    return GestureDetector(
      onTapDown: (_) => setState(() {
        _pressed = true;
      }),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        print("should reset");
      },
      child: Container(
        padding: EdgeInsets.all(unitSize * 0.04),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(unitSize * 0.4),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              BoardConfig.of(context).pieceColor1.withOpacity(0.5),
              BoardConfig.of(context).pieceColor2.withOpacity(0.5),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: unitSize * 0.02,
              offset: _pressed ? Offset.zero : Offset(0, unitSize * 0.04),
            ),
          ],
        ),
        child: Icon(
          Icons.refresh,
          color: Colors.white70,
          size: unitSize * 0.4,
        ),
      ),
    );
  }
}

class _DecoratedText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const _DecoratedText(this.text, this.textAlign, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            BoardConfig.of(context).pieceColor1.withOpacity(0.5),
            BoardConfig.of(context).pieceColor2.withOpacity(0.5),
          ],
        ),
        border: Border.all(
          color: BoardConfig.of(context).corePieceColor1.withOpacity(0.5),
          width: unitSize * 0.01,
        ),
        borderRadius: BorderRadius.circular(unitSize * 0.12),
      ),
      padding: EdgeInsets.symmetric(horizontal: unitSize * 0.12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: unitSize * 0.35,
          color: Colors.white70,
          fontWeight: FontWeight.bold,
        ),
        textAlign: textAlign,
      ),
    );
  }
}
