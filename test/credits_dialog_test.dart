import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/presentation/widgets/credits_dialog.dart';

void main() {
  test('credits parchment stays readable and is not scaled down', () {
    final credits = File('lib/presentation/widgets/credits_dialog.dart')
        .readAsStringSync();
    expect(credits, contains('shrinkContent: false'));
    expect(credits, contains('aspectRatio: 0.98'));
    expect(credits, contains('Alignment.topCenter'));
    expect(credits, contains('TextAlign.left'));
    expect(credits, contains('TextAlign.center'));
    expect(credits, contains('PlayUi.bodyStyle(color: PlayUi.ink)'));
    expect(credits, contains('fontSize: PlayUi.body - 1'));
    expect(credits, contains('captionStyle()'));
    expect(credits, contains('height: 1.25'));
    expect(credits, isNot(contains('captionStyle().copyWith')));
    expect(credits, contains('constraints.maxHeight * 0.12'));
  });

  test('credits copy splits game name, left body, and copyright', () {
    const raw =
        '별빛 스도쿠\n\n개발  티케웍스 (Tyche Works)\n라인  티케스파크 (Tyche Spark)\n\nSplash Voice\nVREW - VOICEVOX: 小夜/SAYO\n\n© Tyche Spark. All rights reserved';
    final copy = CreditsCopy.parse(raw);
    expect(copy.gameName, '별빛 스도쿠');
    expect(copy.body, contains('개발  티케웍스'));
    expect(copy.body, contains('Splash Voice'));
    expect(copy.body, isNot(contains('©')));
    expect(copy.copyright, '© Tyche Spark. All rights reserved');
  });

  test('tune screen save and reset are labeled buttons', () {
    final screen = File('lib/presentation/screens/play_ui_tune_screen.dart')
        .readAsStringSync();
    expect(screen, contains("child: Text(_saved ? '저장됨' : '저장')"));
    expect(screen, contains("child: const Text('초기화')"));
    expect(screen, contains("label: '가져오기'"));
    expect(screen, contains('SelectableText('));
    expect(screen, contains('이 화면만'));
    expect(screen, contains('모든 화면'));
    expect(screen, isNot(contains("tooltip: 'JSON 복사'")));
  });
}
