import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/screens/game_screen.dart';
import 'package:sudoku_game/presentation/widgets/play_viewport.dart';

/// 난이도 선택 화면
class DifficultySelectionScreen extends StatelessWidget {
  const DifficultySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('난이도 선택'),
        elevation: 0,
      ),
      body: PlayViewport(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '어떤 난이도로 플레이하시겠어요?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ..._buildDifficultyCards(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDifficultyCards(BuildContext context) {
    return SudokuDifficulty.values.map((difficulty) {
      final config = DifficultyConfig.getConfig(difficulty);
      final color = _getDifficultyColor(difficulty);

      return Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Card(
          elevation: 4,
          child: InkWell(
            onTap: () {
              context.read<GameNotifier>().startNewGame(difficulty);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getDifficultyIcon(difficulty),
                        color: color,
                        size: 32,
                      ),
                      SizedBox(width: 12),
                      Text(
                        config.getDisplayName(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildInfoRow('주어진 숫자', '${config.minClues}-${config.maxClues}개'),
                  _buildInfoRow('빈 셀', '${config.minEmptyCells}-${config.maxEmptyCells}개'),
                  _buildInfoRow('StarLight 보상', '${config.starLightReward}개'),
                  _buildInfoRow(
                    '시간 감소',
                    '${(config.restorationTimeReduction / 60).toStringAsFixed(0)}분',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(SudokuDifficulty difficulty) {
    switch (difficulty) {
      case SudokuDifficulty.easy:
        return Colors.green;
      case SudokuDifficulty.normal:
        return Colors.orange;
      case SudokuDifficulty.hard:
        return Colors.red;
    }
  }

  IconData _getDifficultyIcon(SudokuDifficulty difficulty) {
    switch (difficulty) {
      case SudokuDifficulty.easy:
        return Icons.star_border;
      case SudokuDifficulty.normal:
        return Icons.star_half;
      case SudokuDifficulty.hard:
        return Icons.star;
    }
  }
}
