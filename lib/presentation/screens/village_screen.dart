import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/village/building_progress.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/audio/game_bgm.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/screens/village_missions_screen.dart';
import 'package:sudoku_game/presentation/widgets/oval_image_button.dart';
import 'package:sudoku_game/presentation/widgets/play_viewport.dart';
import 'package:sudoku_game/presentation/widgets/trial_end_dialog.dart';
import 'package:sudoku_game/presentation/widgets/village_map_widget.dart';

/// Shows the restoration progress unlocked by completed puzzles.
class VillageScreen extends StatelessWidget {
  const VillageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TrialEndHost(
      child: BgmScope(
      cue: BgmCue.silence,
      child: Consumer<GameNotifier>(
      builder: (context, gameNotifier, _) {
        final dawn = gameNotifier.villageDawn;
        final nightSky = dawn < 1;
        final header = nightSky ? const Color(0xFFFBF7EC) : const Color(0xFF24452D);
        final headerShadow = nightSky
            ? const [Shadow(color: Color(0xCC000000), blurRadius: 8, offset: Offset(0, 1))]
            : const <Shadow>[];
        final buildings = gameNotifier.buildings;
        final completedCount = buildings.where((building) => building.isComplete).length;

        final l10n = l10nOf(context);
        return Scaffold(
          backgroundColor: Color.lerp(
            const Color(0xFF1C3340),
            const Color(0xFFF4F8EE),
            dawn,
          ),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              l10n.villageTitle,
              style: TextStyle(
                color: header,
                fontWeight: FontWeight.w700,
                shadows: headerShadow,
              ),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: header,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Center(
                  child: GestureDetector(
                    onTap: () => _openMissions(context),
                    child: SizedBox(
                      width: 96,
                      height: 32,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              OvalImageButton.asset,
                              fit: BoxFit.fill,
                              filterQuality: FilterQuality.medium,
                            ),
                          ),
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.auto_awesome,
                                    color: Color(0xFFC49612),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        l10n.mission,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Color(0xFF24452D),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0, end: dawn),
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
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 28),
                    child: _NextVillageUnlockCard(
                      onOpen: () => _showNextVillageDialog(context),
                    ),
                  ),
                ),
              SafeArea(
                child: PlayViewport(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, kToolbarHeight, 20, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.restoredCount(completedCount, buildings.length),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: header,
                              shadows: headerShadow,
                            ),
                          ),
                        ),
                        Text(
                          l10n.ownedStarlight(gameNotifier.starLightBalance),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFF5CC3D),
                            shadows: headerShadow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
    ),
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
    final l10n = l10nOf(context);
    final status = building.isComplete
        ? l10n.villageCompleted(building.id)
        : l10n.needsMoreStarlight(building.remainingStarLight);
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
              l10n.buildingName(building.id),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF24452D),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.restorationLevel(building.level),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFFF5CC3D),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.villageHeadline(building.id),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF24452D),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              building.isComplete ? status : l10n.villageDescription(building.id),
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
    final l10n = l10nOf(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.sailing, size: 42, color: Color(0xFF2C7890)),
        title: Text(l10n.harborUnlockTitle),
        content: Text(l10n.harborUnlockBody),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.towardHarbor),
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
    final l10n = l10nOf(context);
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.nextVillage, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text(l10n.newStoryOpened),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.harborStoryTooltip,
            onPressed: onOpen,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
