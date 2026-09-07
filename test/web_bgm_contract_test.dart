import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('web BGM gate owns ON and OFF gestures without a global unlock', () {
    final app = File('lib/presentation/app.dart').readAsStringSync();
    final splash = File('lib/presentation/screens/splash_screen.dart')
        .readAsStringSync();
    final webEntry = File('web/index.html').readAsStringSync();

    expect(app, contains('if (!kIsWeb) GameBgm.unlock();'));
    expect(splash, contains('onPointerDown: (_) =>'));
    expect(splash, contains('GameBgm.startTitleFromGesture()'));
    expect(splash, contains('GameBgm.setEnabled(false)'));
    expect(splash, contains('Color(0xFF07152F)'));
    expect(webEntry, contains('1_Title_Lamplight%2520Grid.ogg'));
  });
}
