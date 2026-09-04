import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/audio/game_bgm.dart';
import 'package:sudoku_game/presentation/notifiers/app_settings.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/screens/village_screen.dart';
import 'package:sudoku_game/presentation/widgets/completion_reward_dialog.dart';
import 'package:sudoku_game/presentation/widgets/give_up_puzzle_dialog.dart';
import 'package:sudoku_game/presentation/widgets/play_viewport.dart';
import 'package:sudoku_game/presentation/widgets/settings_dialog.dart';
import 'package:sudoku_game/presentation/widgets/sudoku_board_widget.dart';
import 'package:sudoku_game/presentation/widgets/timer_widget.dart';

/// Sudoku 게임 메인 화면
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const _ink = Color(0xFF24452D);
  static const _cream = Color(0xFFFBF7EC);
  static const _night = Color(0xFF1C3340);

  late GlobalKey<SudokuBoardWidgetState> _boardKey;
  bool _isMemoMode = false;

  @override
  void initState() {
    super.initState();
    _boardKey = GlobalKey<SudokuBoardWidgetState>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nOf(context);
    return BgmScope(
      cue: BgmCue.silence,
      child: PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _confirmGiveUp();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F0E4),
        appBar: AppBar(
          backgroundColor: _night,
          foregroundColor: _cream,
          elevation: 0,
          leading: IconButton(
            tooltip: l10n.giveUpTooltip,
            icon: const Icon(Icons.arrow_back),
            onPressed: _confirmGiveUp,
          ),
          title: Consumer<GameNotifier>(
            builder: (context, gameNotifier, _) {
              return Text(
                l10n.gameLevelTitle(
                  l10n.difficultyName(gameNotifier.difficulty),
                  gameNotifier.currentLevel,
                ),
                style: const TextStyle(fontWeight: FontWeight.w700),
              );
            },
          ),
          actions: [
            IconButton(
              tooltip: l10n.pauseTooltip,
              icon: const Icon(Icons.pause),
              onPressed: () {
                context.read<GameNotifier>().togglePause();
              },
            ),
            IconButton(
              tooltip: l10n.retryTooltip,
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<GameNotifier>().giveUp();
              },
            ),
            IconButton(
              tooltip: l10n.skipTrialTooltip,
              icon: const Icon(Icons.bug_report),
              onPressed: _skipTrialStages,
            ),
            IconButton(
              key: const Key('game-settings'),
              tooltip: l10n.settingsTooltip,
              icon: const Icon(Icons.settings),
              onPressed: () => SettingsDialog.show(context),
            ),
          ],
        ),
        body: PlayViewport(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Column(
                children: [
                  const TimerWidget(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final side = constraints.maxWidth < constraints.maxHeight
                            ? constraints.maxWidth
                            : constraints.maxHeight;
                        return Center(
                          child: SizedBox(
                            width: side,
                            height: side,
                            child: SudokuBoardWidget(
                              key: _boardKey,
                              onCellSelected: () {
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildNumberRow(),
                  const SizedBox(height: 8),
                  _buildToolRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildNumberRow() {
    final l10n = l10nOf(context);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _isMemoMode ? l10n.memoInput : l10n.numberInput,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            ...List.generate(9, (index) {
              final number = index + 1;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: _NumberKey(
                    label: '$number',
                    onPressed: () => _handleNumberInput(number),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildToolRow() {
    return Consumer<GameNotifier>(
      builder: (context, gameNotifier, _) {
        final l10n = l10nOf(context);
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: _ToolKey(
                label: l10n.delete,
                emphasized: true,
                onPressed: () => _handleNumberInput(0),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 3,
              child: _ToolKey(
                label: _isMemoMode ? l10n.memoOn : l10n.memo,
                selected: _isMemoMode,
                onPressed: () => setState(() => _isMemoMode = !_isMemoMode),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 3,
              child: _ToolKey(
                label: l10n.hintCount(gameNotifier.hintsRemaining),
                onPressed: gameNotifier.hintsRemaining == 0 ? null : _showHint,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 3,
              child: _ToolKey(
                label: l10n.undo,
                onPressed: gameNotifier.canUndo ? gameNotifier.undo : null,
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleNumberInput(int number) {
    final gameNotifier = context.read<GameNotifier>();
    final boardState = _boardKey.currentState;

    if (boardState == null) return;

    final row = boardState.getSelectedRow();
    final col = boardState.getSelectedCol();

    if (row == null || col == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10nOf(context).selectCellFirst)),
      );
      return;
    }

    final board = gameNotifier.board;
    if (board.isFixedCell(row, col)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10nOf(context).fixedCell)),
      );
      return;
    }

    if (_isMemoMode) {
      if (number == 0) {
        gameNotifier.clearMemo(row, col);
      } else {
        final memos = board.getMemo(row, col);
        if (memos.contains(number)) {
          gameNotifier.removeMemo(row, col, number);
        } else {
          gameNotifier.addMemo(row, col, number);
        }
      }
    } else {
      gameNotifier.setCellValue(row, col, number);
      if (AppSettings.sfxOn) {
        SystemSound.play(SystemSoundType.click);
      }

      if (gameNotifier.isPuzzleComplete) {
        gameNotifier.completeGame();
        HapticFeedback.mediumImpact();
        if (AppSettings.sfxOn) {
          SystemSound.play(SystemSoundType.alert);
        }
        _showCompletionDialog();
      }
    }

    boardState.clearSelection();
  }

  Future<void> _skipTrialStages() async {
    await context.read<GameNotifier>().debugClearTrialStages();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _showHint() {
    final boardState = _boardKey.currentState;
    final row = boardState?.getSelectedRow();
    final col = boardState?.getSelectedCol();
    if (row == null || col == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10nOf(context).selectHintCell)),
      );
      return;
    }

    final gameNotifier = context.read<GameNotifier>();
    if (!gameNotifier.showHint(row, col)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10nOf(context).hintUnavailable)),
      );
      return;
    }
    HapticFeedback.selectionClick();
    boardState?.clearSelection();
  }

  Future<void> _confirmGiveUp() async {
    final shouldGiveUp = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0xCC152433),
      builder: (context) => const GiveUpPuzzleDialog(),
    );
    if (shouldGiveUp == true && mounted) {
      Navigator.pop(context);
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xCC152433),
      builder: (context) {
        final gameNotifier = context.read<GameNotifier>();
        return CompletionRewardDialog(
          starLight: gameNotifier.totalStarLight,
          elapsedTimeLabel: l10nOf(context).formatElapsed(gameNotifier.elapsedSeconds),
          isReplay: gameNotifier.totalStarLight == 0,
          onNextLevel: gameNotifier.hasNextLevel
              ? () {
                  Navigator.pop(context);
                  gameNotifier.startNextLevel();
                }
              : null,
          onViewVillage: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VillageScreen()),
            );
          },
          onClose: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class _NumberKey extends StatelessWidget {
  const _NumberKey({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Material(
        color: const Color(0xFFFBF7EC),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD8CBB0)),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF24452D),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolKey extends StatelessWidget {
  const _ToolKey({
    required this.label,
    required this.onPressed,
    this.emphasized = false,
    this.selected = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool emphasized;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final fill = !enabled
        ? const Color(0xFFE8E0D0)
        : selected
            ? const Color(0xFFFFF0BB)
            : emphasized
                ? const Color(0xFFFFE4D6)
                : const Color(0xFFFBF7EC);
    final border = emphasized ? const Color(0xFFC66A45) : const Color(0xFFD8CBB0);
    final color = !enabled
        ? const Color(0xFF9AA59C)
        : emphasized
            ? const Color(0xFF9A4D31)
            : const Color(0xFF24452D);

    return SizedBox(
      height: 44,
      child: Material(
        color: fill,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: border),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
