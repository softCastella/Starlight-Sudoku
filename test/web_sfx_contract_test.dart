import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/presentation/widgets/parchment_button.dart';

void main() {
  test('web button SFX starts on press without preloading or plugin waits', () {
    final chime = File('lib/presentation/audio/title_button_chime.dart')
        .readAsStringSync();
    final webSfx = File('lib/presentation/audio/web_html_sfx_web.dart')
        .readAsStringSync();
    final button = File('lib/presentation/widgets/parchment_button.dart')
        .readAsStringSync();
    final home = File('lib/presentation/screens/home_screen.dart')
        .readAsStringSync();
    final webEntry = File('web/index.html').readAsStringSync();

    expect(chime, contains('if (kIsWeb)'));
    expect(chime, contains('WebHtmlSfx.playSparkle'));
    expect(button, contains('widget.onPressStart?.call()'));
    expect(home, contains('onPressStart: TitleButtonChime.play'));
    expect(webEntry, contains('id="starlight-html-sfx"'));
    expect(webEntry, contains('preload="none"'));
    expect(webEntry, isNot(contains('title%2520button%2520twinkle')));
    expect(webSfx, contains("preload = 'none'"));
    expect(webSfx, contains('audio.play().toDart'));
    expect(webSfx, isNot(contains('audio.load()')));
  });

  testWidgets('parchment press-start runs before its navigation callback', (
    tester,
  ) async {
    final events = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ParchmentButton(
            label: 'Start',
            onPressStart: () => events.add('sound'),
            onPressed: () => events.add('navigate'),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(ParchmentButton)),
    );
    await tester.pump();
    expect(events, ['sound']);

    await gesture.up();
    await tester.pump();
    expect(events, ['sound', 'navigate']);
  });
}
