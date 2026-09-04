import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/core/village/opening_story.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/audio/game_bgm.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) VillageSceneBackdrop.precacheAll(context);
    });
  }

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
    final l10n = l10nOf(context);

    return ListenableBuilder(
      listenable: PlayUiTune.instance,
      builder: (context, _) {
    return BgmScope(
      cue: BgmCue.silence,
      child: Scaffold(
        backgroundColor: VillageSceneBackdrop.nightSky,
        body: Stack(
          fit: StackFit.expand,
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeInOutCubic,
              tween: Tween<double>(begin: _fromDawn, end: current.dawn),
              builder: (context, dawn, _) => VillageSceneBackdrop(
                dawn: dawn,
                scene: current.dawn,
              ),
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
                          l10n.skip,
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
                      padding: EdgeInsets.fromLTRB(
                        PlayUi.screenPad,
                        12,
                        PlayUi.screenPad,
                        28,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                          PlayUi.screenPad,
                          PlayUi.screenPad,
                          PlayUi.screenPad,
                          16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xF2FFF8E8),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0x66F5CC3D)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.openingHeadline(_page),
                              style: PlayUi.titleStyle(color: _ink),
                            ),
                            SizedBox(height: PlayUi.rowGap * 1.25),
                            Text(
                              l10n.openingBody(_page),
                              style: PlayUi.bodyStyle().copyWith(height: 1.55),
                            ),
                            SizedBox(height: PlayUi.rowGap * 2.25),
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
                                label: isLast ? l10n.lightFirstWindow : l10n.next,
                                width: isLast ? 148 : 80,
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
      ),
    );
      },
    );
  }
}
