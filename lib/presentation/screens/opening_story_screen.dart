import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/village/opening_story.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/widgets/oval_image_button.dart';
import 'package:sudoku_game/presentation/widgets/play_viewport.dart';
import 'package:sudoku_game/presentation/widgets/village_scene_backdrop.dart';

/// Opening story shown when starting a new puzzle from the title screen.
class OpeningStoryScreen extends StatefulWidget {
  const OpeningStoryScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<OpeningStoryScreen> createState() => _OpeningStoryScreenState();
}

class _OpeningStoryScreenState extends State<OpeningStoryScreen> {
  static const _ink = Color(0xFF24452D);
  static const _gold = Color(0xFFF5CC3D);

  int _page = 0;
  double _fromDawn = 0;

  Future<void> _finish() async {
    await context.read<GameNotifier>().completeOpeningStory();
    if (mounted) widget.onFinished();
  }

  void _next() {
    if (_page >= OpeningStoryPage.pages.length - 1) {
      _finish();
      return;
    }
    setState(() {
      _fromDawn = OpeningStoryPage.pages[_page].dawn;
      _page += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = OpeningStoryPage.pages;
    final current = pages[_page];
    final isLast = _page == pages.length - 1;

    return Scaffold(
      backgroundColor: VillageSceneBackdrop.skyColor(current.dawn),
      body: Stack(
        fit: StackFit.expand,
        children: [
          TweenAnimationBuilder<double>(
            key: ValueKey(_page),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOutCubic,
            tween: Tween<double>(begin: _fromDawn, end: current.dawn),
            builder: (context, dawn, _) => VillageSceneBackdrop(dawn: dawn),
          ),
          SafeArea(
            child: PlayViewport(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _finish,
                      child: Text(
                        '건너뛰기',
                        style: TextStyle(
                          color: Color.lerp(
                            const Color(0xE6FFF8E8),
                            const Color(0xE624452D),
                            current.dawn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      decoration: BoxDecoration(
                        color: const Color(0xF2FFF8E8),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0x66F5CC3D)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            current.headline,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: _ink,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            current.body,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.55,
                              color: Color(0xFF4D6554),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: List.generate(pages.length, (dot) {
                              return Container(
                                margin: const EdgeInsets.only(right: 6),
                                width: dot == _page ? 16 : 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: dot == _page ? _gold : const Color(0xFFD8CBB0),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OvalImageButton(
                              label: isLast ? '첫 창문을 밝히기' : '다음',
                              width: isLast ? 112 : 80,
                              height: 28,
                              fontSize: 12,
                              onPressed: _next,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
