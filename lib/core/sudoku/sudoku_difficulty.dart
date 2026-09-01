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

  // Time reduction for building restoration (in seconds)
  final int restorationTimeReduction;

  DifficultyConfig({
    required this.difficulty,
    required this.minClues,
    required this.maxClues,
    required this.minEmptyCells,
    required this.maxEmptyCells,
    required this.maxRemovalAttempts,
    required this.starLightReward,
    required this.restorationTimeReduction,
  });

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
          starLightReward: 80,
          restorationTimeReduction: 300, // 5 minutes
        );
      case SudokuDifficulty.normal:
        return DifficultyConfig(
          difficulty: difficulty,
          minClues: 35,
          maxClues: 45,
          minEmptyCells: 36,
          maxEmptyCells: 46,
          maxRemovalAttempts: 200,
          starLightReward: 120,
          restorationTimeReduction: 600, // 10 minutes
        );
      case SudokuDifficulty.hard:
        return DifficultyConfig(
          difficulty: difficulty,
          minClues: 25,
          maxClues: 35,
          minEmptyCells: 46,
          maxEmptyCells: 56,
          maxRemovalAttempts: 300,
          starLightReward: 180,
          restorationTimeReduction: 1200, // 20 minutes
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
}
