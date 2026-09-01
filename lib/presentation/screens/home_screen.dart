import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/screens/difficulty_selection_screen.dart';
import 'package:sudoku_game/presentation/screens/game_screen.dart';
import 'package:sudoku_game/presentation/screens/village_screen.dart';
import 'package:sudoku_game/presentation/widgets/play_viewport.dart';

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
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
              child: PlayViewport(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 64),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '별빛 스도쿠',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          '한 칸씩 채우고, 한 줄씩 마을을 밝혀요',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.4),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: _SudokuHeroBoard(),
                      ),
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
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Column(
                          children: [
                            Consumer<GameNotifier>(
                              builder: (context, gameNotifier, _) {
                                if (!gameNotifier.hasActiveGame) {
                                  return const SizedBox.shrink();
                                }
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
                                  label: const Text(
                                    '이어서 하기',
                                    style: TextStyle(fontSize: 18, color: Colors.white),
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
                              label: const Text(
                                '마을 보기',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          '© 2026 Tyche works',
                          style: TextStyle(fontSize: 14, color: Colors.white60),
                        ),
                      ),
                    ],
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
    return const Align(
      child: SizedBox(
        width: 200,
        height: 200,
        child: _HeroBoardGrid(),
      ),
    );
  }
}

class _HeroBoardGrid extends StatelessWidget {
  const _HeroBoardGrid();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF173F2B),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color(0x550E2B1D), blurRadius: 22, offset: Offset(0, 12))],
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
          childAspectRatio: 1,
        ),
        itemCount: 81,
        itemBuilder: (context, index) {
          final row = index ~/ 9;
          final col = index % 9;
          final number = _SudokuHeroBoard._numbers[index];
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
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  number == 0 ? '' : '$number',
                  style: TextStyle(
                    color: isGlowCell ? const Color(0xFF16422D) : const Color(0xFF24513A),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
