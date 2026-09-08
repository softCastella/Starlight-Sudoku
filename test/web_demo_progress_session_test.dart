import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/core/config/game_balance.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';
import 'package:sudoku_game/data/local/game_progress_store.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'a new web demo tab clears game progress but keeps app settings',
    () async {
      SharedPreferences.setMockInitialValues({
        'star_light_balance': 100,
        'completed_puzzles': 10,
        'easy_completions': 10,
        'stage_progress': '{"easy":[1,2,3,4,5,6,7,8,9,10]}',
        'active_game': '{}',
        'has_seen_opening_story': true,
        'has_seen_trial_end': true,
        'settings_bgm_on': false,
        'settings_user_id': 'SS-KEEP-ME',
      });
      final store = GameProgressStore(
        isWebDemo: true,
        beginDemoSession: () => true,
      );

      final progress = await store.load();
      final preferences = await SharedPreferences.getInstance();

      expect(progress.starLightBalance, 0);
      expect(progress.statistics.completedPuzzles, 0);
      expect(progress.stageProgress.easyCompleted, isEmpty);
      expect(progress.hasSeenOpeningStory, isFalse);
      expect(progress.hasSeenTrialEnd, isFalse);
      expect(await store.loadActiveGame(), isNull);
      expect(preferences.getBool('settings_bgm_on'), isFalse);
      expect(preferences.getString('settings_user_id'), 'SS-KEEP-ME');
    },
  );

  test('a reload in the same web demo tab preserves progress', () async {
    SharedPreferences.setMockInitialValues({
      'star_light_balance': 10,
      'stage_progress': '{"easy":[1]}',
    });
    final store = GameProgressStore(
      isWebDemo: true,
      beginDemoSession: () => false,
    );

    final progress = await store.load();

    expect(progress.starLightBalance, 10);
    expect(progress.stageProgress.easyCompleted, {1});
  });

  test('completed display never exceeds the configured stage count', () async {
    SharedPreferences.setMockInitialValues({
      'stage_progress': '{"easy":[1,2,3,4,5,6,7,8,9,10]}',
    });
    final game = GameNotifier(
      progressStore: GameProgressStore(
        isWebDemo: false,
        beginDemoSession: () => false,
      ),
    );
    await game.loadProgress();

    expect(
      game.completedStageCount(SudokuDifficulty.easy),
      GameBalance.easyStageCount,
    );
  });
}
