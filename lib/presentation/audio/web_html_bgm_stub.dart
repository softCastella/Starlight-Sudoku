/// VM / APK stub. Web BGM uses an HTMLAudioElement instead.
class WebHtmlBgm {
  static void prepare(String url) {}

  static Future<bool> play() async => false;

  static void pause() {}

  static void stop() {}

  static String assetUrl(String pathUnderAssets) => '';
}
