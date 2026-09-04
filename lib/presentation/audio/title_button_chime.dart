import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:sudoku_game/presentation/notifiers/app_settings.dart';

/// Title parchment tap chime. Sparkle, then fade — do not play the whole tail.
class TitleButtonChime {
  TitleButtonChime._();

  static const assetPath = 'audio/SFX/title button twinkle chime.ogg';
  static const holdDuration = Duration(milliseconds: 200);
  static const fadeDuration = Duration(milliseconds: 180);

  static AudioPlayer? _player;
  static Timer? _fadeTimer;
  static int _generation = 0;

  static Future<void> play() async {
    if (const bool.fromEnvironment('FLUTTER_TEST')) return;
    if (!AppSettings.sfxOn) return;

    final generation = ++_generation;
    final player = _player ??= AudioPlayer();
    _fadeTimer?.cancel();
    await player.stop();
    await player.setVolume(1);
    await player.play(AssetSource(assetPath));
    if (generation != _generation) return;

    final started = DateTime.now();
    _fadeTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (generation != _generation) {
        timer.cancel();
        return;
      }
      final elapsed = DateTime.now().difference(started);
      if (elapsed <= holdDuration) return;

      final intoFade = elapsed - holdDuration;
      if (intoFade >= fadeDuration) {
        timer.cancel();
        player.setVolume(0);
        player.stop();
        return;
      }
      final t = intoFade.inMilliseconds / fadeDuration.inMilliseconds;
      player.setVolume((1 - t).clamp(0.0, 1.0));
    });
  }

  static Future<void> stop() async {
    _generation++;
    _fadeTimer?.cancel();
    _fadeTimer = null;
    try {
      await _player?.stop();
    } catch (_) {}
  }
}
