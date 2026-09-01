import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/core/progress/player_statistics.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';

void main() {
  test('records completions and calculates an average play time', () {
    const initial = PlayerStatistics();
    final afterEasy = initial.recordCompletion(SudokuDifficulty.easy, 120);
    final afterHard = afterEasy.recordCompletion(SudokuDifficulty.hard, 180);

    expect(afterHard.completedPuzzles, 2);
    expect(afterHard.easyCompletions, 1);
    expect(afterHard.hardCompletions, 1);
    expect(afterHard.normalCompletions, 0);
    expect(afterHard.averagePlaySeconds, 150);
  });
}