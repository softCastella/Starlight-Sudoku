import 'package:flutter/material.dart';

/// Village paintings that ease from night, through lit windows, into day.
class VillageSceneBackdrop extends StatelessWidget {
  const VillageSceneBackdrop({
    super.key,
    required this.dawn,
  });

  /// 0 is the night painting, 1 is the daytime painting.
  final double dawn;

  static const nightSky = Color(0xFF1C3340);
  static const daySky = Color(0xFFBCE5F4);

  static const nightAsset = 'assets/images/village_scene_night.png';
  static const windowsAsset = 'assets/images/village_scene_windows.png';
  static const dayAsset = 'assets/images/village_scene_day.png';

  /// Native ratio of the village paintings (941 x 1672).
  static const paintingAspectRatio = 941 / 1672;

  static const _windowPoint = 0.42;

  static Color skyColor(double dawn) => Color.lerp(nightSky, daySky, dawn)!;

  @override
  Widget build(BuildContext context) {
    final t = dawn.clamp(0.0, 1.0);
    final Widget paintings;
    if (t < _windowPoint) {
      final intoWindows = t / _windowPoint;
      paintings = Stack(
        fit: StackFit.expand,
        children: [
          const _VillagePainting(asset: windowsAsset),
          Opacity(
            opacity: 1 - intoWindows,
            child: const _VillagePainting(asset: nightAsset),
          ),
        ],
      );
    } else {
      final intoDay = (t - _windowPoint) / (1 - _windowPoint);
      paintings = Stack(
        fit: StackFit.expand,
        children: [
          const _VillagePainting(asset: dayAsset),
          Opacity(
            opacity: 1 - intoDay,
            child: const _VillagePainting(asset: windowsAsset),
          ),
        ],
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        paintings,
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.02, 0.38),
                radius: 0.78,
                colors: [
                  Color(0xFFFFE56A).withValues(alpha: 0.28 * (1 - t * 0.55)),
                  Color(0xFFF5CC3D).withValues(alpha: 0.10 * (1 - t * 0.4)),
                  const Color(0x00FFE56A),
                ],
                stops: const [0, 0.42, 1],
              ),
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.lerp(const Color(0x66152433), const Color(0x14FFFFFF), t)!,
                const Color(0x00000000),
                Color.lerp(const Color(0x55121C1A), const Color(0x14000000), t)!,
              ],
              stops: const [0, 0.42, 1],
            ),
          ),
        ),
      ],
    );
  }
}

class _VillagePainting extends StatelessWidget {
  const _VillagePainting({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      semanticLabel: '별빛 마을 전경',
      filterQuality: FilterQuality.medium,
    );
  }
}
