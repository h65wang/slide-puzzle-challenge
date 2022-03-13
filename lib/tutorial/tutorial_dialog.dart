import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:slide_puzzle/data/game_state.dart';
import 'package:slide_puzzle/data/board_config.dart';
import 'package:slide_puzzle/board/exit_arrows.dart';
import 'package:slide_puzzle/puzzle/puzzle_piece.dart';

class TutorialDialog extends StatefulWidget {
  final void Function(bool hideText) onDismiss;

  const TutorialDialog({Key? key, required this.onDismiss}) : super(key: key);

  @override
  State<TutorialDialog> createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog> {
  bool _hideTexts = false;

  @override
  Widget build(BuildContext context) {
    final dialog = Stack(
      children: [
        CupertinoPopupSurface(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
              child: _buildTutorialContent(context),
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: ClipOval(
            child: Material(
              shape: const CircleBorder(),
              child: CloseButton(
                onPressed: () => widget.onDismiss(_hideTexts),
              ),
            ),
          ),
        ),
      ],
    );

    final responsiveDialog = Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 650) {
            // If the width is small, it's very likely to be a phone,
            // and modern phones are very likely to have irregular screens.
            // So we use `SafeArea` here to avoid the dialog being cut off.
            return SafeArea(
              minimum: const EdgeInsets.all(32),
              child: dialog,
            );
          }
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight * 0.8,
              maxWidth: 600,
            ),
            child: dialog,
          );
        },
      ),
    );

    return WillPopScope(
      // Dismiss the tutorial dialog when the user taps the back button,
      // instead of quitting the entire app.
      child: responsiveDialog,
      onWillPop: () async {
        widget.onDismiss(_hideTexts);
        return false;
      },
    );
  }

  Widget _buildTutorialContent(BuildContext context) {
    final header = TextStyle(
      fontWeight: FontWeight.bold,
      color: BoardConfig.of(context).pieceColor2,
      fontSize: 20,
      height: 2.0,
    );
    const body = TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.black87,
      height: 1.2,
    );
    final em = TextStyle(
      fontWeight: FontWeight.bold,
      color: BoardConfig.of(context).pieceColor1,
      height: 1.2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'How to Play',
          style: header.copyWith(fontSize: 32),
          textAlign: TextAlign.center,
        ),
        RichText(
          text: TextSpan(
            style: body,
            children: [
              TextSpan(text: '\nObjective\n', style: header),
              const TextSpan(text: '\nThe goal is to move '),
              TextSpan(text: 'Cao Cao', style: em),
              const TextSpan(text: ' to '),
              TextSpan(text: 'the exit', style: em),
              const TextSpan(text: ' in as few '),
              TextSpan(text: 'steps', style: em),
              const TextSpan(text: ' as possible.'),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            style: body,
            children: [
              TextSpan(text: '\nPieces\n', style: header),
              const TextSpan(text: '\nThe largest piece is '),
              TextSpan(text: 'Cao Cao', style: em),
              const TextSpan(text: '. All other pieces are '),
              TextSpan(text: 'blockers', style: em),
              const TextSpan(text: ' preventing '),
              TextSpan(text: 'Cao Cao', style: em),
              const TextSpan(text: ' from reaching '),
              TextSpan(text: 'the exit', style: em),
              const TextSpan(text: '. Swipe them away to clear a path for '),
              TextSpan(text: 'Cao Cao', style: em),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            _buildPuzzlePiece(
              Piece(0, label: '曹操', width: 2, height: 2, x: 0, y: 0),
            ),
            Text('Cao Cao', style: em),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPuzzlePiece(
                  Piece(1, label: '关羽', width: 2, height: 1, x: 0, y: 0),
                ),
                _buildPuzzlePiece(
                  Piece(2, label: '夏', width: 1, height: 1, x: 0, y: 0),
                ),
                _buildPuzzlePiece(
                  Piece(3, label: '黄\n忠', width: 1, height: 2, x: 0, y: 0),
                ),
              ],
            ),
            Text('Blockers', style: em),
          ],
        ),
        _buildHideTextOption(context),
        RichText(
          text: TextSpan(
            style: body,
            children: [
              TextSpan(
                text: '\nThe Exit\n',
                style: header,
              ),
              const TextSpan(text: '\nThe exit is located '),
              TextSpan(text: 'at the bottom', style: em),
              const TextSpan(text: ' of the game board for each level. Once '),
              TextSpan(text: 'Cao Cao', style: em),
              const TextSpan(
                  text: ' reaches the exit, '
                      'the game will advance to the next level.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildExit(),
        Text(
          'The Exit',
          style: em,
          textAlign: TextAlign.center,
        ),
        RichText(
          text: TextSpan(
            style: body,
            children: [
              TextSpan(text: '\nSteps\n', style: header),
              const TextSpan(text: '\nThe game is not timed, but there is a '),
              TextSpan(text: 'step counter', style: em),
              const TextSpan(
                text: ' at the top. Solving the puzzle is already an incredible'
                    " achievement, so don't be stressed about the steps.",
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () async {
            // Wait for the button ink well splash to finish.
            await Future.delayed(const Duration(milliseconds: 300));
            widget.onDismiss(_hideTexts);
          },
          child: const Text("Let's go!"),
          style: ElevatedButton.styleFrom(
            primary: const Color(0xbf0d4645),
          ),
        ),
      ],
    );
  }

  Widget _buildPuzzlePiece(Piece piece) {
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BoardConfig(
          unitSize: 30,
          hideTexts: _hideTexts,
          child: Stack(
            children: [
              PuzzlePieceShadow(piece: piece),
              PuzzlePieceAttachment(piece: piece),
              PuzzlePiece(piece: piece, disableGestures: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHideTextOption(BuildContext context) {
    const body = TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.black87,
      height: 1.2,
    );
    final em = TextStyle(
      fontWeight: FontWeight.bold,
      color: BoardConfig.of(context).corePieceColor2,
      height: 1.2,
    );

    return RichText(
      text: TextSpan(
        style: body,
        children: [
          const TextSpan(text: '\nYou can '),
          TextSpan(
            text: 'click here',
            style: em,
            recognizer: TapGestureRecognizer()
              ..onTap = () => setState(() => _hideTexts = !_hideTexts),
          ),
          TextSpan(text: ' to ${_hideTexts ? 'show' : 'hide'} '),
          const TextSpan(text: 'decorative texts on the pieces.'),
        ],
      ),
    );
  }

  Widget _buildExit() {
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BoardConfig(
          unitSize: 50,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xbf0d4645),
                  width: 2,
                ),
                color: const Color(0xbf0d4645),
                borderRadius: BorderRadius.circular(8.0),
              ),
              width: 120,
              height: 24,
              child: const ExitArrows(),
            ),
          ),
        ),
      ),
    );
  }
}
