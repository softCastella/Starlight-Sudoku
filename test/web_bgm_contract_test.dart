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
    final gameBgm = File('lib/presentation/audio/game_bgm.dart')
        .readAsStringSync();
    final webEntry = File('web/index.html').readAsStringSync();
    final webPlayer = File('lib/presentation/audio/web_html_bgm_web.dart')
        .readAsStringSync();

    expect(app, contains('if (!kIsWeb) GameBgm.unlock();'));
    expect(
      splash,
      contains('_webBgmStart ??= GameBgm.startTitleFromGesture()'),
    );
    expect(splash, contains('_finishWebAudioGateAfterBgmStarts()'));
    expect(splash, contains('GameBgm.setEnabled(false)'));
    expect(splash, contains('setSfxEnabled(false)'));
    expect(splash, contains('_finishWebAudioGate(bgmOn: true)'));
    expect(splash, contains('_finishWebAudioGate(bgmOn: false)'));
    expect(gate, contains('backgroundColor = Color(0x9907152F)'));
    expect(gate, contains('behavior: HitTestBehavior.opaque'));
    expect(gate, contains('decoration: TextDecoration.none'));
    expect(appSettings, contains('if (_sfxSelectionRevision == sfxRevision)'));
    expect(gameBgm, contains("audio/BGM/1_Title_Lamplight Grid.ogg"));
    expect(webEntry, contains('id="starlight-html-bgm"'));
    expect(webEntry, contains('preload="none"'));
    expect(webEntry, isNot(contains('src="assets/assets/audio/BGM/')));
    expect(webEntry, isNot(contains('1_Title_Lamplight%2520Grid.ogg')));
    expect(webEntry, isNot(contains('rel="preload" as="audio"')));
    expect(webPlayer, contains("getElementById('starlight-html-bgm')"));
    expect(webPlayer, contains("audio.preload = 'none'"));
    expect(webPlayer, isNot(contains('audio.load()')));
  });
}
