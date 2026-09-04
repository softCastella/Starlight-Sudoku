import 'package:flutter/material.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/widgets/parchment_modal.dart';

/// Celebrates a completed puzzle and reveals the earned StarLight.
class CompletionRewardDialog extends StatelessWidget {
  const CompletionRewardDialog({
    super.key,
    required this.starLight,
    required this.elapsedTimeLabel,
    this.isReplay = false,
    this.onNextLevel,
    required this.onViewVillage,
    required this.onClose,
  });

  final int starLight;
  final String elapsedTimeLabel;
  final bool isReplay;
  final VoidCallback? onNextLevel;
  final VoidCallback onViewVillage;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = l10nOf(context);
    final primaryLabel = onNextLevel != null ? l10n.next : l10n.done;
    final primaryAction = onNextLevel ?? onClose;

    return ParchmentModal(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.puzzleComplete,
            textAlign: TextAlign.center,
            style: PlayUi.titleStyle(),
          ),
          SizedBox(height: PlayUi.rowGap),
          Text(
            isReplay ? l10n.alreadyCleared : l10n.starlightArrived,
            textAlign: TextAlign.center,
            style: PlayUi.bodyStyle(),
          ),
          if (!isReplay) ...[
            SizedBox(height: PlayUi.rowGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: PlayUi.gold,
                  size: PlayUi.title,
                ),
                const SizedBox(width: 4),
                Text(
                  '+ $starLight StarLight',
                  style: PlayUi.titleStyle(color: PlayUi.gold),
                ),
              ],
            ),
          ],
          SizedBox(height: PlayUi.rowGap / 2),
          Text(
            l10n.elapsedTime(elapsedTimeLabel),
            textAlign: TextAlign.center,
            style: PlayUi.captionStyle(),
          ),
          SizedBox(height: PlayUi.rowGap * 1.5),
          Row(
            children: [
              Expanded(
                child: ParchmentModalButton(
                  asset: ParchmentModal.continueAsset,
                  label: l10n.viewVillage,
                  color: PlayUi.ink,
                  onPressed: onViewVillage,
                ),
              ),
              SizedBox(width: PlayUi.rowGap),
              Expanded(
                child: ParchmentModalButton(
                  asset: ParchmentModal.exitAsset,
                  label: primaryLabel,
                  color: PlayUi.cream,
                  onPressed: primaryAction,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
