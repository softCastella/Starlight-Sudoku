import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';

/// Cleared stage numbers for each difficulty. Stage 1 is always unlocked.
class StageProgress {
  const StageProgress({
    this.easyCompleted = const {},
    this.normalCompleted = const {},
    this.hardCompleted = const {},
  });

  final Set<int> easyCompleted;
  final Set<int> normalCompleted;
  final Set<int> hardCompleted;

  Set<int> completedFor(SudokuDifficulty difficulty) {
    return switch (difficulty) {
      SudokuDifficulty.easy => easyCompleted,
      SudokuDifficulty.normal => normalCompleted,
      SudokuDifficulty.hard => hardCompleted,
    };
  }

  int completedCount(SudokuDifficulty difficulty) =>
      completedFor(difficulty).length;

  bool isCompleted(SudokuDifficulty difficulty, int level) =>
      completedFor(difficulty).contains(level);

  bool isUnlocked(SudokuDifficulty difficulty, int level) {
    final stageCount = DifficultyConfig.getConfig(difficulty).stageCount;
    if (level < 1 || level > stageCount) return false;
    if (level == 1) return true;
    return isCompleted(difficulty, level - 1);
  }

  StageProgress markCompleted(SudokuDifficulty difficulty, int level) {
    if (isCompleted(difficulty, level)) return this;

    final next = {...completedFor(difficulty), level};
    return StageProgress(
      easyCompleted: difficulty == SudokuDifficulty.easy ? next : easyCompleted,
      normalCompleted:
          difficulty == SudokuDifficulty.normal ? next : normalCompleted,
      hardCompleted: difficulty == SudokuDifficulty.hard ? next : hardCompleted,
    );
  }

  Map<String, List<int>> toJson() => {
        'easy': easyCompleted.toList()..sort(),
        'normal': normalCompleted.toList()..sort(),
        'hard': hardCompleted.toList()..sort(),
      };

  factory StageProgress.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const StageProgress();

    Set<int> read(String key) =>
        ((json[key] as List?) ?? const []).map((value) => value as int).toSet();

    return StageProgress(
      easyCompleted: read('easy'),
      normalCompleted: read('normal'),
      hardCompleted: read('hard'),
    );
  }
}
