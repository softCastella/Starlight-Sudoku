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
}
