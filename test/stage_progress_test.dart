import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/core/config/game_balance.dart';
import 'package:sudoku_game/core/progress/stage_progress.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';

void main() {
  group('StageProgress', () {
    test('difficulty stage counts match the requested layout', () {
      expect(DifficultyConfig.getConfig(SudokuDifficulty.easy).stageCount, 10);
      expect(DifficultyConfig.getConfig(SudokuDifficulty.normal).stageCount, 0);
      expect(DifficultyConfig.getConfig(SudokuDifficulty.hard).stageCount, 0);
      expect(GameBalance.easyStageCount, 10);
      expect(GameBalance.isTrial, isTrue);
    });

    test('only stage 1 starts unlocked', () {
      const progress = StageProgress();

      expect(progress.isUnlocked(SudokuDifficulty.easy, 1), isTrue);
      expect(progress.isUnlocked(SudokuDifficulty.easy, 2), isFalse);
      expect(progress.isUnlocked(SudokuDifficulty.easy, 11), isFalse);
      expect(progress.isUnlocked(SudokuDifficulty.normal, 1), isFalse);
      expect(progress.isUnlocked(SudokuDifficulty.hard, 2), isFalse);
    });

    test('clearing a stage unlocks the next one in that difficulty only', () {
      final progress = const StageProgress().markCompleted(SudokuDifficulty.easy, 1);

      expect(progress.isCompleted(SudokuDifficulty.easy, 1), isTrue);
      expect(progress.isUnlocked(SudokuDifficulty.easy, 2), isTrue);
      expect(progress.isUnlocked(SudokuDifficulty.easy, 3), isFalse);
      expect(progress.isUnlocked(SudokuDifficulty.normal, 2), isFalse);
      expect(progress.completedCount(SudokuDifficulty.easy), 1);
    });

    test('json round-trips completed stage numbers', () {
      final original = const StageProgress()
          .markCompleted(SudokuDifficulty.easy, 1)
          .markCompleted(SudokuDifficulty.easy, 2)
          .markCompleted(SudokuDifficulty.hard, 1);

      final restored = StageProgress.fromJson(original.toJson());

      expect(restored.completedFor(SudokuDifficulty.easy), {1, 2});
      expect(restored.completedFor(SudokuDifficulty.normal), isEmpty);
      expect(restored.isCompleted(SudokuDifficulty.hard, 1), isTrue);
    });
  });
}
