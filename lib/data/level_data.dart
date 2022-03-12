import 'game_state.dart';

class LevelData {
  /// Test Level: used for testing UI, cannot win
  static testLevel() => [
        Piece(0, label: '曹操', width: 2, height: 2, x: 2, y: 0),
        Piece(1, label: '关羽', width: 3, height: 1, x: 1, y: 3),
        Piece(2, label: '黄\n忠', width: 1, height: 4, x: 0, y: 0),
        Piece(6, label: '秋', width: 1, height: 1, x: 0, y: 4),
        Piece(7, label: '冬', width: 1, height: 1, x: 3, y: 4),
      ];

  /// Level 1: a trivial level that can be solved in 3 moves
  static level1() => [
        Piece(0, label: '曹操', width: 2, height: 2, x: 1, y: 2),
        Piece(1, label: '关羽', width: 2, height: 1, x: 1, y: 1),
        Piece(2, label: '黄\n忠', width: 1, height: 2, x: 0, y: 0),
        Piece(3, label: '赵\n云', width: 1, height: 2, x: 0, y: 2),
        Piece(4, label: '张\n飞', width: 1, height: 2, x: 3, y: 0),
        Piece(5, label: '马\n超', width: 1, height: 2, x: 3, y: 2),
        Piece(6, label: '春', width: 1, height: 1, x: 1, y: 0),
        Piece(7, label: '夏', width: 1, height: 1, x: 2, y: 0),
        Piece(8, label: '秋', width: 1, height: 1, x: 0, y: 4),
        Piece(9, label: '冬', width: 1, height: 1, x: 1, y: 4),
      ];

  /// Level 2: a straightforward level (13 moves)
  static level2() => [
        Piece(0, label: '曹操', width: 2, height: 2, x: 1, y: 1),
        Piece(1, label: '关羽', width: 2, height: 1, x: 1, y: 0),
        Piece(2, label: '黄\n忠', width: 1, height: 2, x: 0, y: 1),
        Piece(3, label: '张\n飞', width: 1, height: 2, x: 0, y: 3),
        Piece(4, label: '马\n超', width: 1, height: 2, x: 3, y: 1),
        Piece(5, label: '赵\n云', width: 1, height: 2, x: 3, y: 3),
        Piece(6, label: '春', width: 1, height: 1, x: 0, y: 0),
        Piece(7, label: '夏', width: 1, height: 1, x: 3, y: 0),
        Piece(8, label: '秋', width: 1, height: 1, x: 1, y: 3),
        Piece(9, label: '冬', width: 1, height: 1, x: 2, y: 3),
      ];

  /// Level 3: an easy level (22 moves), no need to touch the top 4 pieces
  static level3() => [
        Piece(0, label: '曹操', width: 2, height: 2, x: 1, y: 2),
        Piece(1, label: '关羽', width: 2, height: 1, x: 1, y: 4),
        Piece(2, label: '黄\n忠', width: 1, height: 2, x: 0, y: 0),
        Piece(3, label: '赵\n云', width: 1, height: 2, x: 1, y: 0),
        Piece(4, label: '马\n超', width: 1, height: 2, x: 2, y: 0),
        Piece(5, label: '张\n飞', width: 1, height: 2, x: 3, y: 0),
        Piece(6, label: '春', width: 1, height: 1, x: 0, y: 2),
        Piece(7, label: '夏', width: 1, height: 1, x: 0, y: 3),
        Piece(8, label: '秋', width: 1, height: 1, x: 3, y: 2),
        Piece(9, label: '冬', width: 1, height: 1, x: 3, y: 3),
      ];

