import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('standalone landing keeps the requested copy and CTA contract', () {
    final source = File('web/landing/index.html').readAsStringSync();
    final flutterBootstrap = File('web/index.html').readAsStringSync();

    expect(source, contains('멈춰버린 밤에'));
    expect(source, contains('아침을 불러오세요.'));
    expect(source, contains('지금 플레이해 보세요'));
    expect(source, contains('href="../?lang=ko"'));
    expect(source, contains('navigator.language'));
    expect(source, contains('sessionStorage.setItem("starlight_lang"'));
    expect(source, contains('../?lang='));
    expect(source, contains('--cta-lift: calc(var(--cta-height) / 2)'));
    expect(source, contains('@media (prefers-reduced-motion: reduce)'));
    expect(source, contains('Title_Image_Starlight%2520Sdoku%2520KR.png'));
    expect(source, contains('Title_Image_Starlight%2520Sdoku%2520EN.png'));
    expect(source, contains('Title_Image_Starlight%2520Sdoku%2520JP.png'));
    expect(source, contains('Title_Image_Starlight%2520Sdoku%2520CN.png'));
    expect(source, contains('Title_Image_Starlight%2520Sdoku%2520TW.png'));
    expect(source, isNot(contains('googleads')));
    expect(source, isNot(contains('doubleclick')));
    expect(flutterBootstrap, contains('flutter_bootstrap.js'));
    expect(flutterBootstrap, contains("sessionStorage.setItem('starlight_lang'"));
    expect(flutterBootstrap, contains('background: #0E2040'));
    expect(flutterBootstrap, isNot(contains('background: #ffffff')));
    expect(flutterBootstrap, isNot(contains('멈춰버린 밤에')));
  });
}
