import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/presentation/audio/game_bgm.dart';

/// Local audio prefs and an anonymous device id. Not an account.
class AppSettings extends ChangeNotifier {
  static const privacyPolicyUrl =
      'https://spark.tycheworks.com/starlight-sudoku/privacy/';

  static const _bgmKey = 'settings_bgm_on';
  static const _sfxKey = 'settings_sfx_on';
  static const _userIdKey = 'settings_user_id';

  /// Read by SFX helpers that have no [BuildContext].
  static bool sfxOn = true;

  bool _bgmOn = true;
  bool _sfxOn = true;
  String _userId = '';

  bool get bgmEnabled => _bgmOn;
  bool get sfxEnabled => _sfxOn;
  String get userId => _userId;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    _bgmOn = preferences.getBool(_bgmKey) ?? true;
    _sfxOn = preferences.getBool(_sfxKey) ?? true;
    sfxOn = _sfxOn;
    var id = preferences.getString(_userIdKey) ?? '';
    if (id.isEmpty) {
      id = _createUserId();
      await preferences.setString(_userIdKey, id);
    }
    _userId = id;
    await GameBgm.setEnabled(_bgmOn);
    notifyListeners();
  }

  Future<void> persistBgmEnabled(bool value) async {
    _bgmOn = value;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_bgmKey, value);
  }

  Future<void> setBgmEnabled(bool value) async {
    if (_bgmOn == value) return;
    _bgmOn = value;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_bgmKey, value);
    await GameBgm.setEnabled(value);
    notifyListeners();
  }

  Future<void> setSfxEnabled(bool value) async {
    if (_sfxOn == value) return;
    _sfxOn = value;
    sfxOn = value;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_sfxKey, value);
    notifyListeners();
  }

  static String _createUserId() {
    final random = Random.secure();
    final bytes = List<int>.generate(6, (_) => random.nextInt(256));
    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join()
        .toUpperCase();
    return 'SS-$hex';
  }
}
