import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/audio/title_button_chime.dart';
import 'package:sudoku_game/presentation/config/icon_baker.dart';
import 'package:sudoku_game/presentation/config/icon_layout.dart';
import 'package:sudoku_game/presentation/config/icon_layout_persist.dart';
import 'package:sudoku_game/presentation/config/title_art.dart';
import 'package:sudoku_game/presentation/config/title_layout_persist.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/notifiers/locale_override.dart';
import 'package:sudoku_game/presentation/screens/difficulty_selection_screen.dart';
import 'package:sudoku_game/presentation/screens/game_screen.dart';
import 'package:sudoku_game/presentation/screens/opening_story_screen.dart';
import 'package:sudoku_game/presentation/screens/village_screen.dart';
import 'package:sudoku_game/presentation/widgets/parchment_button.dart';
import 'package:sudoku_game/presentation/widgets/twinkling_star_field.dart';

/// 게임 홈 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const titleAsset = TitleArt.fallback;
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
  bool _showIconPanel = false;
  bool _bakingIcon = false;
  double _alignY = 0.79;
  double _maxWidth = 236;
  double _gap = 10;
  double _fontSize = 18;
  double _scale = 1;
  double _iconScale = IconArt.defaultScale;
  bool _iconTransparentPad = IconArt.defaultTransparentPad;

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

  String get _iconJson => jsonEncode({
        'scale': double.parse(_iconScale.toStringAsFixed(2)),
        'transparentPad': _iconTransparentPad,
      });

  void _applyIconLayout(void Function() change) {
    setState(change);
    saveIconLayout('$_iconJson\n');
  }

  Future<void> _bakeIconFiles() async {
    if (_bakingIcon) return;
    if (!canBakeLauncherIcons) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('웹에서는 미리보기만 됩니다. Windows에서 적용하세요.')),
      );
      return;
    }
    setState(() => _bakingIcon = true);
    try {
      await bakeLauncherIcons(
        scale: _iconScale,
        transparentPad: _iconTransparentPad,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이콘 파일에 적용했어요')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이콘 파일을 저장하지 못했어요')),
      );
    } finally {
      if (mounted) setState(() => _bakingIcon = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nOf(context);
    final titleAsset = TitleArt.assetOf(context);
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
            semanticLabel: l10n.appTitle,
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
                        label: l10n.startNewPuzzle,
                        fontSize: _fontSize,
                        onPressed: () {
                          TitleButtonChime.play();
                          _startNewPuzzle(context);
                        },
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
                              label: l10n.continueGame,
                              fontSize: (_fontSize - 1).clamp(12, 18),
                              onPressed: () {
                                TitleButtonChime.play();
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
                        label: l10n.viewVillage,
                        fontSize: (_fontSize - 1).clamp(12, 18),
                        onPressed: () {
                          TitleButtonChime.play();
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
          if (!_showLayoutPanel && !_showIconPanel)
            Positioned(
              left: 12,
              top: MediaQuery.paddingOf(context).top + 8,
              child: const _LocaleDebugMenu(),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 28,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() {
                _showIconPanel = false;
                _showLayoutPanel = !_showLayoutPanel;
              }),
              onLongPress: () => setState(() {
                _showLayoutPanel = false;
                _showIconPanel = !_showIconPanel;
              }),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                child: Text(
                  l10n.copyright,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.transparent,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          if (_showIconPanel)
            Positioned(
              left: 12,
              right: 12,
              top: MediaQuery.paddingOf(context).top + 8,
              child: _IconLayoutPanel(
                scale: _iconScale,
                transparentPad: _iconTransparentPad,
                layoutJson: _iconJson,
                baking: _bakingIcon,
                canBake: canBakeLauncherIcons,
                onScale: (value) => _applyIconLayout(() => _iconScale = value),
                onTransparentPad: (value) =>
                    _applyIconLayout(() => _iconTransparentPad = value),
                onBake: _bakeIconFiles,
                onClose: () => setState(() => _showIconPanel = false),
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

class _IconLayoutPanel extends StatelessWidget {
  const _IconLayoutPanel({
    required this.scale,
    required this.transparentPad,
    required this.layoutJson,
    required this.baking,
    required this.canBake,
    required this.onScale,
    required this.onTransparentPad,
    required this.onBake,
    required this.onClose,
  });

  final double scale;
  final bool transparentPad;
  final String layoutJson;
  final bool baking;
  final bool canBake;
  final ValueChanged<double> onScale;
  final ValueChanged<bool> onTransparentPad;
  final VoidCallback onBake;
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
                    '앱 아이콘 크기',
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
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _IconMaskPreview(
                  scale: scale,
                  transparentPad: transparentPad,
                  circular: false,
                  label: '둥근 사각',
                ),
                _IconMaskPreview(
                  scale: scale,
                  transparentPad: transparentPad,
                  circular: true,
                  label: '원형',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 88,
                  child: Text(
                    '그림 크기 ${(scale * 100).round()}%',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF24452D)),
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: scale.clamp(0.6, 1.0),
                    min: 0.6,
                    max: 1.0,
                    onChanged: onScale,
                  ),
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: const Text(
                '여백 투명',
                style: TextStyle(fontSize: 13, color: Color(0xFF24452D)),
              ),
              value: transparentPad,
              onChanged: onTransparentPad,
            ),
            SelectableText(
              layoutJson,
              style: const TextStyle(fontSize: 11, color: Color(0xFF24452D)),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: layoutJson));
                  },
                  child: const Text('값 복사'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: baking ? null : onBake,
                  child: Text(
                    baking
                        ? '적용 중…'
                        : canBake
                            ? '파일에 적용'
                            : '미리보기만',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconMaskPreview extends StatelessWidget {
  const _IconMaskPreview({
    required this.scale,
    required this.transparentPad,
    required this.circular,
    required this.label,
  });

  final double scale;
  final bool transparentPad;
  final bool circular;
  final String label;

  @override
  Widget build(BuildContext context) {
    const size = 96.0;
    final radius = circular ? size / 2 : size * 0.22;
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF5A6B52),
            borderRadius: BorderRadius.circular(radius),
            boxShadow: const [
              BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 3)),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (!transparentPad) const ColoredBox(color: IconArt.padNavy),
              Center(
                child: FractionallySizedBox(
                  widthFactor: scale,
                  heightFactor: scale,
                  child: Image.asset(
                    IconArt.sourceAsset,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF24452D)),
        ),
      ],
    );
  }
}

class _LocaleDebugMenu extends StatelessWidget {
  const _LocaleDebugMenu();

  static const _choices = <(Locale? locale, String label)>[
    (null, 'System'),
    (Locale('ko'), '한국어'),
    (Locale('en'), 'English'),
    (Locale('ja'), '日本語'),
    (Locale('zh'), '简体中文'),
    (Locale('zh', 'TW'), '繁體中文'),
  ];

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<LocaleOverride>().override;
    return Material(
      color: const Color(0xE6FFF8E8),
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 2, 4, 2),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Locale?>(
            key: const Key('locale-debug-menu'),
            isDense: true,
            value: selected,
            borderRadius: BorderRadius.circular(10),
            dropdownColor: const Color(0xFFFBF7EC),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF24452D),
            ),
            items: [
              for (final choice in _choices)
                DropdownMenuItem<Locale?>(
                  value: choice.$1,
                  child: Text(choice.$2),
                ),
            ],
            onChanged: (value) {
              context.read<LocaleOverride>().setOverride(value);
            },
          ),
        ),
      ),
    );
  }
}

