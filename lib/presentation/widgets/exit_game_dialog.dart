import 'package:flutter/material.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/widgets/parchment_modal.dart';

/// Title-screen confirm before leaving the Android task.
class ExitGameDialog extends StatelessWidget {
  const ExitGameDialog({super.key});

  static Future<bool> confirm(BuildContext context) async {
    final leave = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0xCC152433),
      builder: (context) => const ExitGameDialog(),
    );
    return leave == true;
  }

  @override
  Widget build(BuildContext context) {
    return PlayUiTokens(
      target: PlayUiTarget.exitGame,
      builder: (context) {
        final l10n = l10nOf(context);

        return ParchmentModal(
          target: PlayUiTarget.exitGame,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  l10n.exitGameTitle,
                  textAlign: TextAlign.center,
                  style: PlayUi.titleStyle(),
                ),
              ),
              SizedBox(height: PlayUi.rowGap * 2),
              ParchmentModalButtonRow(
                children: [
                  ParchmentModalButton(
                    asset: ParchmentModal.continueAsset,
                    label: l10n.stayInGame,
                    color: PlayUi.ink,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  ParchmentModalButton(
                    asset: ParchmentModal.exitAsset,
                    label: l10n.quitGame,
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
