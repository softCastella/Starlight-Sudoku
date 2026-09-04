import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('short label keeps 15px and stays under the cap', () {
    final layout = OvalButtonLayout.forLabel(
      '닫기',
      direction: TextDirection.ltr,
    );
    expect(layout.fontSize, PlayUi.button);
    expect(layout.width, greaterThanOrEqualTo(PlayUi.buttonMinWidth));
    expect(layout.width, lessThanOrEqualTo(PlayUi.buttonMaxWidth));
    expect(layout.height, layout.width / PlayUi.ovalAspect);
    expect(layout.sideInset, closeTo(layout.width * PlayUi.ovalEndFraction, 0.01));
  });

  test('long label hits the cap then shrinks no lower than 11', () {
    final layout = OvalButtonLayout.forLabel(
      'Keep playing forever and ever',
      direction: TextDirection.ltr,
      maxWidth: 140,
    );
    expect(layout.width, 140);
    expect(layout.fontSize, greaterThanOrEqualTo(PlayUi.minType));
    expect(layout.fontSize, lessThanOrEqualTo(PlayUi.button));
  });

  test('parent narrower than min width does not overflow it', () {
    final layout = OvalButtonLayout.forLabel(
      'Next',
      direction: TextDirection.ltr,
      maxWidth: 80,
    );
    expect(layout.width, lessThanOrEqualTo(80));
    expect(layout.fontSize, greaterThanOrEqualTo(PlayUi.minType));
  });
}