  /// Level 4: it's actually the last 30% of level 7, solvable in 35 moves
  static level4() => [
        Piece(0, label: '曹操', width: 2, height: 2, x: 1, y: 1),
        Piece(1, label: '关羽', width: 2, height: 1, x: 1, y: 4),
        Piece(2, label: '黄\n忠', width: 1, height: 2, x: 0, y: 0),
        Piece(3, label: '张\n飞', width: 1, height: 2, x: 3, y: 0),
        Piece(4, label: '马\n超', width: 1, height: 2, x: 0, y: 2),
        Piece(5, label: '赵\n云', width: 1, height: 2, x: 3, y: 2),
        Piece(6, label: '春', width: 1, height: 1, x: 1, y: 0),
        Piece(7, label: '夏', width: 1, height: 1, x: 2, y: 0),
        Piece(8, label: '秋', width: 1, height: 1, x: 1, y: 3),
        Piece(9, label: '冬', width: 1, height: 1, x: 2, y: 3),
      ];

  /// Level 5: looks easy but all 4 single pieces are together (46 moves)
  static level5() => [
        Piece(0, label: '曹操', width: 2, height: 2, x: 2, y: 2),
        Piece(1, label: '关羽', width: 2, height: 1, x: 0, y: 4),
        Piece(2, label: '黄\n忠', width: 1, height: 2, x: 0, y: 0),
        Piece(3, label: '张\n飞', width: 1, height: 2, x: 1, y: 0),
        Piece(4, label: '马\n超', width: 1, height: 2, x: 2, y: 0),
        Piece(5, label: '赵\n云', width: 1, height: 2, x: 3, y: 0),
        Piece(6, label: '春', width: 1, height: 1, x: 0, y: 2),
        Piece(7, label: '夏', width: 1, height: 1, x: 1, y: 2),
        Piece(8, label: '秋', width: 1, height: 1, x: 0, y: 3),
        Piece(9, label: '冬', width: 1, height: 1, x: 1, y: 3),
      ];

  /// Level 6: a rather difficult level (85 moves)
  static level6() => [
        Piece(0, label: '曹操', width: 2, height: 2, x: 1, y: 0),
        Piece(1, label: '关羽', width: 2, height: 1, x: 1, y: 3),
        Piece(2, label: '张\n飞', width: 1, height: 2, x: 0, y: 0),
        Piece(3, label: '马\n超', width: 1, height: 2, x: 3, y: 0),
        Piece(4, label: '赵\n云', width: 1, height: 2, x: 0, y: 3),
        Piece(5, label: '黄\n忠', width: 1, height: 2, x: 3, y: 3),
        Piece(6, label: '秋', width: 1, height: 1, x: 1, y: 2),
        Piece(7, label: '春', width: 1, height: 1, x: 2, y: 2),
        Piece(8, label: '夏', width: 1, height: 1, x: 0, y: 2),
        Piece(9, label: '冬', width: 1, height: 1, x: 3, y: 2),
      ];

  /// Level 7: a famous layout on wikipedia (116 moves)
  static level7() => [
        Piece(0, label: '曹操', width: 2, height: 2, x: 1, y: 0),
        Piece(1, label: '关羽', width: 2, height: 1, x: 1, y: 2),
        Piece(2, label: '张\n飞', width: 1, height: 2, x: 0, y: 0),
        Piece(3, label: '马\n超', width: 1, height: 2, x: 3, y: 0),
        Piece(4, label: '赵\n云', width: 1, height: 2, x: 0, y: 2),
        Piece(5, label: '黄\n忠', width: 1, height: 2, x: 3, y: 2),
        Piece(6, label: '夏', width: 1, height: 1, x: 1, y: 3),
        Piece(7, label: '秋', width: 1, height: 1, x: 2, y: 3),
        Piece(8, label: '春', width: 1, height: 1, x: 0, y: 4),
        Piece(9, label: '冬', width: 1, height: 1, x: 3, y: 4),
      ];

  static List<Piece> load(int level) {
    switch (level) {
      case 1:
        return level1();
      case 2:
        return level2();
      case 3:
        return level3();
      case 4:
        return level4();
      case 5:
        return level5();
      case 6:
        return level6();
      default:
        return level7();
    }
  }
}
