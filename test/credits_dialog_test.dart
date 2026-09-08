import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('credits parchment stays readable and is not scaled down', () {
    final credits = File('lib/presentation/widgets/credits_dialog.dart')
        .readAsStringSync();
    expect(credits, contains('shrinkContent: false'));
    expect(credits, contains('aspectRatio: 0.92'));
    expect(credits, contains('PlayUi.bodyStyle'));
    expect(credits, isNot(contains('captionStyle()')));
  });

  test('tuner panel save and reset are labeled buttons', () {
    final panel = File('lib/presentation/widgets/play_ui_tuner_panel.dart')
        .readAsStringSync();
    expect(panel, contains("child: const Text('저장')"));
    expect(panel, contains("child: const Text('초기화')"));
    expect(panel, contains('SelectableText('));
    expect(panel, contains('초기화할까요?'));
    expect(panel, isNot(contains("tooltip: 'JSON 복사'")));
  });
}
