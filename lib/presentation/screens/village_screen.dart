import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/village/building_progress.dart';
import 'package:sudoku_game/core/village/village_story.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/screens/village_missions_screen.dart';
import 'package:sudoku_game/presentation/widgets/oval_image_button.dart';
import 'package:sudoku_game/presentation/widgets/play_viewport.dart';
import 'package:sudoku_game/presentation/widgets/village_map_widget.dart';

/// Shows the restoration progress unlocked by completed puzzles.
class VillageScreen extends StatelessWidget {
  const VillageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameNotifier>(
      builder: (context, gameNotifier, _) {
        final dawn = gameNotifier.villageDawn;
        final ink = Color.lerp(const Color(0xFFFBF7EC), const Color(0xFF24452D), dawn)!;
        final buildings = gameNotifier.buildings;
        final completedCount = buildings.where((building) => building.isComplete).length;

        return Scaffold(
          backgroundColor: Color.lerp(
            const Color(0xFF1C3340),
            const Color(0xFFF4F8EE),
            dawn,
          ),
          appBar: AppBar(
            title: const Text('별빛 마을'),
            backgroundColor: Colors.transparent,
            foregroundColor: ink,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 6, bottom: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () => _openMissions(context),
                      icon: const Icon(Icons.auto_awesome, color: Color(0xFFF5CC3D)),
                      label: Text(
                        '미션',
                        style: TextStyle(color: ink, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 2),
                    OvalImageButton(
                      label: '보기',
                      width: 72,
                      height: 26,
                      fontSize: 11,
                      onPressed: () => _openMissions(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: PlayViewport(
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$completedCount / ${buildings.length}개 복원',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color.lerp(
                                  const Color(0xFFB7D4C0),
                                  const Color(0xFF2E7D32),
                                  dawn,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '보유 스타라이트  ${gameNotifier.starLightBalance}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFF5CC3D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 900),
                              curve: Curves.easeOutCubic,
                              tween: Tween<double>(begin: 0, end: gameNotifier.villageDawn),
                              builder: (context, mapDawn, _) => VillageMapWidget(
                                buildings: buildings,
                                dawn: mapDawn,
                                expand: true,
                                onBuildingSelected: (building) => _showBuildingDetails(
                                  context,
                                  building,
                                ),
                              ),
                            ),
                            if (gameNotifier.isFirstVillageComplete)
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: _NextVillageUnlockCard(
                                    onOpen: () => _showNextVillageDialog(context),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openMissions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VillageMissionsScreen(),
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
      backgroundColor: const Color(0xFFFBF7EC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              building.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF24452D),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '복원 단계 ${building.level} / 5',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFFF5CC3D),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              story.headline,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF24452D),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              building.isComplete ? status : story.description,
              style: const TextStyle(height: 1.45, color: Color(0xFF4D6554)),
            ),
            if (!building.isComplete) ...[
              const SizedBox(height: 8),
              Text(status, style: const TextStyle(color: Color(0xFF4D6554))),
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
        color: const Color(0xF2FFF8E8),
        border: Border.all(color: const Color(0xFFF5CC3D), width: 1.6),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x55F5CC3D), blurRadius: 16, offset: Offset(0, 6)),
        ],
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
