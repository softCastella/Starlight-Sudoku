import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('PlayUiTune keeps position tokens and default pads', () {
    final tune = PlayUiTune.instance;
    tune.reset();
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
}
