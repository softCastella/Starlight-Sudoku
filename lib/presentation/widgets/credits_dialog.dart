import 'package:flutter/material.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';
import 'package:sudoku_game/presentation/screens/play_ui_tune_screen.dart';
import 'package:sudoku_game/presentation/widgets/parchment_modal.dart';

/// Title / game name / copyright / close are centered.
/// Credit lines stay left-aligned as a block.
class CreditsCopy {
  const CreditsCopy({
    required this.gameName,
    required this.body,
    required this.copyright,
  });

  final String gameName;
  final String body;
  final String copyright;

  static CreditsCopy parse(String raw) {
    final parts = raw
        .split('\n\n')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.length < 3) {
      return CreditsCopy(gameName: '', body: raw.trim(), copyright: '');
    }
    return CreditsCopy(
      gameName: parts.first,
      body: parts.sublist(1, parts.length - 1).join('\n\n'),
      copyright: parts.last,
    );
  }
}

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
    return PlayUiTokens(
      target: PlayUiTarget.credits,
      builder: (context) {
        final l10n = l10nOf(context);
        final copy = CreditsCopy.parse(l10n.creditsBody);
        // Hug content — fixed 0.98 left empty bottom under short copy.
        return ParchmentModal(
          target: PlayUiTarget.credits,
          alignment: Alignment.topCenter,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Same top air as the old 0.98 window: 12% of (width / 0.98).
              // When hugging, keep ~40 bottom clear of the scroll art.
              final topAir = constraints.maxWidth.isFinite
                  ? (constraints.maxWidth / 0.98) * 0.12
                  : PlayUi.modalPadY;
              final bottomAir =
                  (PlayUi.kModalPadY - PlayUi.modalPadBottom).clamp(0.0, 40.0);
              return Padding(
                padding: EdgeInsets.only(top: topAir, bottom: bottomAir),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onLongPress: PlayUiTune.isEditorEnabled
                          ? () => PlayUiTuneScreen.open(context)
                          : null,
                      child: FitLabel(
                        l10n.creditsTitle,
                        style: PlayUi.titleStyle(),
                        alignment: Alignment.center,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: PlayUi.rowGap * 0.75),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        copy.gameName,
                        textAlign: TextAlign.center,
                        style: PlayUi.labelStyle(),
                      ),
                    ),
                    SizedBox(height: PlayUi.rowGap * 1.5),
                    Align(
                      alignment: Alignment.center,
                      child: IntrinsicWidth(
                        child: Text(
                          copy.body,
                          textAlign: TextAlign.left,
                          style: PlayUi.bodyStyle(color: PlayUi.ink).copyWith(
                            fontSize: PlayUi.body - 1,
                            height: 1.25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: PlayUi.rowGap * 1.5),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        copy.copyright,
                        textAlign: TextAlign.center,
                        style: PlayUi.captionStyle(),
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
            },
          ),
        );
      },
    );
  }
}
