import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/presentation/config/title_art.dart';

void main() {
  test('title painting follows the phone language', () {
    expect(TitleArt.assetFor(const Locale('ko')), TitleArt.korean);
    expect(TitleArt.assetFor(const Locale('en')), TitleArt.english);
    expect(TitleArt.assetFor(const Locale('ja')), TitleArt.japanese);
    expect(TitleArt.assetFor(const Locale('zh')), TitleArt.chineseSimplified);
    expect(
      TitleArt.assetFor(const Locale('zh', 'CN')),
      TitleArt.chineseSimplified,
    );
    expect(
      TitleArt.assetFor(const Locale('zh', 'TW')),
      TitleArt.chineseTraditional,
    );
    expect(TitleArt.assetFor(const Locale('fr')), TitleArt.fallback);
  });
}
