import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/audio/game_bgm.dart';
import 'package:sudoku_game/presentation/audio/splash_voice.dart';
import 'package:sudoku_game/presentation/config/title_art.dart';
import 'package:sudoku_game/presentation/notifiers/app_settings.dart';
import 'package:sudoku_game/presentation/screens/home_screen.dart';
import 'package:sudoku_game/presentation/widgets/exit_game_dialog.dart';
import 'package:sudoku_game/presentation/widgets/oval_image_button.dart';
import 'package:sudoku_game/presentation/widgets/village_scene_backdrop.dart';

/// APK: white logo splash. Web skips this and starts at the BGM ON/OFF gate.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const Duration displayDuration = Duration(milliseconds: 3200);
  static const String logoAsset =
      'assets/images/Logo/Spark_Lineup_Logo_nuki.png';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  late final AnimationController _controller;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _overlayOpacity;
  bool _showOverlay = !kIsWeb;
  bool _showWebAudioGate = kIsWeb;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: SplashScreen.displayDuration,
    );

    const fade = Curves.easeInOutCubic;

    // 나타나기 → 잠깐 머무르기 → 로고만 사라지기 → 흰 배경이 걷히기
    _logoOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: fade)),
        weight: 38,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 18),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: fade)),
        weight: 32,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 12),
    ]).animate(_controller);

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.78,
          end: 0.98,
        ).chain(CurveTween(curve: fade)),
        weight: 38,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.98,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 18,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 44),
    ]).animate(_controller);

    _overlayOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 88),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: fade)),
        weight: 12,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted && !kIsWeb) {
        unawaited(SplashVoice.stop());
        setState(() => _showOverlay = false);
        _playTitleIfCurrent();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      GameBgm.routeObserver.subscribe(this, route);
    }
    if (_started) return;
    _started = true;
    if (kIsWeb) {
      unawaited(_precacheGameArt());
      return;
    }
    _startSplash();
  }

  @override
  void didPushNext() {}

  @override
  void didPopNext() {
    _playTitleIfCurrent();
  }

  void _playTitleIfCurrent() {
    if (!mounted || _showOverlay) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    GameBgm.playTitle();
  }

  Future<void> _finishWebAudioGate({required bool bgmOn}) async {
    if (!_showWebAudioGate) return;
    setState(() => _showWebAudioGate = false);
    await context.read<AppSettings>().setBgmEnabled(bgmOn);
    if (mounted) GameBgm.playTitle();
  }

  Future<void> _startSplash() async {
    unawaited(_precacheGameArt());
    try {
      await precacheImage(
        const AssetImage(SplashScreen.logoAsset),
        context,
      ).timeout(const Duration(milliseconds: 1200));
    } catch (_) {}
    if (!mounted) return;
    unawaited(SplashVoice.play());
    _controller.forward();
  }

  Future<void> _precacheGameArt() async {
    try {
      await Future.wait([
        precacheImage(AssetImage(TitleArt.assetOf(context)), context),
        VillageSceneBackdrop.precacheAll(context),
      ]);
    } catch (_) {}
  }

  @override
  void dispose() {
    GameBgm.routeObserver.unsubscribe(this);
    unawaited(SplashVoice.stop());
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_showOverlay) {
          await SystemNavigator.pop();
          return;
        }
        final leave = await ExitGameDialog.confirm(context);
        if (leave) await SystemNavigator.pop();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: _showOverlay
            ? HomeScreen.splashOverlayStyle
            : HomeScreen.nightOverlayStyle,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const HomeScreen(),
            if (_showOverlay)
              Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (_) => unawaited(SplashVoice.play()),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FadeTransition(
                      opacity: _overlayOpacity,
                      child: const ColoredBox(
                        color: Colors.white,
                        child: SizedBox.expand(),
                      ),
                    ),
                    FadeTransition(
                      opacity: _logoOpacity,
                      child: ScaleTransition(
                        alignment: Alignment.center,
                        scale: _logoScale,
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 48),
                            child: Image(
                              image: AssetImage(SplashScreen.logoAsset),
                              width: 232,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_showWebAudioGate) _webAudioGate(),
          ],
        ),
      ),
    );
  }

  Widget _webAudioGate() {
    final l10n = l10nOf(context);
    return ColoredBox(
      color: const Color(0xD907152F),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OvalImageButton(
              key: const Key('web-audio-start'),
              label: l10n.webBgmOn,
              onPressed: () => unawaited(_finishWebAudioGate(bgmOn: true)),
            ),
            const SizedBox(height: 12),
            OvalImageButton(
              key: const Key('web-audio-off'),
              label: l10n.webBgmOff,
              onPressed: () => unawaited(_finishWebAudioGate(bgmOn: false)),
            ),
          ],
        ),
      ),
    );
  }
}
