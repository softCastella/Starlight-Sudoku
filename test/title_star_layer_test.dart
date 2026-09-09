import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/presentation/widgets/parchment_button.dart';

void main() {
  test('title twinkling stars sit on the painting, not under it', () {
    final home = File('lib/presentation/screens/home_screen.dart')
        .readAsStringSync();
    final image = home.indexOf('Image.asset(');
    final titleAsset = home.indexOf('titleAsset,', image);
    final stars = home.indexOf(
      'const Positioned.fill(child: TwinklingStarField())',
    );
    expect(image, greaterThanOrEqualTo(0));
    expect(titleAsset, greaterThan(image));
    expect(stars, greaterThan(titleAsset));
  });

  test('title parchment cluster drops by three eighths of one button height', () {
    final home = File('lib/presentation/screens/home_screen.dart')
        .readAsStringSync();
    expect(home, contains('_titleButtonDrop'));
    expect(home, contains('visibleHeightFor(used) * 3 / 8'));
    expect(
      ParchmentButton.visibleHeightFor(208.86) * 3 / 8,
      closeTo(17.91, 0.05),
    );
  });
}
