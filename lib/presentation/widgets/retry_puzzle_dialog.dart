import 'package:flutter/material.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/widgets/parchment_modal.dart';

/// Confirm before resetting the current puzzle board.
class RetryPuzzleDialog extends StatelessWidget {
  const RetryPuzzleDialog({super.key});

  static Future<bool> confirm(BuildContext context) async {
    final retry = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0xCC152433),
      builder: (context) => const RetryPuzzleDialog(),
    );
    return retry == true;
  }

  @override
  Widget build(BuildContext context) {
    return PlayUiTokens(
      target: PlayUiTarget.giveUp,
      builder: (context) {
        final l10n = l10nOf(context);

        return ParchmentModal(
          target: PlayUiTarget.giveUp,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.retryTitle,
                textAlign: TextAlign.center,
                style: PlayUi.titleStyle(),
              ),
              SizedBox(height: PlayUi.rowGap),
              Text(
                l10n.retryMessage,
                textAlign: TextAlign.center,
                style: PlayUi.bodyStyle(),
              ),
              SizedBox(height: PlayUi.rowGap * 1.5),
              ParchmentModalButtonRow(
                children: [
                  ParchmentModalButton(
                    asset: ParchmentModal.continueAsset,
                    label: l10n.keepPlaying,
                    color: PlayUi.ink,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  ParchmentModalButton(
                    asset: ParchmentModal.exitAsset,
                    label: l10n.retryConfirm,
                    color: PlayUi.cream,
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
