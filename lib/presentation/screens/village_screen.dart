import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/village/building_progress.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/screens/village_missions_screen.dart';
import 'package:sudoku_game/presentation/widgets/village_map_widget.dart';

/// Shows the restoration progress unlocked by completed puzzles.
class VillageScreen extends StatelessWidget {
  const VillageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('우리 마을')),
      body: Consumer<GameNotifier>(
        builder: (context, gameNotifier, _) {
          final buildings = gameNotifier.buildings;
          final completedCount = buildings.where((building) => building.isComplete).length;

          return Container(
            color: const Color(0xFFF4F8EE),
            child: SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    '별빛으로 되살아나는 마을',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF24452D),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$completedCount / ${buildings.length}개 건물이 복원되었습니다',
                    style: TextStyle(color: Colors.green[800]),
                  ),
                  const SizedBox(height: 16),
                  VillageMapWidget(
                    buildings: buildings,
                    onBuildingSelected: (building) => _showBuildingDetails(
                      context,
                      building,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      '보유 StarLight  ${gameNotifier.starLightBalance}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC78A00),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: FilledButton.tonalIcon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VillageMissionsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.assignment),
                      label: const Text('복원 미션 보기'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBuildingDetails(BuildContext context, BuildingProgress building) {
    final status = building.isComplete
        ? '${building.name} 복원이 완료되었습니다.'
        : '${building.remainingStarLight} StarLight가 더 필요합니다.';
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(building.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('복원 단계 ${building.level} / 5'),
            const SizedBox(height: 4),
            Text(status),
          ],
        ),
      ),
    );
  }
}