import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/screens/difficulty_selection_screen.dart';
import 'package:sudoku_game/presentation/screens/game_screen.dart';
import 'package:sudoku_game/presentation/screens/opening_story_screen.dart';
import 'package:sudoku_game/presentation/screens/village_screen.dart';
import 'package:sudoku_game/presentation/widgets/parchment_button.dart';
import 'package:sudoku_game/presentation/widgets/twinkling_star_field.dart';

/// 게임 홈 화면
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const titleAsset =
      'assets/images/Scene/Title_Image_Starlight Sdoku.png';
  static const _navy = Color(0xFF0E2040);

  /// Opaque colors on web: Chrome paints a yellow bar if theme-color is transparent.
  static SystemUiOverlayStyle get nightOverlayStyle => SystemUiOverlayStyle(
        statusBarColor: kIsWeb ? _navy : Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarColor: kIsWeb ? _navy : Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false,
      );

  static SystemUiOverlayStyle get splashOverlayStyle => SystemUiOverlayStyle(
        statusBarColor: kIsWeb ? Colors.white : Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarColor: kIsWeb ? Colors.white : Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwinklingStarField.nightSky,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            titleAsset,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.12),
            semanticLabel: '별빛 스도쿠',
            filterQuality: FilterQuality.medium,
            cacheWidth: (MediaQuery.sizeOf(context).width *
                    MediaQuery.devicePixelRatioOf(context))
                .round()
                .clamp(480, 1440),
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
          const Positioned.fill(child: TwinklingStarField()),
          SafeArea(
            child: Align(
              alignment: const Alignment(0, 0.64),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 248),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ParchmentButton(
                        label: '새 퍼즐 시작',
                        fontSize: 16,
                        onPressed: () => _startNewPuzzle(context),
                      ),
                      Consumer<GameNotifier>(
                        builder: (context, gameNotifier, _) {
                          if (!gameNotifier.hasActiveGame) {
                            return const SizedBox.shrink();
                          }
                          return ParchmentButton(
                            label: '이어서 하기',
                            fontSize: 15,
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
                        fontSize: 15,
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
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Text(
                'ⓒ Tyche Spark. All rights reserved',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  height: 1,
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
