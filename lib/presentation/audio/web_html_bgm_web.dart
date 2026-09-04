import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Browser BGM that can start in the same click as the ON button.
///
/// `audioplayers` awaits asset load before `HTMLAudioElement.play()`, so the
/// browser drops the user gesture. This element is preloaded, then `play()`
/// runs with no awaits.
class WebHtmlBgm {
  static const _gateId = 'starlight-bgm-gate';

  static web.HTMLAudioElement? _audio;
  static bool _gateBusy = false;

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

  static void play() {
    final audio = _element();
    audio.loop = true;
    audio.volume = 1;
    audio.muted = false;
    audio.play();
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

  static void mountGate({
    required String onLabel,
    required String offLabel,
    required String buttonImageUrl,
    required void Function() onStart,
    required void Function() onSkip,
  }) {
    unmountGate();
    _gateBusy = false;

    final overlay = web.document.createElement('div') as web.HTMLDivElement;
    overlay.id = _gateId;
    overlay.setAttribute(
      'style',
      'position:fixed;inset:0;z-index:2147483647;display:flex;'
      'flex-direction:column;align-items:center;justify-content:center;'
      'gap:12px;background:rgba(7,21,47,0.85);font-family:sans-serif;',
    );

    overlay.appendChild(
      _ovalButton(
        label: onLabel,
        imageUrl: buttonImageUrl,
        onPressed: () {
          if (_gateBusy) return;
          _gateBusy = true;
          onStart();
          unmountGate();
        },
      ),
    );
    overlay.appendChild(
      _ovalButton(
        label: offLabel,
        imageUrl: buttonImageUrl,
        onPressed: () {
          if (_gateBusy) return;
          _gateBusy = true;
          stop();
          onSkip();
          unmountGate();
        },
      ),
    );

    web.document.body?.appendChild(overlay);
  }

  static web.HTMLButtonElement _ovalButton({
    required String label,
    required String imageUrl,
    required void Function() onPressed,
  }) {
    final button = web.document.createElement('button') as web.HTMLButtonElement;
    button.textContent = label;
    button.setAttribute(
      'style',
      'width:min(220px,72vw);aspect-ratio:551/176;border:0;padding:0;'
      'color:#24452D;font-weight:800;font-size:15px;cursor:pointer;'
      'background-color:#FBF7EC;background-image:url("$imageUrl");'
      'background-size:100% 100%;background-repeat:no-repeat;'
      'background-position:center;',
    );
    button.addEventListener(
      'pointerdown',
      (web.Event event) {
        event.stopPropagation();
        onPressed();
      }.toJS,
    );
    return button;
  }

  static void unmountGate() {
    web.document.getElementById(_gateId)?.remove();
  }
}
