import 'package:flutter/material.dart';
import 'package:sudoku_game/l10n/app_localizations.dart';

/// Village paintings that ease from night, through lit windows, into day.
class VillageSceneBackdrop extends StatelessWidget {
  const VillageSceneBackdrop({
    super.key,
    required this.dawn,
    this.scene,
  });

  /// 0 is night, 1 is day. Used for sky and overlay tint.
  final double dawn;

  /// Which painting to show. Defaults to [dawn].
  ///
  /// Paintings are never crossfaded: two full scenes stacked with opacity
  /// makes buildings look double-drawn and foggy.
  final double? scene;

  static const nightSky = Color(0xFF1C3340);
  static const daySky = Color(0xFFBCE5F4);

  static const nightAsset = 'assets/images/Scene/village_scene_night.png';
  static const windowsAsset = 'assets/images/Scene/village_scene_windows.png';
  static const dayAsset = 'assets/images/Scene/village_scene_day.png';

  /// Native ratio of the village paintings (941 x 1672).
  static const paintingAspectRatio = 941 / 1672;

  static const windowPoint = 0.42;

  static Color skyColor(double dawn) => Color.lerp(nightSky, daySky, dawn)!;

  static String paintingAsset(double scene) {
    final t = scene.clamp(0.0, 1.0);
    if (t < windowPoint) return nightAsset;
    if (t < 1) return windowsAsset;
    return dayAsset;
  }

  @override
  Widget build(BuildContext context) {
    final t = dawn.clamp(0.0, 1.0);
    final asset = paintingAsset(scene ?? dawn);

    return Stack(
      fit: StackFit.expand,
      children: [
        _VillagePainting(asset: asset),
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.lerp(const Color(0x55152433), const Color(0x10FFFFFF), t)!,
                  const Color(0x00000000),
                  Color.lerp(const Color(0x44121C1A), const Color(0x10000000), t)!,
                ],
                stops: const [0, 0.42, 1],
              ),
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
      key: ValueKey(asset),
      fit: BoxFit.cover,
      alignment: Alignment.center,
      semanticLabel: AppLocalizations.of(context)?.villageVista ?? '별빛 마을 전경',
      filterQuality: FilterQuality.medium,
      gaplessPlayback: false,
    );
  }
}
