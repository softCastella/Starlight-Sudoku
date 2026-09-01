import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';

/// 점수(StarLight) 표시 위젯
class ScoreWidget extends StatelessWidget {
  const ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameNotifier>(
      builder: (context, gameNotifier, _) {
        final starLight = gameNotifier.totalStarLight;
        final potentialReward = gameNotifier.potentialStarLightReward;
        final difficulty = gameNotifier.difficulty;
        final config = DifficultyConfig.getConfig(difficulty);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '난이도: ${config.getDisplayName()}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber[700]),
                  SizedBox(width: 8),
                  Text(
                    starLight > 0
                      ? '획득 StarLight: $starLight'
                      : '예상 StarLight: $potentialReward',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[900],
                    ),
                  ),
                ],
              ),
              if (gameNotifier.hintsUsed > 0) ...[
                SizedBox(height: 4),
                Text(
                  '힌트 ${gameNotifier.hintsUsed}/3 · 힌트당 -10',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
