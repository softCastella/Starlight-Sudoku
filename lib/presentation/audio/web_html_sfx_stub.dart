/// VM / APK stub. Web SFX streams from an HTMLAudioElement instead.
class WebHtmlSfx {
  static void prepare(String url) {}

  static void unlock() {}

  static void playSparkle({
    required Duration hold,
    required Duration fade,
  }) {}

  static void stop() {}

  static void setVolume(double volume) {}

  static String assetUrl(String pathUnderAssets) => '';
}
