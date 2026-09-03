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

  static const _gold = Color(0xFFE0B422);

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
              const Icon(Icons.auto_awesome, color: _gold, size: 20),
              const SizedBox(width: 4),
              const Text(
                'StarLight',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _gold,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                reward.toString().padLeft(3, '0'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _gold,
                ),
              ),
              SizedBox(
                width: 32,
                child: _PenaltyFlash(
                  token: gameNotifier.mistakeFlashId,
                  amount: gameNotifier.lastMistakePenalty,
                ),
              ),
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

class _PenaltyFlash extends StatefulWidget {
  const _PenaltyFlash({
    required this.token,
    required this.amount,
  });

  final int token;
  final int amount;

  @override
  State<_PenaltyFlash> createState() => _PenaltyFlashState();
}

class _PenaltyFlashState extends State<_PenaltyFlash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _opacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 14,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 36),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 50,
      ),
    ]).animate(_controller);
    if (widget.token > 0 && widget.amount > 0) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_PenaltyFlash oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.token != oldWidget.token &&
        widget.token > 0 &&
        widget.amount > 0) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.amount <= 0) return const SizedBox.shrink();
    return FadeTransition(
      opacity: _opacity,
      child: Text(
        '-${widget.amount}',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Color(0xFFC4452D),
        ),
      ),
    );
  }
}
