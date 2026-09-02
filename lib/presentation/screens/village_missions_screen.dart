import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/village/building_progress.dart';
import 'package:sudoku_game/core/village/village_story.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/widgets/play_viewport.dart';
import 'package:sudoku_game/presentation/widgets/village_scene_backdrop.dart';

/// Lists the restoration missions available for each village building.
class VillageMissionsScreen extends StatelessWidget {
  const VillageMissionsScreen({super.key});

  static const _cream = Color(0xFFFBF7EC);
  static const _gold = Color(0xFFF5CC3D);
  static const _ink = Color(0xFF24452D);

  static const Map<String, String> _iconAssets = {
    'bakery': 'assets/images/Icon/icon_bakery.png',
    'library': 'assets/images/Icon/icon_book.png',
    'fountain': 'assets/images/Icon/icon_fontaine.png',
  };

  static const Map<String, Color> _accents = {
    'bakery': Color(0xFFC66A45),
    'library': Color(0xFF4A7590),
    'fountain': Color(0xFF2C9DB7),
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<GameNotifier>(
      builder: (context, gameNotifier, _) {
        final dawn = gameNotifier.villageDawn;
        final titleColor = Color.lerp(_cream, _ink, dawn)!;

        return Scaffold(
          backgroundColor: VillageSceneBackdrop.skyColor(dawn),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: titleColor,
            elevation: 0,
            title: Text(
              '복원 미션',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: titleColor,
                shadows: [
                  Shadow(
                    color: Color.fromRGBO(0, 0, 0, 0.45 * (1 - dawn)),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              VillageSceneBackdrop(dawn: dawn),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x55152433),
                      Color(0x22121C1A),
                      Color(0x99121C1A),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: PlayViewport(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                    children: [
                      Text(
                        '퍼즐을 풀면 별빛이 모이고, 창문이 다시 켜집니다.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.lerp(_cream, _ink, dawn),
                          height: 1.4,
                          shadows: [
                            Shadow(
                              color: Color.fromRGBO(0, 0, 0, 0.4 * (1 - dawn)),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '지금 별빛  ${gameNotifier.starLightBalance}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: _gold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...gameNotifier.buildings.map(
                        (building) => _MissionCard(
                          building: building,
                          iconAsset: _iconAssets[building.id],
                          accent: _accents[building.id] ?? _gold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MissionCard extends StatefulWidget {
  const _MissionCard({
    required this.building,
    required this.iconAsset,
    required this.accent,
  });

  final BuildingProgress building;
  final String? iconAsset;
  final Color accent;

  @override
  State<_MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<_MissionCard> {
  static const _gold = Color(0xFFF5CC3D);
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final building = widget.building;
    final story = VillageStory.forBuilding(building.id);
    final complete = building.isComplete;
    final lit = _hovered || complete;
    final status = complete ? '복원 완료' : '별빛 ${building.remainingStarLight} 남음';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          decoration: BoxDecoration(
            color: complete ? const Color(0xFFFFF6DC) : const Color(0xF2FFF8E8),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: lit ? _gold : const Color(0xFFD8CBB0),
              width: lit ? 2.4 : 1.6,
            ),
            boxShadow: [
              if (complete) ...[
                const BoxShadow(
                  color: Color(0xAAFFE56A),
                  blurRadius: 22,
                  spreadRadius: 1,
                ),
                const BoxShadow(
                  color: Color(0x66F5CC3D),
                  blurRadius: 28,
                  offset: Offset(0, 6),
                ),
              ] else if (_hovered)
                const BoxShadow(
                  color: Color(0x66F5CC3D),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                )
              else
                BoxShadow(
                  color: widget.accent.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: widget.accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.accent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: widget.iconAsset == null
                        ? Icon(Icons.home, color: widget.accent, size: 26)
                        : Padding(
                            padding: const EdgeInsets.all(6),
                            child: Image.asset(
                              widget.iconAsset!,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.medium,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                building.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF24452D),
                                ),
                              ),
                            ),
                            if (complete)
                              const Icon(Icons.auto_awesome, color: _gold, size: 18),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          story.headline,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4D6554),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                complete ? story.completedDescription : story.description,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: Color(0xFF4D6554),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    '복원 ${building.level} / 5',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF24452D),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: complete ? _gold : const Color(0xFF4D6554),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 550),
                curve: Curves.easeOutCubic,
                tween: Tween(begin: 0, end: building.progress),
                builder: (context, progress, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    color: complete ? _gold : widget.accent,
                    backgroundColor: const Color(0xFFE7D9B8),
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
