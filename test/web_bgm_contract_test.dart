import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('web BGM gate owns ON and OFF gestures without a global unlock', () {
    final app = File('lib/presentation/app.dart').readAsStringSync();
    final splash = File('lib/presentation/screens/splash_screen.dart')
        .readAsStringSync();
    final gate = File('lib/presentation/widgets/web_audio_gate.dart')
        .readAsStringSync();
    final appSettings = File('lib/presentation/notifiers/app_settings.dart')
        .readAsStringSync();
    final webEntry = File('web/index.html').readAsStringSync();

    expect(app, contains('if (!kIsWeb) GameBgm.unlock();'));
    expect(splash, contains('GameBgm.startTitleFromGesture()'));
    expect(splash, contains('GameBgm.setEnabled(false)'));
    expect(splash, contains('applyWebGateAudio(enabled: true)'));
    expect(splash, contains('applyWebGateAudio(enabled: false)'));
    expect(splash, contains('_finishWebAudioGate(bgmOn: true)'));
    expect(splash, contains('_finishWebAudioGate(bgmOn: false)'));
    expect(gate, contains('backgroundColor = Color(0x9907152F)'));
    expect(gate, contains('behavior: HitTestBehavior.opaque'));
    expect(gate, contains('decoration: TextDecoration.none'));
    expect(appSettings, contains('if (_sfxSelectionRevision == sfxRevision)'));
    expect(webEntry, contains('id="starlight-html-bgm"'));
    expect(webEntry, contains('id="starlight-html-sfx"'));
    expect(webEntry, contains('preload="none"'));
    expect(webEntry, isNot(contains('1_Title_Lamplight%2520Grid.ogg')));
  });

  test('web BGM and SFX stream without preload/load', () {
    final bgm = File('lib/presentation/audio/web_html_bgm_web.dart')
        .readAsStringSync();
    final sfx = File('lib/presentation/audio/web_html_sfx_web.dart')
        .readAsStringSync();
    final main = File('lib/main.dart').readAsStringSync();
    final splash = File('lib/presentation/screens/splash_screen.dart')
        .readAsStringSync();

    expect(bgm, contains("preload = 'none'"));
    expect(sfx, contains("preload = 'none'"));
    expect(bgm, isNot(contains('.load()')));
    expect(sfx, isNot(contains('.load()')));
    expect(main, isNot(contains('preloadTitleForWeb')));
    expect(splash, isNot(contains('preloadTitleForWeb')));
  });
}
