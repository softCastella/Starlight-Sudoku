import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Browser BGM that can start in the same click as the ON button.
///
/// `audioplayers` awaits asset load before `HTMLAudioElement.play()`, so the
/// browser drops the user gesture. This element is preloaded, then `play()`
/// runs with no awaits.
class WebHtmlBgm {
  static web.HTMLAudioElement? _audio;

  static String assetUrl(String pathUnderAssets) {
    // Flutter web writes spaces as `%20` in the file name, so the URL must
    // encode that percent again (`%2520`). Same as audioplayers on web.
    final once = pathUnderAssets.split('/').map(Uri.encodeComponent).join('/');
    final relative = Uri.encodeFull('assets/assets/$once');
    return Uri.parse(web.document.baseURI).resolve(relative).toString();
  }

  static web.HTMLAudioElement _element() {
    final existing = _audio;
    if (existing != null) return existing;
    final audio = web.HTMLAudioElement()
      ..id = 'starlight-html-bgm'
      ..loop = true
      ..preload = 'auto'
      ..controls = false;
    audio.style.display = 'none';
    web.document.body?.append(audio);
    return _audio = audio;
  }

  static void prepare(String url) {
    final audio = _element();
    if (audio.src == url) return;
    audio.src = url;
    audio.load();
  }

  static Future<bool> play() async {
    final audio = _element();
    audio.loop = true;
    audio.volume = 1;
    audio.muted = false;
    try {
      // Start play() before the first await so a user-triggered call keeps
      // the browser's gesture permission for autoplay.
      await audio.play().toDart;
      return true;
    } catch (_) {
      return false;
    }
  }

  static void pause() {
    _audio?.pause();
  }

  static void stop() {
    final audio = _audio;
    if (audio == null) return;
    audio.pause();
    audio.currentTime = 0;
  }
}
