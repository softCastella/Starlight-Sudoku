import 'package:flutter/material.dart';
import 'package:sudoku_game/core/village/building_progress.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
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
    final l10n = l10nOf(context);
    final name = l10n.buildingName(building.id);
    final dayLook = dawn >= 1;
    final pill = dayLook ? const Color(0xF2FFF8E8) : const Color(0xE6152433);
    final labelColor = dayLook ? const Color(0xFF24452D) : const Color(0xFFFBF7EC);

    return Semantics(
      button: true,
      label: l10n.buildingSemantics(name, building.level),
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
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: landmark.width),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: pill,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: glow.withValues(alpha: restored ? 0.9 : 0.55),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        l10n.buildingLevelLabel(name, building.level),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: labelColor,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
