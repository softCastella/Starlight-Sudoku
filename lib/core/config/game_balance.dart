/// Central place for all game balance numbers.
/// All game constants are defined here, not hardcoded in UI/Controllers.
class GameBalance {
  // StarLight rewards (for completing Sudoku)
  static const int easyStarLightReward = 80;
  static const int normalStarLightReward = 120;
  static const int hardStarLightReward = 180;

  // Building restoration time reduction (in seconds)
  static const int easyTimeReduction = 300; // 5 minutes
  static const int normalTimeReduction = 600; // 10 minutes
  static const int hardTimeReduction = 1200; // 20 minutes

  // Building restoration durations (in seconds)
  // These can be overridden for testing
  static int bakeryLevel1Duration = 0; // Instant
  static int bakeryLevel2Duration = 300; // 5 minutes
  static int bakeryLevel3Duration = 900; // 15 minutes
  static int bakeryLevel4Duration = 1800; // 30 minutes
  static int bakeryLevel5Duration = 3600; // 1 hour

  // Initial StarLight amount
  static const int initialStarLight = 0;

  // Test mode (allows faster timers)
  static bool testMode = false;

  /// Get StarLight reward for completing puzzle
  static int getStarLightReward(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return easyStarLightReward;
      case 'Normal':
        return normalStarLightReward;
      case 'Hard':
        return hardStarLightReward;
      default:
        return normalStarLightReward;
    }
  }

  /// Get time reduction for difficulty
  static int getTimeReduction(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return easyTimeReduction;
      case 'Normal':
        return normalTimeReduction;
      case 'Hard':
        return hardTimeReduction;
      default:
        return normalTimeReduction;
    }
  }

  /// Reset for testing
  static void resetToDefaults() {
    bakeryLevel1Duration = 0;
    bakeryLevel2Duration = 300;
    bakeryLevel3Duration = 900;
    bakeryLevel4Duration = 1800;
    bakeryLevel5Duration = 3600;
  }
}
