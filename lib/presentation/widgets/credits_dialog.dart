import 'package:flutter/material.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';
import 'package:sudoku_game/presentation/widgets/parchment_modal.dart';

class CreditsDialog extends StatelessWidget {
  const CreditsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierColor: const Color(0xCC152433),
      builder: (context) => const CreditsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nOf(context);
    return ParchmentModal(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onLongPress: () => PlayUiTune.instance.setPanelOpen(true),
            child: FitLabel(
              l10n.creditsTitle,
              style: PlayUi.titleStyle(),
              alignment: Alignment.center,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: PlayUi.rowGap),
          Text(
            l10n.creditsBody,
            textAlign: TextAlign.center,
            style: PlayUi.captionStyle().copyWith(
              fontSize: PlayUi.body,
              height: 1.45,
              color: PlayUi.muted,
            ),
          ),
          SizedBox(height: PlayUi.rowGap * 1.5),
          ParchmentModalButton(
            asset: ParchmentModal.continueAsset,
            label: l10n.close,
            color: PlayUi.ink,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
