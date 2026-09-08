import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/presentation/audio/splash_voice.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('splash voice ogg is bundled', () async {
    expect(
      File('assets/audio/Voice/Tyche Spark Splash Voice.ogg').existsSync(),
      isTrue,
    );
    final data = await rootBundle.load(SplashVoice.bundlePath);
    expect(data.lengthInBytes, greaterThan(1000));
  });

  test('APK splash plays the ident once and does not retrigger on tap', () {
    final voice = File('lib/presentation/audio/splash_voice.dart')
        .readAsStringSync();
    final splash = File('lib/presentation/screens/splash_screen.dart')
        .readAsStringSync();

    expect(voice, contains('if (kIsWeb) return;'));
    expect(voice, contains('ReleaseMode.stop'));
    expect(voice, isNot(contains('ReleaseMode.loop')));
    expect(voice, isNot(contains('press(int pointer)')));
    expect(splash, contains('unawaited(SplashVoice.play())'));
    expect(splash, contains('AbsorbPointer('));
    expect(splash, isNot(contains('SplashVoice.press')));
    expect(splash, isNot(contains('SplashVoice.release')));
    expect(
      splash,
      isNot(contains('onPointerDown: (_) => unawaited(SplashVoice.play())')),
    );
  });
}
