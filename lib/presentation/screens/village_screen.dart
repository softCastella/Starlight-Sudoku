import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/village/building_progress.dart';
import 'package:sudoku_game/core/village/village_story.dart';
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
                  if (gameNotifier.isFirstVillageComplete) ...[
                    const SizedBox(height: 18),
                    _NextVillageUnlockCard(
                      onOpen: () => _showNextVillageDialog(context),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBuildingDetails(BuildContext context, BuildingProgress building) {
    final story = VillageStory.forBuilding(building.id);
    final status = building.isComplete
      ? story.completedDescription
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
            const SizedBox(height: 12),
            Text(story.headline, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(building.isComplete ? status : story.description),
            if (!building.isComplete) ...[
              const SizedBox(height: 8),
              Text(status),
            ],
          ],
        ),
      ),
    );
  }

  void _showNextVillageDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.sailing, size: 42, color: Color(0xFF2C7890)),
        title: const Text('달빛 항구 해금'),
        content: const Text(
          '별빛 마을이 다시 빛나기 시작했습니다. 다음 이야기는 바닷바람이 부는 달빛 항구에서 이어집니다.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('항구를 향해'),
          ),
        ],
      ),
    );
  }
}

class _NextVillageUnlockCard extends StatelessWidget {
  const _NextVillageUnlockCard({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F4),
        border: Border.all(color: const Color(0xFF79BFC6)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.sailing, color: Color(0xFF2C7890), size: 34),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('다음 마을: 달빛 항구', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 3),
                Text('새로운 이야기가 열렸습니다.'),
              ],
            ),
          ),
          IconButton(
            tooltip: '달빛 항구 이야기 보기',
            onPressed: onOpen,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}