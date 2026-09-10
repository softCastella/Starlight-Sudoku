import 'package:flutter/material.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/widgets/parchment_modal.dart';

/// Covers the puzzle while [GameNotifier.isPaused] is true.
class PausePuzzleOverlay extends StatelessWidget {
  const PausePuzzleOverlay({super.key, required this.onResume});

  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    return PlayUiTokens(
      target: PlayUiTarget.giveUp,
      builder: (context) {
        final l10n = l10nOf(context);

        return Material(
          color: const Color(0xCC152433),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: PlayUi.modalInset),
                child: ParchmentModal(
                  target: PlayUiTarget.giveUp,
                  embedded: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.pauseTitle,
                        textAlign: TextAlign.center,
                        style: PlayUi.titleStyle(),
                      ),
                      SizedBox(height: PlayUi.rowGap * 1.5),
                      ParchmentModalButton(
                        asset: ParchmentModal.continueAsset,
                        label: l10n.keepPlaying,
                        color: PlayUi.ink,
                        onPressed: onResume,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
