/// VM / APK stub. Web SFX uses an HTMLAudioElement instead.
class WebHtmlSfx {
  static Future<bool> play(String pathUnderAssets) async => false;

  static void setVolume(double volume) {}

  static void stop() {}
}
