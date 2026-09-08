import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PlayUiTune.instance.reset();
    PlayUiTune.instance.resetEditorChrome();
    PlayUiTune.instance.setEditingTarget(PlayUiTarget.openingButton);
    PlayUiTune.instance.setEditingLocale('en');
  });

  test('short label keeps 15px and uses the width slider', () {
    final layout = OvalButtonLayout.forLabel(
      '닫기',
      direction: TextDirection.ltr,
    );
    expect(layout.fontSize, PlayUi.button);
    expect(layout.width, PlayUi.buttonMaxWidth);
    expect(layout.height, layout.width / PlayUi.ovalAspect * PlayUi.buttonHeightScale);
    expect(layout.sideInset, closeTo(layout.width * PlayUi.ovalEndFraction, 0.01));
  });

  test('width slider sets oval width for a short label', () {
    final layout = OvalButtonLayout.forLabel(
      '닫기',
      direction: TextDirection.ltr,
      maxWidth: 180,
    );
    expect(layout.width, 180);
  });

  test('raising the font does not grow the oval', () {
    const label = '닫기';
    final small = OvalButtonLayout.forLabel(
      label,
      direction: TextDirection.ltr,
      preferredFontSize: 11,
    );
    final large = OvalButtonLayout.forLabel(
      label,
      direction: TextDirection.ltr,
      preferredFontSize: 22,
    );
    expect(large.width, small.width);
    expect(large.height, small.height);
    expect(large.fontSize, 22);
    expect(small.fontSize, 11);
  });

  test('long English keeps the font slider, not the oval-end inset', () {
    const label = 'Light the first window';
    final small = OvalButtonLayout.forLabel(
      label,
      direction: TextDirection.ltr,
      preferredFontSize: 11,
    );
    final large = OvalButtonLayout.forLabel(
      label,
      direction: TextDirection.ltr,
      preferredFontSize: 22,
    );
    expect(large.width, small.width);
    expect(small.fontSize, 11);
    expect(large.fontSize, 22);
  });

  test('oval end fraction does not change English font size', () {
    final tune = PlayUiTune.instance;
    tune.setField('button', 22);
    late double insetLoose;
    late double insetTight;
    late double fontLoose;
    late double fontTight;
    PlayUi.using(PlayUiTarget.openingButton, () {
      tune.setField('ovalEndFraction', 0.10);
      final loose = OvalButtonLayout.forLabel(
        'Light the first window',
        direction: TextDirection.ltr,
        preferredFontSize: PlayUi.button,
      );
      insetLoose = loose.sideInset;
      fontLoose = loose.fontSize;
      tune.setField('ovalEndFraction', 0.28);
      final tight = OvalButtonLayout.forLabel(
        'Light the first window',
        direction: TextDirection.ltr,
        preferredFontSize: PlayUi.button,
      );
      insetTight = tight.sideInset;
      fontTight = tight.fontSize;
    }, locale: const Locale('en'));
    expect(fontLoose, 22);
    expect(fontTight, 22);
    expect(insetTight, greaterThan(insetLoose));
  });

  test('parent narrower than min width does not overflow it', () {
    final layout = OvalButtonLayout.forLabel(
      'Next',
      direction: TextDirection.ltr,
      maxWidth: 80,
    );
    expect(layout.width, 80);
    expect(layout.fontSize, PlayUi.button);
  });
}
