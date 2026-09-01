import 'package:flutter/material.dart';
import 'package:sudoku_game/presentation/screens/home_screen.dart';

/// 앱 시작 스플래시. 로고가 기본 크기로 나타난 뒤 살짝 커지며 페이드 아웃된다.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const Duration displayDuration = Duration(milliseconds: 2600);
  static const String logoAsset = 'assets/images/Spark_Lineup_Logo.png';

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: SplashScreen.displayDuration,
    );

    _logoOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 28,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1),
        weight: 32,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_controller);

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(1),
        weight: 28,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.06).chain(CurveTween(curve: Curves.easeOut)),
        weight: 32,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.06, end: 1.08).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
    ]).animate(_controller);

    _overlayOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(1),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_controller);

    _controller.forward().whenComplete(() {
      if (!mounted) return;
      setState(() => _showOverlay = false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const HomeScreen(),
        if (_showOverlay)
          IgnorePointer(
            child: FadeTransition(
              opacity: _overlayOpacity,
              child: ColoredBox(
                color: Colors.white,
                child: Center(
                  child: FadeTransition(
                    opacity: _logoOpacity,
                    child: ScaleTransition(
                      alignment: Alignment.center,
                      scale: _logoScale,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Image(
                          image: AssetImage(SplashScreen.logoAsset),
                          width: 420,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
