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
  int _bgmSelectionRevision = 0;
  int _sfxSelectionRevision = 0;

  bool get bgmEnabled => _bgmOn;
  bool get sfxEnabled => _sfxOn;
  String get userId => _userId;

  Future<void> load() async {
    final bgmRevision = _bgmSelectionRevision;
    final sfxRevision = _sfxSelectionRevision;
    final preferences = await SharedPreferences.getInstance();
    final storedBgmOn = preferences.getBool(_bgmKey) ?? true;
    final storedSfxOn = preferences.getBool(_sfxKey) ?? true;
    var id = preferences.getString(_userIdKey) ?? '';
    // Web is one-shot: do not create or keep an anonymous device id.
    if (!kIsWeb) {
      if (id.isEmpty) {
        id = _createUserId();
        await preferences.setString(_userIdKey, id);
      }
      _userId = id;
    } else {
      _userId = '';
    }
    if (!kIsWeb) {
      if (_bgmSelectionRevision == bgmRevision) {
        _bgmOn = storedBgmOn;
        await GameBgm.setEnabled(_bgmOn);
      }
      if (_sfxSelectionRevision == sfxRevision) {
        _sfxOn = storedSfxOn;
        sfxOn = _sfxOn;
      }
    }
    // Web: keep both ON until the gate writes an explicit choice. A previous
    // BGM OFF session stored SFX off; importing that would show 효과음 off
    // after the user just pressed BGM ON.
    notifyListeners();
  }

  /// Web gate: BGM ON → BGM+SFX on. BGM OFF → both off. Writes memory first.
  Future<void> applyWebGateAudio({required bool enabled}) async {
    _bgmSelectionRevision++;
    _sfxSelectionRevision++;
    _bgmOn = enabled;
    _sfxOn = enabled;
    sfxOn = enabled;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_bgmKey, enabled);
    await preferences.setBool(_sfxKey, enabled);
  }

  Future<void> persistBgmEnabled(bool value) async {
    _bgmSelectionRevision++;
    _bgmOn = value;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_bgmKey, value);
  }

  /// Gate / settings write SFX immediately so a late [load] cannot undo it.
  Future<void> persistSfxEnabled(bool value) async {
    _sfxSelectionRevision++;
    _sfxOn = value;
    sfxOn = value;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_sfxKey, value);
  }

  Future<void> setBgmEnabled(bool value) async {
    if (_bgmOn == value) return;
    _bgmSelectionRevision++;
    _bgmOn = value;
    final webAudioChange = kIsWeb
        ? GameBgm.setEnabledFromGesture(value)
        : Future<void>.value();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_bgmKey, value);
    if (kIsWeb) {
      await webAudioChange;
    } else {
      await GameBgm.setEnabled(value);
    }
    notifyListeners();
  }

  Future<void> setSfxEnabled(bool value) async {
    if (_sfxOn == value) return;
    _sfxSelectionRevision++;
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
