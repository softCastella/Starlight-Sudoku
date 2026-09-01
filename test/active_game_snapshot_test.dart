import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/core/progress/active_game_snapshot.dart';
import 'package:sudoku_game/core/sudoku/sudoku_board.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';

void main() {
  test('active game snapshot restores player values and memo candidates', () {
    final puzzle = List.generate(9, (_) => List.filled(9, 0));
    puzzle[0][0] = 4;
    final solution = List.generate(9, (row) => List.generate(9, (col) => (row + col) % 9 + 1));
    final board = SudokuBoard(solution: solution, puzzle: puzzle)
      ..setValue(0, 1, 7)
      ..addMemo(0, 2, 2);
    final original = ActiveGameSnapshot(
      board: board,
      difficulty: SudokuDifficulty.normal,
      elapsedSeconds: 92,
      isPaused: true,
    );

    final restored = ActiveGameSnapshot.fromJson(original.toJson());

    expect(restored.board.getValue(0, 0), 4);
    expect(restored.board.getValue(0, 1), 7);
    expect(restored.board.getMemo(0, 2), contains(2));
    expect(restored.difficulty, SudokuDifficulty.normal);
    expect(restored.elapsedSeconds, 92);
    expect(restored.isPaused, isTrue);
  });
}