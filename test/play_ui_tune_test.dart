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
    PlayUiTune.instance.setEditingTarget(PlayUiTarget.common);
    PlayUiTune.instance.setEditingLocale('ko');
  });

  test('PlayUiTune keeps position tokens and default pads', () {
    final tune = PlayUiTune.instance;
    final map = tune.toMap();
    expect(map['modalPadX'], PlayUi.kModalPadX);
    expect(map['modalPadY'], PlayUi.kModalPadY);
    expect(map['modalOffsetX'], 0);
    expect(map['modalOffsetY'], 0);
    expect(map['buttonTextOffsetX'], 0);
    expect(map['buttonTextOffsetY'], 0);
    expect(map['modalInsetY'], PlayUi.kModalInsetY);
    expect(PlayUi.modalPadX, PlayUi.kModalPadX);
  });

  test('target overlay does not leak into another modal', () {
    final tune = PlayUiTune.instance;
    tune.setEditingTarget(PlayUiTarget.giveUp);
    tune.setField('title', 22);
    expect(tune.read('title', PlayUiTarget.giveUp), 22);
    expect(tune.read('title', PlayUiTarget.settings), PlayUi.kTitle);
    expect(
      PlayUi.using(PlayUiTarget.settings, () => PlayUi.title),
      PlayUi.kTitle,
    );
    expect(
      PlayUi.using(PlayUiTarget.giveUp, () => PlayUi.title),
      22,
    );
  });

  test('schema v1 json migrates into common', () {
    final tune = PlayUiTune.instance;
    expect(
      tune.importJson('{"title": 20, "modalPadX": 48}'),
      isTrue,
    );
    expect(tune.commonOf('title'), 20);
    expect(tune.commonOf('modalPadX'), 48);
    expect(tune.toJsonObject()['schema'], 3);
  });

  test('button overlay is per screen and per language', () {
    final tune = PlayUiTune.instance;
    tune.setEditingLocale('en');
    tune.setEditingTarget(PlayUiTarget.titleButton);
    tune.setField('buttonMaxWidth', 160);
    expect(tune.read('buttonMaxWidth', PlayUiTarget.titleButton, locale: 'en'), 160);
    expect(
      tune.read('buttonMaxWidth', PlayUiTarget.titleButton, locale: 'ko'),
      PlayUi.kButtonMaxWidth,
    );
    expect(
      tune.read('buttonMaxWidth', PlayUiTarget.villageButton, locale: 'en'),
      PlayUi.kButtonMaxWidth,
    );

    tune.setEditingLocale('ko');
    tune.setEditingTarget(PlayUiTarget.common);
    tune.setField('buttonMaxWidth', 180);
    expect(
      tune.read('buttonMaxWidth', PlayUiTarget.titleButton, locale: 'ko'),
      PlayUi.kButtonMaxWidth,
    );
  });

  test('previewReads follows the selected screen without using()', () {
    final tune = PlayUiTune.instance;
    tune.setEditingTarget(PlayUiTarget.giveUp);
    tune.setField('title', 22);
    tune.setPreviewReads(true);
    expect(PlayUi.title, 22);
    expect(PlayUi.using(PlayUiTarget.settings, () => PlayUi.title), 22);
    tune.setPreviewReads(false);
    expect(PlayUi.title, PlayUi.kTitle);
    expect(PlayUi.using(PlayUiTarget.giveUp, () => PlayUi.title), 22);
  });

  test('resetting one screen keeps the others', () {
    final tune = PlayUiTune.instance;
    tune.setEditingLocale('ko');
    tune.setEditingTarget(PlayUiTarget.titleButton);
    tune.setField('buttonMaxWidth', 160);
    tune.setEditingTarget(PlayUiTarget.giveUp);
    tune.setField('title', 22);
    tune.resetCurrent();
    expect(tune.read('title', PlayUiTarget.giveUp), PlayUi.kTitle);
    expect(
      tune.read('buttonMaxWidth', PlayUiTarget.titleButton, locale: 'ko'),
      160,
    );
  });

  test('save checkpoint restores only the current screen', () async {
    final tune = PlayUiTune.instance;
    tune.setEditingTarget(PlayUiTarget.titleButton);
    tune.setField('buttonMaxWidth', 160);
    await tune.saveNow();
    tune.setField('buttonMaxWidth', 240);
    tune.setEditingTarget(PlayUiTarget.giveUp);
    tune.setField('title', 26);
    tune.setEditingTarget(PlayUiTarget.titleButton);
    tune.restoreCurrentFromCheckpoint();
    expect(tune.read('buttonMaxWidth', PlayUiTarget.titleButton), 160);
    expect(tune.read('title', PlayUiTarget.giveUp), 26);
  });

  test('schema 3 json applies to app and web common tokens', () {
    final tune = PlayUiTune.instance;
    expect(
      tune.importJson(
        '{"schema":3,"common":{"caption":11.0,"body":13.0,"label":14.0,'
        '"button":15.0,"title":18.0,"modalInset":24.0,"modalInsetY":24.0,'
        '"modalPadX":40.0,"modalPadY":40.0,"modalMinWidth":280.0,'
        '"modalMaxWidth":420.0,"modalOffsetX":0.0,"modalOffsetY":0.0,'
        '"rowGap":8.0,"buttonMaxWidth":200.0,"buttonMinWidth":112.0,'
        '"ovalEndFraction":0.19,"screenPad":20.0,"buttonTextOffsetX":0.0,'
        '"buttonTextOffsetY":0.0,"parchmentTextPad":36.0},'
        '"targets":{}}',
      ),
      isTrue,
    );
    expect(tune.commonOf('buttonTextOffsetX'), 0);
    expect(PlayUi.button, 15);
  });
}
