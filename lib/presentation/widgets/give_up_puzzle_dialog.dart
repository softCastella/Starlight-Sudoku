import 'package:flutter/material.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/widgets/parchment_modal.dart';

/// Exit confirmation used only on the puzzle screen.
class GiveUpPuzzleDialog extends StatelessWidget {
  const GiveUpPuzzleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = l10nOf(context);

    return ParchmentModal(
      target: PlayUiTarget.giveUp,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.puzzleGiveUpTitle,
            textAlign: TextAlign.center,
            style: PlayUi.titleStyle(),
          ),
          SizedBox(height: PlayUi.rowGap),
          Text(
            l10n.puzzleGiveUpMessage,
            textAlign: TextAlign.center,
            style: PlayUi.bodyStyle(),
          ),
          SizedBox(height: PlayUi.rowGap * 1.5),
          Row(
            children: [
              Expanded(
                child: ParchmentModalButton(
                  asset: ParchmentModal.continueAsset,
                  label: l10n.keepPlaying,
                  color: PlayUi.ink,
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
              SizedBox(width: PlayUi.rowGap),
              Expanded(
                child: ParchmentModalButton(
                  asset: ParchmentModal.exitAsset,
                  label: l10n.exitPuzzle,
                  color: PlayUi.cream,
                  onPressed: () => Navigator.pop(context, true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
