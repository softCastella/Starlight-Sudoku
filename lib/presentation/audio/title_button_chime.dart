import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:sudoku_game/presentation/notifiers/app_settings.dart';
import 'package:sudoku_game/presentation/audio/web_html_sfx.dart';

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
    _fadeTimer?.cancel();

    if (kIsWeb) {
      final started = await WebHtmlSfx.play(assetPath);
      if (!started || generation != _generation) return;
      _startFade(
        generation: generation,
        setVolume: WebHtmlSfx.setVolume,
        stop: WebHtmlSfx.stop,
      );
      return;
    }

    final existing = _player;
    final player = existing ?? AudioPlayer();
    _player = player;
    if (existing != null) await player.stop();
    await player.play(AssetSource(assetPath), volume: 1);
    if (generation != _generation) return;

    _startFade(
      generation: generation,
      setVolume: (volume) => unawaited(player.setVolume(volume)),
      stop: () => unawaited(player.stop()),
    );
  }

  static void _startFade({
    required int generation,
    required void Function(double) setVolume,
    required void Function() stop,
  }) {
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
        setVolume(0);
        stop();
        return;
      }
      final t = intoFade.inMilliseconds / fadeDuration.inMilliseconds;
      setVolume((1 - t).clamp(0.0, 1.0));
    });
  }

  static Future<void> stop() async {
    _generation++;
    _fadeTimer?.cancel();
    _fadeTimer = null;
    if (kIsWeb) {
      WebHtmlSfx.stop();
      return;
    }
    try {
      await _player?.stop();
    } catch (_) {}
  }
}
