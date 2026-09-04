/// VM / APK stub. Web BGM uses an HTMLAudioElement instead.
class WebHtmlBgm {
  static void prepare(String url) {}

  static void play() {}

  static void pause() {}

  static void stop() {}

  static void mountGate({
    required String onLabel,
    required String offLabel,
    required String buttonImageUrl,
    required void Function() onStart,
    required void Function() onSkip,
  }) {}

  static void unmountGate() {}

  static String assetUrl(String pathUnderAssets) => '';
}
