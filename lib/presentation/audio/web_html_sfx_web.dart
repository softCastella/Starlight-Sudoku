import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'package:sudoku_game/presentation/audio/web_html_bgm.dart';

/// Title chime on web. Stream from the asset URL; do not download the file
/// first the way `audioplayers` does (bytes → then `play()`, gesture lost).
class WebHtmlSfx {
  static web.HTMLAudioElement? _audio;
  static Timer? _fadeTimer;
  static int _generation = 0;

  static String assetUrl(String pathUnderAssets) =>
      WebHtmlBgm.assetUrl(pathUnderAssets);

  static web.HTMLAudioElement _element() {
    final existing = _audio;
    if (existing != null) return existing;
    final audio = web.HTMLAudioElement()
      ..id = 'starlight-html-sfx'
      // Browser HTTP stream. Not a full-file fetch into a blob.
      ..preload = 'auto'
      ..controls = false
      ..loop = false;
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

  /// Same tap as BGM ON. Starts the stream muted so later chimes keep the
  /// gesture permission. Does not wait for the whole file.
  static void unlock() {
    final audio = _element();
    audio.muted = true;
    audio.volume = 0;
    audio.loop = false;
    try {
      audio.currentTime = 0;
    } catch (_) {}
    try {
      audio.play().toDart.then((_) {
        audio.pause();
        try {
          audio.currentTime = 0;
        } catch (_) {}
        audio.muted = false;
        audio.volume = 1;
      }, onError: (_) {});
    } catch (_) {}
  }

  static void playSparkle({
    required Duration hold,
    required Duration fade,
  }) {
    final audio = _element();
    _fadeTimer?.cancel();
    final generation = ++_generation;
    audio.muted = false;
    audio.loop = false;
    audio.volume = 1;
    try {
      audio.currentTime = 0;
    } catch (_) {}
    try {
      // Start streaming immediately. Do not await canplaythrough / full download.
      audio.play().toDart.then((_) {}, onError: (_) {});
    } catch (_) {
      return;
    }

    final started = DateTime.now();
    _fadeTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (generation != _generation) {
        timer.cancel();
        return;
      }
      final elapsed = DateTime.now().difference(started);
      if (elapsed <= hold) return;
      final intoFade = elapsed - hold;
      if (intoFade >= fade) {
        timer.cancel();
        audio.volume = 0;
        audio.pause();
        try {
          audio.currentTime = 0;
        } catch (_) {}
        return;
      }
      final t = intoFade.inMilliseconds / fade.inMilliseconds;
      audio.volume = (1 - t).clamp(0.0, 1.0);
    });
  }

  static void stop() {
    _generation++;
    _fadeTimer?.cancel();
    _fadeTimer = null;
    final audio = _audio;
    if (audio == null) return;
    audio.pause();
    try {
      audio.currentTime = 0;
    } catch (_) {}
  }

  static void setVolume(double volume) {
    _audio?.volume = volume.clamp(0.0, 1.0);
  }
}
