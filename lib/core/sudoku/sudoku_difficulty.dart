import 'package:sudoku_game/core/config/game_balance.dart';

/// Sudoku difficulty levels and their properties
enum SudokuDifficulty {
  easy,
  normal,
  hard,
}

/// Difficulty configuration - separates game balance from UI
class DifficultyConfig {
  final SudokuDifficulty difficulty;

  // Number of clues to keep (given numbers)
  final int minClues;
  final int maxClues;

  // Number of empty cells
  final int minEmptyCells;
  final int maxEmptyCells;

  // Removal attempts
  final int maxRemovalAttempts;

  // StarLight reward for completing this difficulty
  final int starLightReward;

  // StarLight lost for one wrong number
  final int mistakeStarLightPenalty;

  // First-clear payout never drops below this
  final int minStarLightReward;

  // Time reduction for building restoration (in seconds)
  final int restorationTimeReduction;

  // Number of playable stages in this difficulty
  final int stageCount;

  DifficultyConfig({
    required this.difficulty,
    required this.minClues,
    required this.maxClues,
    required this.minEmptyCells,
    required this.maxEmptyCells,
    required this.maxRemovalAttempts,
    required this.starLightReward,
    required this.mistakeStarLightPenalty,
    required this.minStarLightReward,
    required this.restorationTimeReduction,
    required this.stageCount,
  });

  int remainingStarLight({
    required int hintsUsed,
    required int mistakesUsed,
  }) {
    final penalty = (hintsUsed * GameBalance.hintRewardPenalty) +
        (mistakesUsed * mistakeStarLightPenalty);
    return (starLightReward - penalty)
        .clamp(minStarLightReward, starLightReward);
  }

  static DifficultyConfig getConfig(SudokuDifficulty difficulty) {
    switch (difficulty) {
      case SudokuDifficulty.easy:
        return DifficultyConfig(
          difficulty: difficulty,
          minClues: 45,
          maxClues: 55,
          minEmptyCells: 26,
          maxEmptyCells: 36,
          maxRemovalAttempts: 100,
          starLightReward: GameBalance.easyStarLightReward,
          mistakeStarLightPenalty: GameBalance.easyMistakePenalty,
          minStarLightReward: GameBalance.easyMinStarLightReward,
          restorationTimeReduction: GameBalance.easyTimeReduction,
          stageCount: GameBalance.easyStageCount,
        );
      case SudokuDifficulty.normal:
        return DifficultyConfig(
          difficulty: difficulty,
          minClues: 35,
          maxClues: 45,
          minEmptyCells: 36,
          maxEmptyCells: 46,
          maxRemovalAttempts: 200,
          starLightReward: GameBalance.normalStarLightReward,
          mistakeStarLightPenalty: GameBalance.normalMistakePenalty,
          minStarLightReward: GameBalance.normalMinStarLightReward,
          restorationTimeReduction: GameBalance.normalTimeReduction,
          stageCount: GameBalance.normalStageCount,
        );
      case SudokuDifficulty.hard:
        return DifficultyConfig(
          difficulty: difficulty,
          minClues: 25,
          maxClues: 35,
          minEmptyCells: 46,
          maxEmptyCells: 56,
          maxRemovalAttempts: 300,
          starLightReward: GameBalance.hardStarLightReward,
          mistakeStarLightPenalty: GameBalance.hardMistakePenalty,
          minStarLightReward: GameBalance.hardMinStarLightReward,
          restorationTimeReduction: GameBalance.hardTimeReduction,
          stageCount: GameBalance.hardStageCount,
        );
    }
  }

  String getDisplayName() {
    switch (difficulty) {
      case SudokuDifficulty.easy:
        return 'Easy';
      case SudokuDifficulty.normal:
        return 'Normal';
      case SudokuDifficulty.hard:
        return 'Hard';
    }
  }

  String getKoreanName() {
    switch (difficulty) {
      case SudokuDifficulty.easy:
        return '쉬움';
      case SudokuDifficulty.normal:
        return '보통';
      case SudokuDifficulty.hard:
        return '어려움';
    }
  }
}
