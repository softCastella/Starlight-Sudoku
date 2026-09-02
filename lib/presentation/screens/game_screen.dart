import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/screens/village_screen.dart';
import 'package:sudoku_game/presentation/widgets/completion_reward_dialog.dart';
import 'package:sudoku_game/presentation/widgets/give_up_puzzle_dialog.dart';
import 'package:sudoku_game/presentation/widgets/play_viewport.dart';
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
    return PopScope(
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
            tooltip: '포기하고 나가기',
            icon: const Icon(Icons.arrow_back),
            onPressed: _confirmGiveUp,
          ),
          title: Consumer<GameNotifier>(
            builder: (context, gameNotifier, _) {
              final config = DifficultyConfig.getConfig(gameNotifier.difficulty);
              return Text(
                '${config.getKoreanName()} ${gameNotifier.currentLevel}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              );
            },
          ),
          actions: [
            IconButton(
              tooltip: '일시 정지',
              icon: const Icon(Icons.pause),
              onPressed: () {
                context.read<GameNotifier>().togglePause();
              },
            ),
            IconButton(
              tooltip: '다시 풀기',
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<GameNotifier>().giveUp();
              },
            ),
            IconButton(
              tooltip: '자동 완성',
              icon: const Icon(Icons.bug_report),
              onPressed: _simulateCompletion,
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
    );
  }

  Widget _buildNumberRow() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _isMemoMode ? '메모 입력' : '숫자 입력',
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
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: _ToolKey(
                label: '삭제',
                emphasized: true,
                onPressed: () => _handleNumberInput(0),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 3,
              child: _ToolKey(
                label: _isMemoMode ? '메모 ON' : '메모',
                selected: _isMemoMode,
                onPressed: () => setState(() => _isMemoMode = !_isMemoMode),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 3,
              child: _ToolKey(
                label: '힌트 ${gameNotifier.hintsRemaining}',
                onPressed: gameNotifier.hintsRemaining == 0 ? null : _showHint,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 3,
              child: _ToolKey(
                label: '실행취소',
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
        const SnackBar(content: Text('셀을 먼저 선택하세요')),
      );
      return;
    }

    final board = gameNotifier.board;
    if (board.isFixedCell(row, col)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('고정된 셀입니다')),
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
      SystemSound.play(SystemSoundType.click);

      if (gameNotifier.isPuzzleComplete) {
        gameNotifier.completeGame();
        HapticFeedback.mediumImpact();
        SystemSound.play(SystemSoundType.alert);
        _showCompletionDialog();
      }
    }

    boardState.clearSelection();
  }

  void _simulateCompletion() {
    final gameNotifier = context.read<GameNotifier>();
    gameNotifier.completePuzzleForDebug();
    gameNotifier.completeGame();
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.alert);
    _showCompletionDialog();
  }

  void _showHint() {
    final boardState = _boardKey.currentState;
    final row = boardState?.getSelectedRow();
    final col = boardState?.getSelectedCol();
    if (row == null || col == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('힌트를 볼 셀을 먼저 선택하세요')),
      );
      return;
    }

    final gameNotifier = context.read<GameNotifier>();
    if (!gameNotifier.showHint(row, col)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이 셀에는 힌트를 사용할 수 없습니다')),
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
          elapsedTimeLabel: _formatTime(gameNotifier.elapsedSeconds),
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

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '$hours시간 $minutes분 $secs초';
    }
    return '$minutes분 $secs초';
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
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
    );
  }
}
