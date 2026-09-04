import 'package:flutter/material.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/widgets/parchment_modal.dart';

/// Title-screen confirm before leaving the Android task.
class ExitGameDialog extends StatelessWidget {
  const ExitGameDialog({super.key});

  static const _ink = Color(0xFF24452D);
  static const _cream = Color(0xFFFBF7EC);

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
    final l10n = l10nOf(context);

    return ParchmentModal(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              l10n.exitGameTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ParchmentModalButton(
                  asset: ParchmentModal.continueAsset,
                  label: l10n.stayInGame,
                  color: _ink,
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ParchmentModalButton(
                  asset: ParchmentModal.exitAsset,
                  label: l10n.quitGame,
                  color: _cream,
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
