import 'package:flutter/material.dart';

/// Celebrates a completed puzzle and reveals the earned StarLight.
class CompletionRewardDialog extends StatelessWidget {
  const CompletionRewardDialog({
    super.key,
    required this.starLight,
    required this.elapsedTimeLabel,
    required this.onViewVillage,
    required this.onClose,
  });

  final int starLight;
  final String elapsedTimeLabel;
  final VoidCallback onViewVillage;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('퍼즐 완성!')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            tween: Tween(begin: 0.55, end: 1),
            builder: (context, scale, child) => Transform.scale(
              scale: scale,
              child: child,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFFC78A00),
              size: 68,
            ),
          ),
          const SizedBox(height: 12),
          const Text('마을에 별빛이 도착했어요.'),
          const SizedBox(height: 18),
          TweenAnimationBuilder<int>(
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            tween: IntTween(begin: 0, end: starLight),
            builder: (context, value, _) => Text(
              '+$value StarLight',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC78A00),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text('소요 시간  $elapsedTimeLabel'),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton.icon(
          onPressed: onViewVillage,
          icon: const Icon(Icons.location_city),
          label: const Text('마을 보기'),
        ),
        FilledButton(onPressed: onClose, child: const Text('완료')),
      ],
    );
  }
}