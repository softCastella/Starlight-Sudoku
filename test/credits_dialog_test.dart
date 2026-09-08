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

  test('tune screen save and reset are labeled buttons', () {
    final screen = File('lib/presentation/screens/play_ui_tune_screen.dart')
        .readAsStringSync();
    expect(screen, contains("child: Text(_saved ? '저장됨' : '저장')"));
    expect(screen, contains("child: const Text('초기화')"));
    expect(screen, contains('SelectableText('));
    expect(screen, contains('이 화면만'));
    expect(screen, contains('모든 화면'));
    expect(screen, isNot(contains("tooltip: 'JSON 복사'")));
  });
}
