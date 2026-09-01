import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/village/building_progress.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';

/// Lists the restoration missions available for each village building.
class VillageMissionsScreen extends StatelessWidget {
  const VillageMissionsScreen({super.key});

  static const Map<String, IconData> _icons = {
    'bakery': Icons.bakery_dining,
    'library': Icons.local_library,
    'fountain': Icons.water_drop,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('복원 미션')),
      body: Consumer<GameNotifier>(
        builder: (context, gameNotifier, _) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              '퍼즐을 완성해 StarLight를 모으세요',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 6),
            Text('현재 보유 ${gameNotifier.starLightBalance} StarLight'),
            const SizedBox(height: 20),
            ...gameNotifier.buildings.map(
              (building) => _MissionCard(
                building: building,
                icon: _icons[building.id] ?? Icons.home,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({required this.building, required this.icon});

  final BuildingProgress building;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = building.isComplete
        ? const Color(0xFF2F7D4A)
        : const Color(0xFF7E6B50);
    final status = building.isComplete
        ? '복원 완료'
        : '${building.remainingStarLight} StarLight 남음';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color.withValues(alpha: 0.30)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  building.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text('복원 단계 ${building.level} / 5 · $status'),
                const SizedBox(height: 9),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 550),
                  curve: Curves.easeOutCubic,
                  tween: Tween(begin: 0, end: building.progress),
                  builder: (context, progress, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      color: color,
                      backgroundColor: const Color(0xFFE7E5DD),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}