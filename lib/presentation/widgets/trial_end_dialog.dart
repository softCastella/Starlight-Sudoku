import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/audio/game_bgm.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/widgets/parchment_modal.dart';
import 'package:url_launcher/url_launcher.dart';

class TrialEndDialog extends StatefulWidget {
  const TrialEndDialog({super.key});

  static const playStorePackage = 'com.tychespark.starlightsudoku';
  static const _market = 'market://details?id=$playStorePackage';
  static const _webStore =
      'https://play.google.com/store/apps/details?id=$playStorePackage';

  static bool _showing = false;

  static Future<void> maybeShow(BuildContext context) async {
    if (_showing) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    final game = context.read<GameNotifier>();
    if (!game.isTrialComplete || game.hasSeenTrialEnd) return;
    _showing = true;
    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: const Color(0xCC152433),
        builder: (context) => const TrialEndDialog(),
      );
      if (context.mounted) await game.markTrialEndSeen();
    } finally {
      _showing = false;
    }
  }

  @override
  State<TrialEndDialog> createState() => _TrialEndDialogState();
}

class _TrialEndDialogState extends State<TrialEndDialog> {
  /// Play Store only after 「이동하기」. Do not open on show. Back from Store returns here.
  Future<void> _openPlayStore() async {
    try {
      await InAppReview.instance.openStoreListing();
      return;
    } catch (_) {}
    final market = Uri.parse(TrialEndDialog._market);
    if (await canLaunchUrl(market)) {
      await launchUrl(market, mode: LaunchMode.externalApplication);
      return;
    }
    await launchUrl(
      Uri.parse(TrialEndDialog._webStore),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nOf(context);

    return ParchmentModal(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.trialEndTitle,
            textAlign: TextAlign.center,
            style: PlayUi.titleStyle(),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.trialEndMessage,
            textAlign: TextAlign.center,
            style: PlayUi.captionStyle().copyWith(fontSize: PlayUi.body, height: 1.4),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ParchmentModalButton(
                  asset: ParchmentModal.exitAsset,
                  label: l10n.sendReview,
                  color: PlayUi.cream,
                  onPressed: _openPlayStore,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ParchmentModalButton(
                  asset: ParchmentModal.continueAsset,
                  label: l10n.close,
                  color: PlayUi.ink,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shows [TrialEndDialog] on the stage list after a trial clear.
class TrialEndHost extends StatefulWidget {
  const TrialEndHost({super.key, required this.child});

  final Widget child;

  @override
  State<TrialEndHost> createState() => _TrialEndHostState();
}

class _TrialEndHostState extends State<TrialEndHost> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      GameBgm.routeObserver.subscribe(this, route);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) TrialEndDialog.maybeShow(context);
    });
  }

  @override
  void dispose() {
    GameBgm.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) TrialEndDialog.maybeShow(context);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
