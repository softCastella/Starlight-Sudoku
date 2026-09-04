import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/presentation/config/web_locale.dart';

void main() {
  test('landing lang query picks the game locale', () {
    expect(localeFromQuery(Uri.parse('https://example/Starlight-Sudoku/')), isNull);
    expect(
      localeFromQuery(Uri.parse('https://example/Starlight-Sudoku/?lang=ko')),
      const Locale('ko'),
    );
    expect(
      localeFromQuery(Uri.parse('https://example/Starlight-Sudoku/?lang=en')),
      const Locale('en'),
    );
    expect(
      localeFromQuery(Uri.parse('https://example/Starlight-Sudoku/?lang=ja')),
      const Locale('ja'),
    );
    expect(
      localeFromQuery(Uri.parse('https://example/Starlight-Sudoku/?lang=zh')),
      const Locale('zh'),
    );
    expect(
      localeFromQuery(Uri.parse('https://example/Starlight-Sudoku/?lang=zh-TW')),
      const Locale('zh', 'TW'),
    );
    expect(
      localeFromQuery(Uri.parse('https://example/Starlight-Sudoku/?lang=zh_TW')),
      const Locale('zh', 'TW'),
    );
    expect(
      localeFromQuery(Uri.parse('https://example/Starlight-Sudoku/#/?lang=en')),
      const Locale('en'),
    );
  });
}
