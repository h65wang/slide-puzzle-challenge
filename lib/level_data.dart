import 'game_state.dart';

class LevelData {
  /// Test Level: used for testing UI, cannot win
  static testLevel() => [
        Piece(0, label: '曹操', width: 2, height: 2, x: 2, y: 0),
        Piece(1, label: '黄\n忠', width: 1, height: 4, x: 0, y: 0),
        Piece(5, label: '关羽', width: 3, height: 1, x: 1, y: 3),
        Piece(9, label: '秋', width: 1, height: 1, x: 0, y: 4),
        Piece(10, label: '冬', width: 1, height: 1, x: 3, y: 4),
      ];

  /// Level 1: a trivial tutorial level
  static level1() => [
        Piece(0, label: '曹操', width: 2, height: 2, x: 1, y: 2),
        Piece(1, label: '黄\n忠', width: 1, height: 2, x: 0, y: 0),
        Piece(2, label: '张\n飞', width: 1, height: 2, x: 3, y: 0),
        Piece(3, label: '马\n超', width: 1, height: 2, x: 0, y: 2),
        Piece(4, label: '关羽', width: 2, height: 1, x: 1, y: 1),
        Piece(5, label: '赵\n云', width: 1, height: 2, x: 3, y: 2),
        Piece(6, label: '春', width: 1, height: 1, x: 1, y: 0),
        Piece(7, label: '夏', width: 1, height: 1, x: 2, y: 0),
        Piece(8, label: '秋', width: 1, height: 1, x: 0, y: 4),
        Piece(9, label: '冬', width: 1, height: 1, x: 1, y: 4),
      ];

  /// Level 2: a level with moderate difficulty
  static level2() => [
        Piece(0, label: '曹操', width: 2, height: 2, x: 1, y: 1),
        Piece(1, label: '黄\n忠', width: 1, height: 2, x: 0, y: 0),
        Piece(2, label: '张\n飞', width: 1, height: 2, x: 3, y: 0),
        Piece(3, label: '马\n超', width: 1, height: 2, x: 0, y: 2),
        Piece(4, label: '关羽', width: 2, height: 1, x: 1, y: 4),
        Piece(5, label: '赵\n云', width: 1, height: 2, x: 3, y: 2),
        Piece(6, label: '春', width: 1, height: 1, x: 1, y: 0),
        Piece(7, label: '夏', width: 1, height: 1, x: 2, y: 0),
        Piece(8, label: '秋', width: 1, height: 1, x: 1, y: 3),
        Piece(9, label: '冬', width: 1, height: 1, x: 2, y: 3),
      ];

  /// Level 3: a difficult level, optimal solution is 81 moves
  static level3() => [
        Piece(0, label: '曹操', width: 2, height: 2, x: 1, y: 0),
        Piece(1, label: '黄\n忠', width: 1, height: 2, x: 0, y: 0),
        Piece(2, label: '张\n飞', width: 1, height: 2, x: 3, y: 0),
        Piece(3, label: '马\n超', width: 1, height: 2, x: 0, y: 2),
        Piece(4, label: '关羽', width: 2, height: 1, x: 1, y: 2),
        Piece(5, label: '赵\n云', width: 1, height: 2, x: 3, y: 2),
        Piece(6, label: '春', width: 1, height: 1, x: 1, y: 3),
        Piece(7, label: '夏', width: 1, height: 1, x: 2, y: 3),
        Piece(8, label: '秋', width: 1, height: 1, x: 0, y: 4),
        Piece(9, label: '冬', width: 1, height: 1, x: 3, y: 4),
      ];
}
