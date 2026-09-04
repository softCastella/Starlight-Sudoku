import 'package:audioplayers/audioplayers.dart';
import 'package:sudoku_game/presentation/notifiers/app_settings.dart';

/// Tyche Spark ident when the splash logo appears.
class SplashVoice {
  SplashVoice._();

  static const assetPath = 'audio/Voice/Tyche Spark Splash Voice.ogg';

  static AudioPlayer? _player;

  static Future<void> play() async {
    if (const bool.fromEnvironment('FLUTTER_TEST')) return;
    if (!AppSettings.sfxOn) return;

    final player = _player ??= AudioPlayer();
    try {
      await player.stop();
      await player.setVolume(1);
      await player.play(AssetSource(assetPath));
    } catch (_) {}
  }

  static Future<void> stop() async {
    try {
      await _player?.stop();
    } catch (_) {}
  }
}
