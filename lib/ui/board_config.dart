import 'package:flutter/widgets.dart';

class BoardConfig extends InheritedWidget {
  const BoardConfig({
    Key? key,
    required this.edgePadding,
    required this.gridSize,
    required Widget child,
  }) : super(key: key, child: child);

  final double edgePadding;
  final double gridSize;

  static BoardConfig of(BuildContext context) {
    final config = context.dependOnInheritedWidgetOfExactType<BoardConfig>();
    assert(
      config != null,
      'BoardConfig.of() called with a context '
      'that does not contain a BoardConfig.',
    );
    return config!;
  }

  @override
  bool updateShouldNotify(BoardConfig oldWidget) =>
      edgePadding != oldWidget.edgePadding || gridSize != oldWidget.gridSize;
}
