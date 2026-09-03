import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/widgets/parchment_modal.dart';

class TrialEndDialog extends StatefulWidget {
  const TrialEndDialog({super.key});

  static const _ink = Color(0xFF24452D);
  static const _muted = Color(0xFF4D6554);
  static const _cream = Color(0xFFFBF7EC);
  static const _gold = Color(0xFFF5CC3D);

  @override
  State<TrialEndDialog> createState() => _TrialEndDialogState();
}

class _TrialEndDialogState extends State<TrialEndDialog> {
  int _rating = 0;
  bool _sending = false;

  Future<void> _send() async {
    if (_rating < 1 || _sending) return;
    setState(() => _sending = true);
    try {
      final review = InAppReview.instance;
      if (await review.isAvailable()) {
        await review.requestReview();
      }
    } catch (_) {}
    if (!mounted) return;
    Navigator.pop(context);
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: TrialEndDialog._ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.trialEndMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: TrialEndDialog._muted,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => _rating = i),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  icon: Icon(
                    i <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: TrialEndDialog._gold,
                    size: 32,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Opacity(
                  opacity: _rating < 1 || _sending ? 0.45 : 1,
                  child: IgnorePointer(
                    ignoring: _rating < 1 || _sending,
                    child: ParchmentModalButton(
                      asset: ParchmentModal.continueAsset,
                      label: l10n.sendReview,
                      color: TrialEndDialog._ink,
                      onPressed: _send,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ParchmentModalButton(
                  asset: ParchmentModal.exitAsset,
                  label: l10n.close,
                  color: TrialEndDialog._cream,
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
