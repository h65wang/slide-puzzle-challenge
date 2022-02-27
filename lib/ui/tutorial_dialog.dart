import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_puzzle/game_state.dart';
import 'package:slide_puzzle/ui/board_config.dart';
import 'package:slide_puzzle/ui/exit_arrows.dart';
import 'package:slide_puzzle/ui/puzzle_piece.dart';

class TutorialDialog extends StatefulWidget {
  final VoidCallback onDismiss;

  const TutorialDialog({Key? key, required this.onDismiss}) : super(key: key);

  @override
  State<TutorialDialog> createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog> {
  @override
  Widget build(BuildContext context) {
    final popup = Stack(
      children: [
        const CupertinoPopupSurface(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 64, horizontal: 32),
              child: _TutorialContent(),
            ),
          ),
        ),
        Positioned(
          top: 24,
          right: 24,
          child: ClipOval(
            child: Material(
              shape: const CircleBorder(),
              child: CloseButton(onPressed: widget.onDismiss),
            ),
          ),
        ),
      ],
    );

    return Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final width = constraints.maxWidth;
          if (width < 600) {
            return Padding(
              padding: const EdgeInsets.all(32),
              child: popup,
            );
          }
          return FractionallySizedBox(
            heightFactor: 0.8,
            widthFactor: 0.6,
            child: popup,
          );
        },
      ),
    );
  }
}

class _TutorialContent extends StatelessWidget {
  const _TutorialContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              const TextSpan(text: '\nThere are 10 pieces in the game. '),
              const TextSpan(text: 'The largest piece is '),
              TextSpan(text: 'Cao Cao', style: em),
              const TextSpan(text: '. All other pieces are '),
              TextSpan(text: 'blockers', style: em),
              const TextSpan(text: ' preventing '),
              TextSpan(text: 'Cao Cao', style: em),
              const TextSpan(text: ' from reaching '),
              TextSpan(text: 'the exit', style: em),
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
                text: ' at the top. Solving the puzzle is already an '
                    'achievement, so reducing steps should only be '
                    'considered as a bonus objective.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildPuzzlePiece(Piece piece) {
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BoardConfig(
          unitSize: 30,
          child: Stack(
            children: [
              PuzzlePieceShadow(piece: piece),
              PuzzlePieceAttachment(piece: piece),
              PuzzlePiece(piece: piece, gameState: GameState.level(0)),
            ],
          ),
        ),
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
