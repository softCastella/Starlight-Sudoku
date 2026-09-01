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
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 36),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'TYCHE SPARK',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFDE7B),
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      '별빛 스도쿠',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '한 칸씩 채우고, 한 줄씩 마을을 밝혀요',
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    const _SudokuHeroBoard(),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFDE7B),
                          foregroundColor: const Color(0xFF16422D),
                          elevation: 3,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DifficultySelectionScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text(
                          '새 퍼즐 시작',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Consumer<GameNotifier>(
                      builder: (context, gameNotifier, _) {
                        if (!gameNotifier.hasActiveGame) return const SizedBox.shrink();
                        return TextButton.icon(
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
                    const SizedBox(height: 28),
                    const Text(
                      '© 2026 Tyche works',
                      style: TextStyle(fontSize: 12, color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SudokuHeroBoard extends StatelessWidget {
  const _SudokuHeroBoard();

  static const _numbers = [
    5, 3, 0, 0, 7, 0, 0, 0, 0,
    6, 0, 0, 1, 9, 5, 0, 0, 0,
    0, 9, 8, 0, 0, 0, 0, 6, 0,
    8, 0, 0, 0, 6, 0, 0, 0, 3,
    4, 0, 0, 8, 0, 3, 0, 0, 1,
    7, 0, 0, 0, 2, 0, 0, 0, 6,
    0, 6, 0, 0, 0, 0, 2, 8, 0,
    0, 0, 0, 4, 1, 9, 0, 0, 5,
    0, 0, 0, 0, 8, 0, 0, 7, 9,
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFF173F2B),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Color(0x550E2B1D), blurRadius: 22, offset: Offset(0, 12))],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
          itemCount: 81,
          itemBuilder: (context, index) {
            final row = index ~/ 9;
            final col = index % 9;
            final number = _numbers[index];
            final isGlowCell = index == 40 || index == 59;
            return Container(
              decoration: BoxDecoration(
                color: isGlowCell ? const Color(0xFFFFDE7B) : const Color(0xFFF7F2E6),
                border: Border(
                  right: BorderSide(color: const Color(0xFF173F2B), width: col % 3 == 2 ? 2 : 0.5),
                  bottom: BorderSide(color: const Color(0xFF173F2B), width: row % 3 == 2 ? 2 : 0.5),
                ),
              ),
              child: Center(
                child: Text(
                  number == 0 ? '' : '$number',
                  style: TextStyle(
                    color: isGlowCell ? const Color(0xFF16422D) : const Color(0xFF24513A),
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
