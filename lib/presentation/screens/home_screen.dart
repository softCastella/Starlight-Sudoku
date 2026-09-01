import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/screens/difficulty_selection_screen.dart';
import 'package:sudoku_game/presentation/screens/game_screen.dart';
import 'package:sudoku_game/presentation/screens/opening_story_screen.dart';
import 'package:sudoku_game/presentation/screens/village_screen.dart';
import 'package:sudoku_game/presentation/widgets/parchment_button.dart';
import 'package:sudoku_game/presentation/widgets/play_viewport.dart';

/// 게임 홈 화면
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const titleAsset = 'assets/images/starlight_sudoku_title.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C3340),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            titleAsset,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.12),
            semanticLabel: '별빛 스도쿠',
            filterQuality: FilterQuality.medium,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00000000),
                  Color(0x00000000),
                  Color(0x99121C1A),
                  Color(0xE6121C1A),
                ],
                stops: [0, 0.48, 0.72, 1],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: const Alignment(0, 0.64),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: PlayViewport.maxWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ParchmentButton(
                        label: '새 퍼즐 시작',
                        onPressed: () => _startNewPuzzle(context),
                      ),
                      Consumer<GameNotifier>(
                        builder: (context, gameNotifier, _) {
                          if (!gameNotifier.hasActiveGame) {
                            return const SizedBox.shrink();
                          }
                          return ParchmentButton(
                            label: '이어서 하기',
                            fontSize: 18,
                            onPressed: () {
                              if (gameNotifier.continueGame()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const GameScreen()),
                                );
                              }
                            },
                          );
                        },
                      ),
                      ParchmentButton(
                        label: '마을 보기',
                        fontSize: 18,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VillageScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startNewPuzzle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (storyContext) => OpeningStoryScreen(
          onFinished: () {
            Navigator.pushReplacement(
              storyContext,
              MaterialPageRoute(
                builder: (_) => const DifficultySelectionScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
