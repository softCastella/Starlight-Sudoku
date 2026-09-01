import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';

/// Presents persistent play statistics for the current player profile.
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('플레이 통계')),
      body: Consumer<GameNotifier>(
        builder: (context, gameNotifier, _) {
          final statistics = gameNotifier.statistics;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _SummaryTile(
                icon: Icons.emoji_events,
                label: '완료한 퍼즐',
                value: '${statistics.completedPuzzles}판',
                color: const Color(0xFF2F7D4A),
              ),
              _SummaryTile(
                icon: Icons.auto_awesome,
                label: '누적 StarLight',
                value: '${gameNotifier.starLightBalance}',
                color: const Color(0xFFC78A00),
              ),
              _SummaryTile(
                icon: Icons.timer_outlined,
                label: '평균 완료 시간',
                value: _formatDuration(statistics.averagePlaySeconds),
                color: const Color(0xFF4A7590),
              ),
              const SizedBox(height: 20),
              Text(
                '난이도별 완료',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              ...SudokuDifficulty.values.map(
                (difficulty) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  leading: Icon(_difficultyIcon(difficulty)),
                  title: Text(difficulty.name.toUpperCase()),
                  trailing: Text(
                    '${statistics.completionsFor(difficulty)}판',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '$minutes분 ${remainder.toString().padLeft(2, '0')}초';
  }

  IconData _difficultyIcon(SudokuDifficulty difficulty) {
    return switch (difficulty) {
      SudokuDifficulty.easy => Icons.sentiment_satisfied_alt,
      SudokuDifficulty.normal => Icons.extension,
      SudokuDifficulty.hard => Icons.local_fire_department,
    };
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        border: Border.all(color: color.withValues(alpha: 0.30)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 14),
          Expanded(child: Text(label)),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}