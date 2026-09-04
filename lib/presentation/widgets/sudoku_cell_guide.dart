import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';

/// Selection helpers on the board. Cross, 3×3, and same-number are Easy only.
class SudokuCellGuide {
  const SudokuCellGuide({
    required this.difficulty,
    required this.row,
    required this.col,
    required this.cellValue,
    required this.selectedRow,
    required this.selectedCol,
    required this.selectedValue,
  });

  final SudokuDifficulty difficulty;
  final int row;
  final int col;
  final int cellValue;
  final int? selectedRow;
  final int? selectedCol;
  final int selectedValue;

  bool get _easy => difficulty == SudokuDifficulty.easy;

  bool get isSelected =>
      selectedRow != null && selectedCol != null && row == selectedRow && col == selectedCol;

  bool get showFocusRing => _easy && isSelected;

  bool get isSameNumber =>
      _easy &&
      !isSelected &&
      selectedRow != null &&
      selectedValue != 0 &&
      cellValue == selectedValue;

  /// Same row, column, or 3×3 box. Easy only.
  bool get isRegionHint {
    if (!_easy || isSelected || selectedRow == null || selectedCol == null) {
      return false;
    }
    final cross = row == selectedRow || col == selectedCol;
    final box =
        row ~/ 3 == selectedRow! ~/ 3 && col ~/ 3 == selectedCol! ~/ 3;
    return cross || box;
  }
}
