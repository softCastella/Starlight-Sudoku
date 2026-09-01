import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';

/// Immutable record of completed Sudoku puzzles and play time.
class PlayerStatistics {
  const PlayerStatistics({
    this.completedPuzzles = 0,
    this.totalPlaySeconds = 0,
    this.easyCompletions = 0,
    this.normalCompletions = 0,
    this.hardCompletions = 0,
  });

  final int completedPuzzles;
  final int totalPlaySeconds;
  final int easyCompletions;
  final int normalCompletions;
  final int hardCompletions;

  int get averagePlaySeconds =>
      completedPuzzles == 0 ? 0 : totalPlaySeconds ~/ completedPuzzles;

  int completionsFor(SudokuDifficulty difficulty) {
    return switch (difficulty) {
      SudokuDifficulty.easy => easyCompletions,
      SudokuDifficulty.normal => normalCompletions,
      SudokuDifficulty.hard => hardCompletions,
    };
  }

  PlayerStatistics recordCompletion(
    SudokuDifficulty difficulty,
    int elapsedSeconds,
  ) {
    return PlayerStatistics(
      completedPuzzles: completedPuzzles + 1,
      totalPlaySeconds: totalPlaySeconds + elapsedSeconds,
      easyCompletions: easyCompletions + (difficulty == SudokuDifficulty.easy ? 1 : 0),
      normalCompletions:
          normalCompletions + (difficulty == SudokuDifficulty.normal ? 1 : 0),
      hardCompletions: hardCompletions + (difficulty == SudokuDifficulty.hard ? 1 : 0),
    );
  }
}