import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('settings parchment matches credits window spec', () {
    final settings = File('lib/presentation/widgets/settings_dialog.dart')
        .readAsStringSync();
    expect(settings, contains('shrinkContent: false'));
    expect(settings, contains('aspectRatio: 0.98'));
    expect(settings, contains('Alignment.topCenter'));
    expect(settings, contains('constraints.maxHeight * 0.12'));
    expect(settings, contains('PlayUi.titleStyle()'));
    expect(settings, contains('ParchmentModalButton('));
    expect(settings, isNot(contains('aspectRatio: 1.18')));
    expect(settings, isNot(contains('UI 편집')));
    expect(settings, contains('if (!kIsWeb)'));
    expect(settings, contains('settingsUserId'));
  });

  test('modal ovals use the intro compact stretch', () {
    final modal = File('lib/presentation/widgets/parchment_modal.dart')
        .readAsStringSync();
    expect(modal, contains('width: PlayUi.kOvalCompactWidth'));
    expect(modal, contains('expandToFitLabel: true'));
    expect(modal, contains('widthFactor: 1'));
    expect(modal, contains('ParchmentModalButtonRow'));
    expect(modal, contains('shrinkContent = false'));
    expect(modal, contains('OvalImageButton('));
    expect(modal, contains('_ParchmentNineSlice'));
    expect(modal, contains('heightFactor: hug ? 1 : null'));
    expect(modal, isNot(contains('centerSlice:')));
  });

  test('two-button modals size each oval to its label', () {
    for (final path in [
      'lib/presentation/widgets/exit_game_dialog.dart',
      'lib/presentation/widgets/give_up_puzzle_dialog.dart',
      'lib/presentation/widgets/completion_reward_dialog.dart',
      'lib/presentation/widgets/trial_end_dialog.dart',
    ]) {
      final src = File(path).readAsStringSync();
      expect(src, contains('ParchmentModalButtonRow('), reason: path);
      expect(src, isNot(contains('Expanded(')), reason: path);
    }
  });
}
