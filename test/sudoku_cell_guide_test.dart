import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';
import 'package:sudoku_game/presentation/widgets/sudoku_cell_guide.dart';

SudokuCellGuide _guide(
  SudokuDifficulty difficulty, {
  required int row,
  required int col,
  int cellValue = 0,
  int selectedRow = 4,
  int selectedCol = 4,
  int selectedValue = 5,
}) {
  return SudokuCellGuide(
    difficulty: difficulty,
    row: row,
    col: col,
    cellValue: cellValue,
    selectedRow: selectedRow,
    selectedCol: selectedCol,
    selectedValue: selectedValue,
  );
}

void main() {
  test('Easy lights the cross, the 3x3 box, same number, and the focus ring', () {
    final selected = _guide(SudokuDifficulty.easy, row: 4, col: 4, cellValue: 5);
    expect(selected.isSelected, isTrue);
    expect(selected.showFocusRing, isTrue);
    expect(selected.isRegionHint, isFalse);

    expect(_guide(SudokuDifficulty.easy, row: 4, col: 0).isRegionHint, isTrue);
    expect(_guide(SudokuDifficulty.easy, row: 0, col: 4).isRegionHint, isTrue);
    expect(_guide(SudokuDifficulty.easy, row: 3, col: 3).isRegionHint, isTrue);
    expect(_guide(SudokuDifficulty.easy, row: 5, col: 5).isRegionHint, isTrue);
    expect(
      _guide(SudokuDifficulty.easy, row: 0, col: 0, cellValue: 5).isSameNumber,
      isTrue,
    );
  });

  test('Normal and Hard only mark the selected cell', () {
    for (final difficulty in [SudokuDifficulty.normal, SudokuDifficulty.hard]) {
      final selected = _guide(difficulty, row: 4, col: 4, cellValue: 5);
      expect(selected.isSelected, isTrue);
      expect(selected.showFocusRing, isFalse);
      expect(selected.isRegionHint, isFalse);
      expect(selected.isSameNumber, isFalse);

      expect(_guide(difficulty, row: 4, col: 0).isRegionHint, isFalse);
      expect(_guide(difficulty, row: 0, col: 4).isRegionHint, isFalse);
      expect(_guide(difficulty, row: 3, col: 3).isRegionHint, isFalse);
      expect(
        _guide(difficulty, row: 0, col: 0, cellValue: 5).isSameNumber,
        isFalse,
      );
    }
  });
}
