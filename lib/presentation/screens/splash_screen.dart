import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku_game/presentation/screens/home_screen.dart';
import 'package:sudoku_game/presentation/widgets/village_scene_backdrop.dart';

/// 흰 화면에서 로고가 천천히 나타나며 살짝 커진 뒤, 같은 속도로 사라진다.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const Duration displayDuration = Duration(milliseconds: 3200);
  static const String logoAsset = 'assets/images/Logo/Spark_Lineup_Logo_nuki.png';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _overlayOpacity;
  bool _showOverlay = true;
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
        tween: Tween<double>(begin: 0.78, end: 0.98).chain(CurveTween(curve: fade)),
        weight: 38,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.98, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
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
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _showOverlay = false);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _startSplash();
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
    await Future<void>.delayed(Duration.zero);
    if (mounted) _controller.forward();
  }

  Future<void> _precacheGameArt() async {
    try {
      await Future.wait([
        precacheImage(const AssetImage(HomeScreen.titleAsset), context),
        precacheImage(
          const AssetImage(VillageSceneBackdrop.nightAsset),
          context,
        ),
      ]).timeout(const Duration(milliseconds: 4000));
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _showOverlay
          ? HomeScreen.splashOverlayStyle
          : HomeScreen.nightOverlayStyle,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const HomeScreen(),
          if (_showOverlay)
            AbsorbPointer(
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
        ],
      ),
    );
  }
}
