import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/audio/game_bgm.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/screens/level_select_screen.dart';
import 'package:sudoku_game/presentation/widgets/play_viewport.dart';
import 'package:sudoku_game/presentation/widgets/trial_end_dialog.dart';
import 'package:sudoku_game/presentation/widgets/village_scene_backdrop.dart';

/// 난이도 선택 화면
class DifficultySelectionScreen extends StatelessWidget {
  const DifficultySelectionScreen({super.key});

  static const _ink = Color(0xFF24452D);
  static const _cream = Color(0xFFFBF7EC);
  static const _muted = Color(0xFF4D6554);

  @override
  Widget build(BuildContext context) {
    final l10n = l10nOf(context);
    return TrialEndHost(
      child: BgmScope(
      cue: BgmCue.level,
      child: Consumer<GameNotifier>(
      builder: (context, gameNotifier, _) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          tween: Tween<double>(begin: 0, end: gameNotifier.villageDawn),
          builder: (context, dawn, _) {
            final titleColor = Color.lerp(_cream, _ink, dawn)!;
            final night = 1 - dawn;
            return Scaffold(
              backgroundColor: VillageSceneBackdrop.skyColor(dawn),
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: titleColor,
                elevation: 0,
                title: Text(
                  l10n.difficultySelect,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    shadows: [
                      Shadow(
                        color: Color.fromRGBO(0, 0, 0, 0.53 * night),
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
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(21, 36, 51, 0.4 * night),
                          Color.fromRGBO(18, 28, 26, 0.13 * night),
                          Color.fromRGBO(18, 28, 26, 0.6 * night),
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
                            l10n.difficultyLead,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: titleColor,
                              height: 1.4,
                              shadows: [
                                Shadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.53 * night),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.difficultySub,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.lerp(
                                const Color(0xD6FFF8E8),
                                _muted,
                                dawn,
                              ),
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 22),
                          ...SudokuDifficulty.values
                              .where(
                                (difficulty) =>
                                    DifficultyConfig.getConfig(difficulty)
                                        .stageCount >
                                    0,
                              )
                              .map(
                            (difficulty) =>
                                _DifficultyPathCard(difficulty: difficulty),
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
      },
    ),
    ),
    );
  }
}

class _DifficultyPathCard extends StatefulWidget {
  const _DifficultyPathCard({required this.difficulty});

  final SudokuDifficulty difficulty;

  @override
  State<_DifficultyPathCard> createState() => _DifficultyPathCardState();
}

class _DifficultyPathCardState extends State<_DifficultyPathCard> {
  static const _gold = Color(0xFFF5CC3D);
  static const _goldGlow = Color(0xFFFFE56A);

  bool _hovered = false;
  bool _selected = false;

  SudokuDifficulty get difficulty => widget.difficulty;

  Future<void> _open(BuildContext context) async {
    setState(() => _selected = true);
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelSelectScreen(difficulty: difficulty),
      ),
    );
    if (mounted) setState(() => _selected = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nOf(context);
    final config = DifficultyConfig.getConfig(difficulty);
    final accent = _accentFor(difficulty);
    final lit = _hovered || _selected;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _open(context),
            borderRadius: BorderRadius.circular(18),
            splashColor: _goldGlow.withValues(alpha: 0.28),
            highlightColor: _gold.withValues(alpha: 0.10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              decoration: BoxDecoration(
                color: _selected ? const Color(0xFFFFF6DC) : const Color(0xF2FFF8E8),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: lit ? _gold : const Color(0xFFD8CBB0),
                  width: lit ? 2.4 : 1.6,
                ),
                boxShadow: [
                  if (_selected) ...[
                    const BoxShadow(
                      color: Color(0xCCFFE56A),
                      blurRadius: 26,
                      spreadRadius: 2,
                    ),
                    const BoxShadow(
                      color: Color(0x88F5CC3D),
                      blurRadius: 34,
                      offset: Offset(0, 6),
                    ),
                  ] else if (_hovered)
                    const BoxShadow(
                      color: Color(0x66F5CC3D),
                      blurRadius: 18,
                      offset: Offset(0, 6),
                    )
                  else
                    BoxShadow(
                      color: accent.withValues(alpha: 0.14),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: accent.withValues(alpha: 0.45)),
                        ),
                        child: Icon(_iconFor(difficulty), color: accent, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                l10n.difficultyPathTitle(difficulty),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: accent,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.difficultyBlurb(difficulty),
                              style: const TextStyle(
                                fontSize: 13,
                                color: DifficultySelectionScreen._muted,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Consumer<GameNotifier>(
                    builder: (context, gameNotifier, _) {
                      final completed = gameNotifier.completedStageCount(difficulty);
                      return _MetaRow(
                        label: l10n.stages,
                        value: l10n.stagesCleared(completed, config.stageCount),
                      );
                    },
                  ),
                  _MetaRow(
                    label: l10n.starlight,
                    value: '+${config.starLightReward}',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Color _accentFor(SudokuDifficulty difficulty) {
    return switch (difficulty) {
      SudokuDifficulty.easy => const Color(0xFF7CB07A),
      SudokuDifficulty.normal => const Color(0xFFF5CC3D),
      SudokuDifficulty.hard => const Color(0xFF6A7FA8),
    };
  }

  static IconData _iconFor(SudokuDifficulty difficulty) {
    return switch (difficulty) {
      SudokuDifficulty.easy => Icons.wb_twilight_outlined,
      SudokuDifficulty.normal => Icons.auto_awesome,
      SudokuDifficulty.hard => Icons.nights_stay_outlined,
    };
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: DifficultySelectionScreen._muted),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: DifficultySelectionScreen._ink,
            ),
          ),
        ],
      ),
    );
  }
}
