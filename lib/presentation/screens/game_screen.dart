import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/widgets/completion_reward_dialog.dart';
import 'package:sudoku_game/presentation/widgets/sudoku_board_widget.dart';
import 'package:sudoku_game/presentation/widgets/timer_widget.dart';
import 'package:sudoku_game/presentation/screens/village_screen.dart';
import 'package:sudoku_game/presentation/widgets/play_viewport.dart';

/// Sudoku 게임 메인 화면
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
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
        appBar: AppBar(
          leading: IconButton(
            tooltip: '포기하고 나가기',
            icon: const Icon(Icons.arrow_back),
            onPressed: _confirmGiveUp,
          ),
          title: const Text('오늘의 퍼즐'),
          elevation: 0,
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
            if (kDebugMode)
              IconButton(
                tooltip: '자동 완성 테스트',
                icon: const Icon(Icons.bug_report),
                onPressed: _simulateCompletion,
              ),
          ],
        ),
        body: PlayViewport(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                children: [
                  const TimerWidget(),
                  const SizedBox(height: 12),
                  SudokuBoardWidget(
                    key: _boardKey,
                    onCellSelected: () {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 18),
                  _buildNumberPanel(),
                  const SizedBox(height: 16),
                  _buildMemoToggle(),
                  const SizedBox(height: 10),
                  _buildPuzzleTools(),
                  const SizedBox(height: 16),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _isMemoMode ? '메모 입력' : '숫자 입력',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 7),
          GridView.count(
            crossAxisCount: 5,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1.15,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildNumberButton(0, '삭제'),
              ...List.generate(9, (index) {
                return _buildNumberButton(index + 1, '${index + 1}');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(int number, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: number == 0 ? Colors.red[400] : Colors.blue[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        _handleNumberInput(number);
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
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
        SnackBar(content: Text('셀을 먼저 선택하세요')),
      );
      return;
    }

    final board = gameNotifier.board;
    if (board.isFixedCell(row, col)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('고정된 셀입니다')),
      );
      return;
    }

    if (_isMemoMode) {
      // 메모 모드
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
      // 숫자 입력 모드
      gameNotifier.setCellValue(row, col, number);
      SystemSound.play(SystemSoundType.click);

      // 퍼즐 완성 확인
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

  Widget _buildPuzzleTools() {
    return Consumer<GameNotifier>(
      builder: (context, gameNotifier, _) => Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: gameNotifier.canUndo ? gameNotifier.undo : null,
              icon: const Icon(Icons.undo),
              label: const Text('실행 취소'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.tonalIcon(
              onPressed: gameNotifier.hintsRemaining == 0 ? null : _showHint,
              icon: const Icon(Icons.lightbulb_outline),
              label: Text('힌트 ${gameNotifier.hintsRemaining}/3'),
            ),
          ),
        ],
      ),
    );
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

  Widget _buildMemoToggle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isMemoMode ? Colors.purple[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            _isMemoMode ? Icons.edit_note : Icons.edit,
            color: _isMemoMode ? Colors.purple[700] : Colors.grey[700],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              _isMemoMode ? '메모 모드 활성화' : '숫자 입력 모드',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Switch(
            value: _isMemoMode,
            onChanged: (value) {
              setState(() {
                _isMemoMode = value;
              });
            },
            activeThumbColor: Colors.purple[700],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => context.read<GameNotifier>().giveUp(),
        icon: const Icon(Icons.refresh),
        label: const Text('다시 풀기'),
      ),
    );
  }

  Future<void> _confirmGiveUp() async {
    final shouldGiveUp = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('퍼즐을 나갈까요?'),
        content: const Text('현재 진행 상황은 이어하기에 저장됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('계속 풀기'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('나가기'),
          ),
        ],
      ),
    );
    if (shouldGiveUp == true && mounted) {
      Navigator.pop(context);
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final gameNotifier = context.read<GameNotifier>();
        return CompletionRewardDialog(
          starLight: gameNotifier.totalStarLight,
          elapsedTimeLabel: _formatTime(gameNotifier.elapsedSeconds),
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
