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
    PlayUiTune.instance.setEditingTarget(PlayUiTarget.common);
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
    expect(tune.toJsonObject()['schema'], 2);
  });
}
