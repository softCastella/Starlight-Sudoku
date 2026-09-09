import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('opening card keeps even padding and compact next', () {
    final src = File('lib/presentation/screens/opening_story_screen.dart')
        .readAsStringSync();
    expect(src, contains('padding: EdgeInsets.all(PlayUi.screenPad)'));
    expect(src, contains('width: PlayUi.kOvalCompactWidth'));
    expect(src, contains('expandToFitLabel: true'));
    expect(src, contains('const Spacer()'));
    expect(src, isNot(contains('isLast ? 148')));
    expect(src, isNot(contains('isLast ? null')));
  });

  test('village mission uses intro compact oval', () {
    final src = File('lib/presentation/screens/village_screen.dart')
        .readAsStringSync();
    expect(src, contains('width: PlayUi.kOvalCompactWidth'));
    expect(src, contains('expandToFitLabel: true'));
  });
}
