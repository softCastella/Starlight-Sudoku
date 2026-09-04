import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:sudoku_game/presentation/notifiers/app_settings.dart';

/// Title parchment tap chime. Fades out in the last moments of the clip.
class TitleButtonChime {
  TitleButtonChime._();

  static const assetPath = 'audio/SFX/title button twinkle chime.ogg';
  static const fadeDuration = Duration(milliseconds: 420);

  static AudioPlayer? _player;
  static StreamSubscription<Duration>? _positionSub;
  static StreamSubscription<Duration>? _durationSub;
  static int _generation = 0;
  static Duration? _clipDuration;

  static Future<void> play() async {
    if (const bool.fromEnvironment('FLUTTER_TEST')) return;
    if (!AppSettings.sfxOn) return;

    final generation = ++_generation;
    final player = _player ??= AudioPlayer();
    await _positionSub?.cancel();
    await _durationSub?.cancel();
    await player.stop();
    await player.setVolume(1);
    await player.play(AssetSource(assetPath));
    _clipDuration = await player.getDuration();

    _durationSub = player.onDurationChanged.listen((duration) {
      if (generation == _generation) _clipDuration = duration;
    });
    _positionSub = player.onPositionChanged.listen((position) {
      if (generation != _generation) return;
      final duration = _clipDuration;
      if (duration == null || duration <= Duration.zero) return;

      final fadeFor = duration < fadeDuration ? duration : fadeDuration;
      final remaining = duration - position;
      if (remaining <= Duration.zero) return;
      if (remaining > fadeFor) return;

      final volume = remaining.inMilliseconds / fadeFor.inMilliseconds;
      player.setVolume(volume.clamp(0, 1));
    });
  }

  static Future<void> stop() async {
    _generation++;
    await _positionSub?.cancel();
    await _durationSub?.cancel();
    _positionSub = null;
    _durationSub = null;
    try {
      await _player?.stop();
    } catch (_) {}
  }
}
