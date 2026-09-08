import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Short web sound effects streamed directly from the user's pointer gesture.
class WebHtmlSfx {
  static web.HTMLAudioElement? _audio;

  static String _assetUrl(String pathUnderAssets) {
    final once = pathUnderAssets.split('/').map(Uri.encodeComponent).join('/');
    final relative = Uri.encodeFull('assets/assets/$once');
    return Uri.parse(web.document.baseURI).resolve(relative).toString();
  }

  static web.HTMLAudioElement _element() {
    final existing = _audio;
    if (existing != null) return existing;
    final fromHtml = web.document.getElementById('starlight-html-sfx');
    if (fromHtml != null) return _audio = fromHtml as web.HTMLAudioElement;
    final audio = web.HTMLAudioElement()
      ..id = 'starlight-html-sfx'
      ..preload = 'none'
      ..controls = false;
    audio.style.display = 'none';
    web.document.body?.append(audio);
    return _audio = audio;
  }

  static Future<bool> play(String pathUnderAssets) async {
    final audio = _element();
    final url = _assetUrl(pathUnderAssets);
    audio.pause();
    audio.preload = 'none';
    if (audio.src != url) {
      audio.src = url;
    } else {
      try {
        audio.currentTime = 0;
      } catch (_) {}
    }
    audio.volume = 1;
    try {
      // No await occurs before play(): the pointer gesture starts native
      // progressive loading immediately and preserves autoplay permission.
      await audio.play().toDart;
      return true;
    } catch (_) {
      return false;
    }
  }

  static void setVolume(double volume) {
    _audio?.volume = volume.clamp(0, 1);
  }

  static void stop() {
    final audio = _audio;
    if (audio == null) return;
    audio.pause();
    try {
      audio.currentTime = 0;
    } catch (_) {}
  }
}
