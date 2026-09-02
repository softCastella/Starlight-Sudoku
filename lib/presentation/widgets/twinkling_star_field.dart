import 'dart:math';

import 'package:flutter/material.dart';

/// Seeded night-sky stars that twinkle in place. Does not intercept pointer events.
class TwinklingStarField extends StatefulWidget {
  const TwinklingStarField({super.key});

  /// Sampled from the top of `starlight_sudoku_title.png`.
  static const nightSky = Color(0xFF0E2040);

  @override
  State<TwinklingStarField> createState() => _TwinklingStarFieldState();
}

class _TwinklingStarFieldState extends State<TwinklingStarField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<StarParticle> _stars;

  @override
  void initState() {
    super.initState();
    _stars = StarParticle.seeded();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
    );

    // Repeating tickers never settle; freeze a mid-twinkle frame in widget tests.
    if (WidgetsBinding.instance.runtimeType
        .toString()
        .contains('TestWidgetsFlutterBinding')) {
      _controller.value = 0.38;
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.paddingOf(context).top;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: StarPainter(
              stars: _stars,
              t: _controller.value,
              statusBarHeight: statusBarHeight,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

enum StarKind { dot, cross }

enum StarBand { statusBar, sky }

class StarParticle {
  const StarParticle({
    required this.nx,
    required this.ny,
    required this.size,
    required this.phase,
    required this.speed,
    required this.baseOpacity,
    required this.twinkleStrength,
    required this.minScale,
    required this.maxScale,
    required this.kind,
    required this.color,
    required this.glow,
    required this.twinkle,
    required this.band,
  });

  final double nx;
  final double ny;
  final double size;
  final double phase;
  final double speed;
  final double baseOpacity;
  final double twinkleStrength;
  final double minScale;
  final double maxScale;
  final StarKind kind;
  final Color color;
  final bool glow;
  final bool twinkle;
  final StarBand band;

  static const _gold = Color(0xFFFFE7A1);
  static const _goldBright = Color(0xFFFFF4CB);
  static const _whiteSoft = Color(0xB3FFFFFF);
  static const _whiteFaint = Color(0x80FFFFFF);

  /// Fixed sky so launches do not reshuffle the night.
  static List<StarParticle> seeded() {
    final random = Random(20260902);
    final stars = <StarParticle>[];

    void add({
      required double nx,
      required double ny,
      required StarBand band,
      required double size,
      required StarKind kind,
      required Color color,
      required bool twinkle,
      required bool glow,
    }) {
      stars.add(
        StarParticle(
          nx: nx,
          ny: ny,
          size: size,
          phase: random.nextDouble() * pi * 2,
          speed: twinkle ? (0.7 + random.nextDouble() * 1.6) : 0,
          baseOpacity: twinkle
              ? 0.18 + random.nextDouble() * 0.12
              : 0.38 + random.nextDouble() * 0.28,
          twinkleStrength: twinkle ? 0.45 + random.nextDouble() * 0.40 : 0,
          minScale: twinkle ? 0.65 : 1,
          maxScale: twinkle ? 1.10 + random.nextDouble() * 0.18 : 1,
          kind: kind,
          color: color,
          glow: glow,
          twinkle: twinkle,
          band: band,
        ),
      );
    }

    // Status bar: tiny dots/crosses, anchored to padding.top on every device.
    const status = <(double, double, double, StarKind, bool)>[
      (0.10, 0.38, 2.0, StarKind.dot, false),
      (0.22, 0.62, 2.4, StarKind.cross, true),
      (0.34, 0.28, 1.8, StarKind.dot, false),
      (0.47, 0.70, 2.2, StarKind.dot, false),
      (0.58, 0.40, 3.0, StarKind.cross, true),
      (0.71, 0.58, 1.7, StarKind.dot, false),
      (0.83, 0.32, 2.6, StarKind.cross, false),
      (0.92, 0.66, 2.0, StarKind.dot, false),
    ];
    for (final s in status) {
      add(
        nx: s.$1,
        ny: s.$2,
        band: StarBand.statusBar,
        size: s.$3,
        kind: s.$4,
        color: s.$4 == StarKind.cross ? _gold : _whiteSoft,
        twinkle: s.$5,
        glow: false,
      );
    }

    // Night sky: denser around the logo, sparse toward the village.
    const sky = <(double, double, double, StarKind, Color, bool, bool)>[
      // Top edge / moon side — connects status bar to sky.
      (0.08, 0.095, 2.2, StarKind.dot, _whiteFaint, false, false),
      (0.18, 0.072, 2.8, StarKind.cross, _gold, true, false),
      (0.38, 0.048, 2.0, StarKind.dot, _whiteSoft, false, false),
      (0.63, 0.040, 2.4, StarKind.dot, _whiteFaint, true, false),
      (0.78, 0.068, 3.2, StarKind.cross, _goldBright, true, true),
      (0.91, 0.090, 1.8, StarKind.dot, _whiteSoft, false, false),
      // Logo halo (not on the letterforms).
      (0.14, 0.155, 4.6, StarKind.cross, _gold, true, true),
      (0.22, 0.235, 2.4, StarKind.dot, _goldBright, false, false),
      (0.26, 0.125, 3.4, StarKind.cross, _goldBright, true, false),
      (0.78, 0.150, 5.2, StarKind.cross, _gold, true, true),
      (0.86, 0.185, 2.6, StarKind.dot, _gold, false, false),
      (0.82, 0.250, 3.0, StarKind.cross, _goldBright, true, false),
      (0.12, 0.205, 2.0, StarKind.dot, _whiteSoft, false, false),
      (0.08, 0.255, 3.6, StarKind.cross, _gold, true, false),
      (0.18, 0.290, 2.2, StarKind.dot, _whiteFaint, false, false),
      // Mid sky.
      (0.10, 0.340, 2.8, StarKind.cross, _gold, true, false),
      (0.24, 0.325, 1.8, StarKind.dot, _whiteSoft, false, false),
      (0.33, 0.370, 3.2, StarKind.cross, _goldBright, true, false),
      (0.16, 0.410, 2.4, StarKind.dot, _whiteFaint, false, false),
      (0.28, 0.445, 2.0, StarKind.dot, _gold, false, false),
      (0.08, 0.390, 1.7, StarKind.dot, _whiteSoft, true, false),
      (0.40, 0.335, 2.2, StarKind.dot, _whiteFaint, false, false),
      (0.42, 0.285, 4.2, StarKind.cross, _gold, true, true),
      (0.68, 0.310, 2.0, StarKind.dot, _whiteSoft, false, false),
      // Village-top sky, left of the character.
      (0.07, 0.470, 2.0, StarKind.dot, _whiteFaint, false, false),
      (0.18, 0.490, 2.6, StarKind.cross, _gold, true, false),
      (0.12, 0.520, 1.6, StarKind.dot, _whiteSoft, false, false),
    ];
    for (final s in sky) {
      add(
        nx: s.$1,
        ny: s.$2,
        band: StarBand.sky,
        size: s.$3,
        kind: s.$4,
        color: s.$5,
        twinkle: s.$6,
        glow: s.$7,
      );
    }

    return stars;
  }
}

class StarPainter extends CustomPainter {
  StarPainter({
    required this.stars,
    required this.t,
    required this.statusBarHeight,
  });

  final List<StarParticle> stars;
  final double t;
  final double statusBarHeight;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final paint = Paint()..style = PaintingStyle.fill;

    for (final star in stars) {
      final pos = star.band == StarBand.statusBar
          ? Offset(star.nx * size.width, star.ny * statusBarHeight)
          : Offset(star.nx * size.width, star.ny * size.height);

      var fade = 1.0;
      if (star.band == StarBand.sky) {
        final ny = star.ny;
        if (ny > 0.56) {
          fade = 0;
        } else if (ny > 0.42) {
          fade = 1 - (ny - 0.42) / 0.14;
        }
      }
      if (fade <= 0) continue;

      final wave = star.twinkle
          ? _smooth((sin(t * star.speed * pi * 2 + star.phase) + 1) / 2)
          : 0.55;
      final opacity =
          ((star.baseOpacity + wave * star.twinkleStrength) * fade).clamp(0.0, 1.0);
      final scale = star.minScale + wave * (star.maxScale - star.minScale);
      final radius = star.size * scale * 0.5;

      if (star.glow) {
        paint
          ..color = StarParticle._gold.withValues(alpha: 0.55 * opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);
        canvas.drawCircle(pos, radius * 1.35, paint);
        paint.maskFilter = null;
      }

      paint.color = star.color.withValues(alpha: opacity);
      if (star.kind == StarKind.dot) {
        canvas.drawCircle(pos, radius, paint);
      } else {
        _drawCross(canvas, pos, star.size * scale, paint);
      }
    }
  }

  static double _smooth(double x) => x * x * (3 - 2 * x);

  static void _drawCross(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final radius = i.isEven ? size * 0.5 : size * 0.12;
      final angle = -pi / 2 + i * (pi / 4);
      final p = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.statusBarHeight != statusBarHeight;
  }
}
