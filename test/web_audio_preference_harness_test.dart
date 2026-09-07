import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/presentation/notifiers/app_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('explicit SFX OFF wins over an in-flight preference load', () async {
    SharedPreferences.setMockInitialValues({
      'settings_bgm_on': false,
      'settings_sfx_on': true,
      'settings_user_id': 'SS-TEST',
    });
    final settings = AppSettings();
    addTearDown(() {
      AppSettings.sfxOn = true;
      settings.dispose();
    });

    final pendingLoad = settings.load();
    await settings.setSfxEnabled(false);
    await pendingLoad;

    expect(settings.sfxEnabled, isFalse);
    expect(AppSettings.sfxOn, isFalse);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('settings_sfx_on'), isFalse);
  });
}
