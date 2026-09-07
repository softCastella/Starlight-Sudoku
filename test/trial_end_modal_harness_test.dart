import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/config/game_balance.dart';
import 'package:sudoku_game/core/progress/active_game_snapshot.dart';
import 'package:sudoku_game/core/progress/player_statistics.dart';
import 'package:sudoku_game/core/progress/stage_progress.dart';
import 'package:sudoku_game/data/local/game_progress_store.dart';
import 'package:sudoku_game/l10n/app_localizations.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/widgets/parchment_modal.dart';
import 'package:sudoku_game/presentation/widgets/trial_end_dialog.dart';

void main() {
  testWidgets(
    'final trial stage shows the Google Play modal once, then remembers it',
    (tester) async {
      final completedLevels = Set<int>.from(
        Iterable<int>.generate(
          GameBalance.trialStageCount,
          (index) => index + 1,
        ),
      );
      final store = _TrialProgressStore(
        StageProgress(easyCompleted: completedLevels),
      );
      final game = GameNotifier(progressStore: store);
      await game.loadProgress();

      expect(game.isTrialComplete, isTrue);
      expect(game.hasSeenTrialEnd, isFalse);
      expect(Uri.parse(TrialEndDialog.playStoreWebUrl).host, 'play.google.com');
      expect(
        Uri.parse(TrialEndDialog.playStoreWebUrl).queryParameters['id'],
        TrialEndDialog.playStorePackage,
      );

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChangeNotifierProvider<GameNotifier>.value(
            value: game,
            child: const TrialEndHost(
              child: Scaffold(
                body: SizedBox.expand(key: Key('trial-end-host-child')),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TrialEndDialog), findsOneWidget);
      expect(find.byKey(const Key('trial-end-store')), findsOneWidget);
      expect(find.byKey(const Key('trial-end-close')), findsOneWidget);
      final storeButton = tester.widget<ParchmentModalButton>(
        find.byKey(const Key('trial-end-store')),
      );
      expect(storeButton.onPressed, isNotNull);

      final hostContext = tester.element(
        find.byKey(const Key('trial-end-host-child')),
      );
      await tester.tap(find.byKey(const Key('trial-end-close')));
      await tester.pumpAndSettle();

      expect(game.hasSeenTrialEnd, isTrue);
      expect(store.saveSeenCalls, 1);
      expect(find.byType(TrialEndDialog), findsNothing);

      await TrialEndDialog.maybeShow(hostContext);
      await tester.pumpAndSettle();

      expect(find.byType(TrialEndDialog), findsNothing);
      expect(store.saveSeenCalls, 1);
    },
  );
}

class _TrialProgressStore extends GameProgressStore {
  _TrialProgressStore(this.progress);

  final StageProgress progress;
  int saveSeenCalls = 0;

  @override
  Future<
    ({
      int starLightBalance,
      PlayerStatistics statistics,
      StageProgress stageProgress,
      bool hasSeenOpeningStory,
      bool hasSeenTrialEnd,
    })
  >
  load() async {
    return (
      starLightBalance: 0,
      statistics: const PlayerStatistics(),
      stageProgress: progress,
      hasSeenOpeningStory: true,
      hasSeenTrialEnd: false,
    );
  }

  @override
  Future<ActiveGameSnapshot?> loadActiveGame() async => null;

  @override
  Future<void> saveHasSeenTrialEnd() async {
    saveSeenCalls++;
  }
}
