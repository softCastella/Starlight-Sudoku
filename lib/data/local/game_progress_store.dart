import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/core/progress/active_game_snapshot.dart';
import 'package:sudoku_game/core/progress/player_statistics.dart';

/// Persists account-wide progress independently from the active puzzle.
class GameProgressStore {
  static const _starLightKey = 'star_light_balance';
  static const _completedPuzzlesKey = 'completed_puzzles';
  static const _totalPlaySecondsKey = 'total_play_seconds';
  static const _easyCompletionsKey = 'easy_completions';
  static const _normalCompletionsKey = 'normal_completions';
  static const _hardCompletionsKey = 'hard_completions';
  static const _activeGameKey = 'active_game';

  Future<({int starLightBalance, PlayerStatistics statistics})> load() async {
    final preferences = await SharedPreferences.getInstance();
    return (
      starLightBalance: preferences.getInt(_starLightKey) ?? 0,
      statistics: PlayerStatistics(
        completedPuzzles: preferences.getInt(_completedPuzzlesKey) ?? 0,
        totalPlaySeconds: preferences.getInt(_totalPlaySecondsKey) ?? 0,
        easyCompletions: preferences.getInt(_easyCompletionsKey) ?? 0,
        normalCompletions: preferences.getInt(_normalCompletionsKey) ?? 0,
        hardCompletions: preferences.getInt(_hardCompletionsKey) ?? 0,
      ),
    );
  }

  Future<void> save({
    required int starLightBalance,
    required PlayerStatistics statistics,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.wait([
      preferences.setInt(_starLightKey, starLightBalance),
      preferences.setInt(_completedPuzzlesKey, statistics.completedPuzzles),
      preferences.setInt(_totalPlaySecondsKey, statistics.totalPlaySeconds),
      preferences.setInt(_easyCompletionsKey, statistics.easyCompletions),
      preferences.setInt(_normalCompletionsKey, statistics.normalCompletions),
      preferences.setInt(_hardCompletionsKey, statistics.hardCompletions),
    ]);
  }

  Future<ActiveGameSnapshot?> loadActiveGame() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedSnapshot = preferences.getString(_activeGameKey);
    if (encodedSnapshot == null) return null;

    try {
      return ActiveGameSnapshot.fromJson(
        jsonDecode(encodedSnapshot) as Map<String, dynamic>,
      );
    } on FormatException {
      await preferences.remove(_activeGameKey);
      return null;
    }
  }

  Future<void> saveActiveGame(ActiveGameSnapshot snapshot) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_activeGameKey, jsonEncode(snapshot.toJson()));
  }

  Future<void> clearActiveGame() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_activeGameKey);
  }
}