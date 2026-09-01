import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';

/// 게임 타이머 위젯
class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        context.read<GameNotifier>().incrementTimer();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameNotifier>(
      builder: (context, gameNotifier, _) {
        final seconds = gameNotifier.elapsedSeconds;
        final hours = seconds ~/ 3600;
        final minutes = (seconds % 3600) ~/ 60;
        final secs = seconds % 60;

        final timeString = hours > 0
            ? '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}'
            : '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
        final config = DifficultyConfig.getConfig(gameNotifier.difficulty);
        final reward = gameNotifier.totalStarLight > 0
            ? gameNotifier.totalStarLight
            : gameNotifier.potentialStarLightReward;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F2E6),
            border: Border.all(color: const Color(0xFFD8CBB0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              const Icon(Icons.auto_awesome, color: Color(0xFFF5CC3D), size: 18),
              const SizedBox(width: 3),
              const Text(
                'StarLight',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF5CC3D),
                ),
              ),
              const SizedBox(width: 4),
              Text('$reward', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF5CC3D))),
              if (gameNotifier.hintsUsed > 0) ...[
                const SizedBox(width: 6),
                Text(
                  '-${gameNotifier.hintsUsed * GameNotifier.hintRewardPenalty}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF9A4D31)),
                ),
              ],
              const Spacer(),
              Text(
                config.getDisplayName(),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 9),
                child: SizedBox(
                  height: 20,
                  child: VerticalDivider(color: Color(0xFFD8CBB0)),
                ),
              ),
              const Icon(Icons.timer_outlined, color: Color(0xFF3C6B58), size: 20),
              const SizedBox(width: 6),
              Text(
                timeString,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF24452D),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
