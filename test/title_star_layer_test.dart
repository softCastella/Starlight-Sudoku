import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

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
}
