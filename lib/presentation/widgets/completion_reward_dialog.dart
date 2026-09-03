import 'package:flutter/material.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
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

  static const _ink = Color(0xFF24452D);
  static const _muted = Color(0xFF4D6554);
  static const _cream = Color(0xFFFBF7EC);
  static const _gold = Color(0xFFF5CC3D);

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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isReplay ? l10n.alreadyCleared : l10n.starlightArrived,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.35,
              color: _muted,
            ),
          ),
          if (!isReplay) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: _gold,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '+ $starLight StarLight',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _gold,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 4),
          Text(
            l10n.elapsedTime(elapsedTimeLabel),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: _muted,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ParchmentModalButton(
                  asset: ParchmentModal.continueAsset,
                  label: l10n.viewVillage,
                  color: _ink,
                  onPressed: onViewVillage,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ParchmentModalButton(
                  asset: ParchmentModal.exitAsset,
                  label: primaryLabel,
                  color: _cream,
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
