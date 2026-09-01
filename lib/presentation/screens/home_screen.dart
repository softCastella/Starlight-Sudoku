import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/screens/difficulty_selection_screen.dart';
import 'package:sudoku_game/presentation/screens/game_screen.dart';
import 'package:sudoku_game/presentation/screens/village_screen.dart';

/// 게임 홈 화면
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[400]!,
              Colors.blue[600]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 제목
              Text(
                'Sudoku',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Cozy Puzzle Game',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 40),

              // 게임 설명
              Container(
                margin: EdgeInsets.symmetric(horizontal: 32),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '퍼즐을 풀면서\n마을을 복원하세요!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '각 난이도의 퍼즐을 풀고 StarLight를 모아\n아름다운 마을을 천천히 복원해 나가세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 64),

              // 시작 버튼
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DifficultySelectionScreen(),
                        ),
                      );
                    },
                    child: Text(
                      '게임 시작',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[600],
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Consumer<GameNotifier>(
                builder: (context, gameNotifier, _) {
                  if (!gameNotifier.hasActiveGame) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextButton.icon(
                      onPressed: () {
                        if (gameNotifier.continueGame()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const GameScreen()),
                          );
                        }
                      },
                      icon: const Icon(Icons.play_circle_outline, color: Colors.white),
                      label: const Text('이어서 하기', style: TextStyle(color: Colors.white)),
                    ),
                  );
                },
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VillageScreen()),
                  );
                },
                icon: const Icon(Icons.location_city, color: Colors.white),
                label: const Text('마을 보기', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),

              // 하단 정보
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    _buildInfoItem(Icons.info_outline, '각 행, 열, 3×3 박스에 1-9를 배치합니다'),
                    SizedBox(height: 8),
                    _buildInfoItem(Icons.star, 'StarLight를 모아 마을을 복원하세요'),
                    SizedBox(height: 8),
                    _buildInfoItem(Icons.timer, '시간이 지날수록 도움이 됩니다'),
                  ],
                ),
              ),
              Spacer(),

              // 저작권
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  '© 2026 Cozy Puzzle Game. All rights reserved.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
