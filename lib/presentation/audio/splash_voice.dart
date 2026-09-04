import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sudoku_game/presentation/notifiers/app_settings.dart';

/// Tyche Spark ident when the splash logo appears.
class SplashVoice {
  SplashVoice._();

  static const assetPath = 'audio/Voice/Tyche Spark Splash Voice.ogg';
  static const bundlePath = 'assets/$assetPath';

  static AudioPlayer? _player;
  static var _generation = 0;

  static Future<void> play() async {
    if (const bool.fromEnvironment('FLUTTER_TEST')) return;
    if (kIsWeb) return;
    if (!AppSettings.sfxOn) return;

    final generation = ++_generation;
    await _disposePlayer();
    if (generation != _generation) return;

    final player = AudioPlayer();
    _player = player;
    try {
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setVolume(1);
      await player.setPlayerMode(PlayerMode.mediaPlayer);
      final bytes = await rootBundle.load(bundlePath);
      if (generation != _generation) {
        await _disposeGiven(player);
        return;
      }
      await player.play(
        BytesSource(
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
          mimeType: 'audio/ogg',
        ),
      );
    } catch (_) {
      if (identical(_player, player)) {
        try {
          await player.play(AssetSource(assetPath));
        } catch (_) {
          await _disposeGiven(player);
        }
      }
    }
  }

  static Future<void> stop() async {
    _generation++;
    await _disposePlayer();
  }

  static Future<void> _disposePlayer() async {
    final player = _player;
    _player = null;
    if (player == null) return;
    await _disposeGiven(player);
  }

  static Future<void> _disposeGiven(AudioPlayer player) async {
    if (identical(_player, player)) _player = null;
    try {
      await player.stop();
      await player.dispose();
    } catch (_) {}
  }
}
