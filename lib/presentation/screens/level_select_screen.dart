import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/screens/game_screen.dart';
import 'package:sudoku_game/presentation/widgets/play_viewport.dart';
import 'package:sudoku_game/presentation/widgets/village_scene_backdrop.dart';

/// Numbered stage list for one difficulty, laid over the village at dusk.
class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key, required this.difficulty});

  final SudokuDifficulty difficulty;

  static const _ink = Color(0xFF24452D);
  static const _gold = Color(0xFFF5CC3D);
  static const _cream = Color(0xFFFBF7EC);

  @override
  Widget build(BuildContext context) {
    final config = DifficultyConfig.getConfig(difficulty);
    final accent = _accentColor(difficulty);

    return Consumer<GameNotifier>(
      builder: (context, gameNotifier, _) {
        final completed = gameNotifier.completedStageCount(difficulty);
        final progress = config.stageCount == 0 ? 0.0 : completed / config.stageCount;
        final currentLevel = _currentLevel(gameNotifier, config.stageCount);

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          tween: Tween<double>(begin: 0, end: progress),
          builder: (context, dawn, _) {
            final titleColor = Color.lerp(_cream, _ink, dawn)!;
            return Scaffold(
              backgroundColor: VillageSceneBackdrop.skyColor(dawn),
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: titleColor,
                elevation: 0,
                title: Text(
                  '${config.getKoreanName()} 스테이지',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    shadows: [
                      Shadow(
                        color: Color.fromRGBO(0, 0, 0, 0.55 * (1 - dawn)),
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
                  SafeArea(
                    child: PlayViewport(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                            child: _ProgressBanner(
                              completed: completed,
                              total: config.stageCount,
                              accent: accent,
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                              itemCount: config.stageCount,
                              itemBuilder: (context, index) {
                                final level = index + 1;
                                final unlocked =
                                    gameNotifier.isStageUnlocked(difficulty, level);
                                final isCompleted =
                                    gameNotifier.isStageCompleted(difficulty, level);
                                return _StageTile(
                                  level: level,
                                  isCompleted: isCompleted,
                                  isUnlocked: unlocked,
                                  isCurrent: unlocked &&
                                      !isCompleted &&
                                      level == currentLevel,
                                  onTap: () => _openStage(context, gameNotifier, level),
                                );
                              },
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
      },
    );
  }

  int _currentLevel(GameNotifier gameNotifier, int stageCount) {
    for (var level = 1; level <= stageCount; level++) {
      if (gameNotifier.isStageUnlocked(difficulty, level) &&
          !gameNotifier.isStageCompleted(difficulty, level)) {
        return level;
      }
    }
    return stageCount;
  }

  Future<void> _openStage(
    BuildContext context,
    GameNotifier gameNotifier,
    int level,
  ) async {
    if (!gameNotifier.isStageUnlocked(difficulty, level)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이전 스테이지를 먼저 완료하세요')),
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          color: _cream,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: _gold),
                SizedBox(height: 16),
                Text('퍼즐을 준비하고 있어요', style: TextStyle(color: _ink)),
              ],
            ),
          ),
        ),
      ),
    );

    await Future<void>.delayed(Duration.zero);
    gameNotifier.startNewGame(difficulty, level: level);
    if (!context.mounted) return;
    Navigator.pop(context);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }

  Color _accentColor(SudokuDifficulty value) {
    return switch (value) {
      SudokuDifficulty.easy => const Color(0xFF7CB07A),
      SudokuDifficulty.normal => const Color(0xFFF5CC3D),
      SudokuDifficulty.hard => const Color(0xFF8FA4D4),
    };
  }
}

class _ProgressBanner extends StatelessWidget {
  const _ProgressBanner({
    required this.completed,
    required this.total,
    required this.accent,
  });

  final int completed;
  final int total;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xF2FFF8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8CBB0), width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$completed/$total 클리어',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF24452D),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '스테이지를 클리어할수록 마을에 아침이 와요.',
            style: TextStyle(fontSize: 13, color: Color(0xFF4D6554), height: 1.35),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFE7D9B8),
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _StageTile extends StatefulWidget {
  const _StageTile({
    required this.level,
    required this.isCompleted,
    required this.isUnlocked,
    required this.isCurrent,
    required this.onTap,
  });

  final int level;
  final bool isCompleted;
  final bool isUnlocked;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  State<_StageTile> createState() => _StageTileState();
}

class _StageTileState extends State<_StageTile> {
  static const _gold = Color(0xFFF5CC3D);
  static const _goldGlow = Color(0xAAFFE56A);

  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isUnlocked = widget.isUnlocked;
    final isCompleted = widget.isCompleted;
    final isCurrent = widget.isCurrent;
    final lit = _pressed && isUnlocked;

    final fill = !isUnlocked
        ? const Color(0x66141C1A)
        : isCompleted
            ? const Color(0xFFFFF1B8)
            : lit
                ? const Color(0xFFFFF6DC)
                : const Color(0xF2FFFBF2);
    final border = !isUnlocked
        ? const Color(0x33FFFFFF)
        : lit
            ? _gold
            : isCompleted
                ? const Color(0xFFF5CC3D)
                : const Color(0xFFD8CBB0);
    final foreground = !isUnlocked
        ? const Color(0x99E8E0D0)
        : isCompleted
            ? const Color(0xFF8A6A10)
            : const Color(0xFF24452D);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isUnlocked ? widget.onTap : null,
        onHighlightChanged: (pressed) {
          if (isUnlocked) setState(() => _pressed = pressed);
        },
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: lit ? 2.4 : 1.6),
            boxShadow: [
              if (lit) ...[
                const BoxShadow(
                  color: _goldGlow,
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
                const BoxShadow(
                  color: Color(0x88F5CC3D),
                  blurRadius: 18,
                  offset: Offset(0, 3),
                ),
              ],
            ],
          ),
          child: Stack(
            children: [
              if (isUnlocked)
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.55),
                          Colors.white.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              Center(
                child: isUnlocked
                    ? Text(
                        '${widget.level}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: foreground,
                        ),
                      )
                    : Icon(Icons.lock_rounded, size: 18, color: foreground),
              ),
              if (isCompleted)
                const Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(Icons.auto_awesome, size: 12, color: _gold),
                ),
              if (isCurrent && isUnlocked && !isCompleted)
                const Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 6,
                      height: 6,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFF5CC3D),
                          shape: BoxShape.circle,
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
