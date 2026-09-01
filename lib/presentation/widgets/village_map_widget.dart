import 'package:flutter/material.dart';
import 'package:sudoku_game/core/village/building_progress.dart';

/// Illustrated village map with tappable restoration landmarks.
class VillageMapWidget extends StatelessWidget {
  const VillageMapWidget({
    super.key,
    required this.buildings,
    required this.onBuildingSelected,
  });

  final List<BuildingProgress> buildings;
  final ValueChanged<BuildingProgress> onBuildingSelected;

  static const Map<String, _MapBuildingStyle> _styles = {
    'bakery': _MapBuildingStyle(
      icon: Icons.bakery_dining,
      alignment: Alignment(-0.62, -0.42),
      color: Color(0xFFC66A45),
    ),
    'library': _MapBuildingStyle(
      icon: Icons.local_library,
      alignment: Alignment(0.60, -0.34),
      color: Color(0xFF4A7590),
    ),
    'fountain': _MapBuildingStyle(
      icon: Icons.water_drop,
      alignment: Alignment(0.04, 0.47),
      color: Color(0xFF2C9DB7),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.88,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const CustomPaint(painter: _VillageGroundPainter()),
            ...buildings.map((building) {
              final style = _styles[building.id]!;
              return Align(
                alignment: style.alignment,
                child: _MapBuilding(
                  building: building,
                  style: style,
                  onTap: () => onBuildingSelected(building),
                ),
              );
            }),
            const Align(
              alignment: Alignment(0, -0.91),
              child: Text(
                '별빛 마을',
                style: TextStyle(
                  color: Color(0xFF24452D),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapBuilding extends StatelessWidget {
  const _MapBuilding({
    required this.building,
    required this.style,
    required this.onTap,
  });

  final BuildingProgress building;
  final _MapBuildingStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final restored = building.level > 0;
    final color = restored ? style.color : const Color(0xFF8F958C);

    return Semantics(
      button: true,
      label: '${building.name}, 복원 단계 ${building.level}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: SizedBox(
          width: 116,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.20),
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 3),
                    ),
                  ),
                  Icon(style.icon, color: color, size: 41),
                  if (building.isComplete)
                    const Positioned(
                      top: 0,
                      right: 4,
                      child: Icon(Icons.auto_awesome, color: Color(0xFFC78A00), size: 21),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                building.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: restored ? const Color(0xFF24452D) : const Color(0xFF667066),
                ),
              ),
              Text('Lv. ${building.level}/5', style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapBuildingStyle {
  const _MapBuildingStyle({
    required this.icon,
    required this.alignment,
    required this.color,
  });

  final IconData icon;
  final Alignment alignment;
  final Color color;
}

class _VillageGroundPainter extends CustomPainter {
  const _VillageGroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFD8EFC8));

    final pathPaint = Paint()
      ..color = const Color(0xFFF3E6BF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.13
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.5, size.height * 1.03)
      ..quadraticBezierTo(size.width * 0.47, size.height * 0.73, size.width * 0.52, size.height * 0.53)
      ..quadraticBezierTo(size.width * 0.72, size.height * 0.32, size.width * 0.83, size.height * 0.11);
    canvas.drawPath(path, pathPaint);

    final treePaint = Paint()..color = const Color(0xFF77A862);
    for (final point in [
      Offset(size.width * 0.12, size.height * 0.18),
      Offset(size.width * 0.85, size.height * 0.63),
      Offset(size.width * 0.17, size.height * 0.75),
      Offset(size.width * 0.83, size.height * 0.86),
    ]) {
      canvas.drawCircle(point, size.width * 0.055, treePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _VillageGroundPainter oldDelegate) => false;
}