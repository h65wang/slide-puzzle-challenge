import 'package:flutter/material.dart';

import '../game_state.dart';
import 'animated_flip_counter.dart';
import 'board_config.dart';

/// Displays the level and steps count, plus a "reset level" button.
class InfoDisplay extends StatelessWidget {
  final GameState gameState;

  const InfoDisplay(this.gameState, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;
    final textStyle = TextStyle(
      fontSize: unitSize * 0.35,
      color: Colors.blueGrey.shade300,
      fontWeight: FontWeight.bold,
      shadows: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: unitSize * 0.02,
          offset: Offset(unitSize * 0.02, unitSize * 0.02),
        ),
      ],
    );

    return Positioned(
      top: unitSize * 0.25,
      height: unitSize * 0.5,
      left: unitSize * 0.3,
      right: unitSize * 0.3,
      child: Row(
        children: [
          // Level display
          Expanded(
            child: _buildBorder(
              context: context,
              unitSize: unitSize,
              child: Text(
                'Lv. ${gameState.level}',
                style: textStyle,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          // Reset button
          Expanded(
            child: Center(
              child: _ResetButton(
                onPressed: () {
                  // Reset the game if moves were made.
                  if (gameState.stepCounter.value != 0) {
                    gameState.reset();
                  }
                },
              ),
            ),
          ),
          // Step counter
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: gameState.stepCounter,
              builder: (BuildContext context, int value, Widget? child) {
                return _buildBorder(
                  context: context,
                  unitSize: unitSize,
                  child: AnimatedFlipCounter(
                    value: value,
                    wholeDigits: 3,
                    textStyle: textStyle,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBorder({
    required BuildContext context,
    required double unitSize,
    required Widget child,
  }) {
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
      child: child,
    );
  }
}

class _ResetButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const _ResetButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  _ResetButtonState createState() => _ResetButtonState();
}

class _ResetButtonState extends State<_ResetButton> {
  bool _hovering = false; // glowing effect when cursor is hovering
  bool _pressed = false; // change the shadow when the button is pressed

  @override
  Widget build(BuildContext context) {
    final unitSize = BoardConfig.of(context).unitSize;

    final button = Container(
      padding: EdgeInsets.all(unitSize * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(unitSize * 0.4),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _hovering
              ? [
                  BoardConfig.of(context).corePieceColor1.withOpacity(0.5),
                  BoardConfig.of(context).corePieceColor2.withOpacity(0.5),
                ]
              : [
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
        semanticLabel: 'Reset Button',
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: button,
      ),
    );
  }
}
