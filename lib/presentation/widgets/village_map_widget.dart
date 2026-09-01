import 'package:flutter/material.dart';
import 'package:sudoku_game/core/village/building_progress.dart';
import 'package:sudoku_game/presentation/widgets/village_scene_backdrop.dart';

/// Illustrated village map with tappable restoration landmarks.
class VillageMapWidget extends StatelessWidget {
  const VillageMapWidget({
    super.key,
    required this.buildings,
    required this.dawn,
    required this.onBuildingSelected,
    this.expand = false,
  });

  final List<BuildingProgress> buildings;
  final double dawn;
  final ValueChanged<BuildingProgress> onBuildingSelected;
  final bool expand;

  static const Map<String, _MapLandmark> _landmarks = {
    'bakery': _MapLandmark(
      alignment: Alignment(-0.58, 0.28),
      glow: Color(0xFFC66A45),
      width: 118,
      height: 132,
    ),
    'library': _MapLandmark(
      alignment: Alignment(0.48, 0.18),
      glow: Color(0xFF4A7590),
      width: 128,
      height: 140,
    ),
    'fountain': _MapLandmark(
      alignment: Alignment(-0.02, 0.48),
      glow: Color(0xFF2C9DB7),
      width: 136,
      height: 118,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final map = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          VillageSceneBackdrop(dawn: dawn),
          ...buildings.map((building) {
            final landmark = _landmarks[building.id]!;
            return Align(
              alignment: landmark.alignment,
              child: _MapHotspot(
                building: building,
                landmark: landmark,
                dawn: dawn,
                onTap: () => onBuildingSelected(building),
              ),
            );
          }),
        ],
      ),
    );

    if (expand) return map;
    return AspectRatio(
      aspectRatio: VillageSceneBackdrop.paintingAspectRatio,
      child: map,
    );
  }
}

class _MapHotspot extends StatelessWidget {
  const _MapHotspot({
    required this.building,
    required this.landmark,
    required this.dawn,
    required this.onTap,
  });

  final BuildingProgress building;
  final _MapLandmark landmark;
  final double dawn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final restored = building.level > 0;
    final glow = restored ? landmark.glow : const Color(0xFFF5CC3D);

    return TweenAnimationBuilder<double>(
      key: ValueKey('${building.id}-${building.level}'),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutBack,
      tween: Tween(begin: 0.86, end: 1),
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Semantics(
        button: true,
        label: '${building.name}, 복원 단계 ${building.level}',
        child: InkWell(
          onTap: onTap,
          splashColor: glow.withValues(alpha: 0.18),
          highlightColor: glow.withValues(alpha: 0.10),
          customBorder: const StadiumBorder(),
          child: SizedBox(
            width: landmark.width,
            height: landmark.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (building.isComplete)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.auto_awesome, color: Color(0xFFF5CC3D), size: 16),
                  ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.lerp(
                      const Color(0xCC152433),
                      const Color(0xF2FFF8E8),
                      dawn,
                    ),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: glow.withValues(alpha: restored ? 0.85 : 0.45),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: glow.withValues(alpha: restored ? 0.28 : 0.08),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      '${building.name}  ${building.level}/5',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color.lerp(
                          const Color(0xFFFBF7EC),
                          const Color(0xFF24452D),
                          dawn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MapLandmark {
  const _MapLandmark({
    required this.alignment,
    required this.glow,
    required this.width,
    required this.height,
  });

  final Alignment alignment;
  final Color glow;
  final double width;
  final double height;
}
