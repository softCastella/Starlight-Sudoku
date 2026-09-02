import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/presentation/config/title_layout_persist.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/screens/difficulty_selection_screen.dart';
import 'package:sudoku_game/presentation/screens/game_screen.dart';
import 'package:sudoku_game/presentation/screens/opening_story_screen.dart';
import 'package:sudoku_game/presentation/screens/village_screen.dart';
import 'package:sudoku_game/presentation/widgets/parchment_button.dart';
import 'package:sudoku_game/presentation/widgets/twinkling_star_field.dart';

/// 게임 홈 화면
class HomeScreen extends StatefulWidget {
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showLayoutPanel = false;
  double _alignY = 0.7;
  double _maxWidth = 194;
  double _gap = 0;
  double _fontSize = 14;
  double _scale = 1;

  String get _layoutJson => jsonEncode({
        'alignY': double.parse(_alignY.toStringAsFixed(2)),
        'maxWidth': _maxWidth.round(),
        'gap': _gap.round(),
        'fontSize': _fontSize.round(),
        'scale': double.parse(_scale.toStringAsFixed(2)),
      });

  void _applyLayout(void Function() change) {
    setState(change);
    saveTitleButtonLayout('$_layoutJson\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwinklingStarField.nightSky,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            HomeScreen.titleAsset,
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
              alignment: Alignment(0, _alignY),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(36, 0, 36, 36),
                child: Transform.scale(
                  scale: _scale,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: _maxWidth),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ParchmentButton(
                        label: '새 퍼즐 시작',
                        fontSize: _fontSize,
                        onPressed: () => _startNewPuzzle(context),
                      ),
                      SizedBox(height: _gap),
                      Consumer<GameNotifier>(
                        builder: (context, gameNotifier, _) {
                          if (!gameNotifier.hasActiveGame) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.only(bottom: _gap),
                            child: ParchmentButton(
                              label: '이어서 하기',
                              fontSize: (_fontSize - 1).clamp(12, 18),
                              onPressed: () {
                                if (gameNotifier.continueGame()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const GameScreen()),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                      ParchmentButton(
                        label: '마을 보기',
                        fontSize: (_fontSize - 1).clamp(12, 18),
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
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 28,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _showLayoutPanel = !_showLayoutPanel),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
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
          ),
          if (_showLayoutPanel)
            Positioned(
              left: 12,
              right: 12,
              top: MediaQuery.paddingOf(context).top + 8,
              child: _TitleLayoutPanel(
                alignY: _alignY,
                maxWidth: _maxWidth,
                gap: _gap,
                fontSize: _fontSize,
                scale: _scale,
                layoutJson: _layoutJson,
                onAlignY: (value) => _applyLayout(() => _alignY = value),
                onMaxWidth: (value) => _applyLayout(() => _maxWidth = value),
                onGap: (value) => _applyLayout(() => _gap = value),
                onFontSize: (value) => _applyLayout(() => _fontSize = value),
                onScale: (value) => _applyLayout(() => _scale = value),
                onClose: () => setState(() => _showLayoutPanel = false),
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

class _TitleLayoutPanel extends StatelessWidget {
  const _TitleLayoutPanel({
    required this.alignY,
    required this.maxWidth,
    required this.gap,
    required this.fontSize,
    required this.scale,
    required this.layoutJson,
    required this.onAlignY,
    required this.onMaxWidth,
    required this.onGap,
    required this.onFontSize,
    required this.onScale,
    required this.onClose,
  });

  final double alignY;
  final double maxWidth;
  final double gap;
  final double fontSize;
  final double scale;
  final String layoutJson;
  final ValueChanged<double> onAlignY;
  final ValueChanged<double> onMaxWidth;
  final ValueChanged<double> onGap;
  final ValueChanged<double> onFontSize;
  final ValueChanged<double> onScale;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xF2FFF8E8),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    '타이틀 버튼 조절',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF24452D),
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onClose,
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
            _slider('세로 위치', alignY, 0, 1, onAlignY),
            _slider('버튼 너비', maxWidth, 160, 360, onMaxWidth),
            _slider('버튼 크기', scale, 0.5, 1.3, onScale),
            _slider('버튼 간격', gap, 0, 24, onGap),
            _slider('글자 크기', fontSize, 12, 18, onFontSize),
            SelectableText(
              layoutJson,
              style: const TextStyle(fontSize: 11, color: Color(0xFF24452D)),
            ),
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: layoutJson));
              },
              child: const Text('값 복사'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            '$label ${max <= 2 ? value.toStringAsFixed(2) : value.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF24452D)),
          ),
        ),
        Expanded(
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
