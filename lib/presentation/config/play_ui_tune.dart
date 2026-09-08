import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune_persist.dart';

/// Live overrides for parchment / oval / type layout. Defaults match [PlayUi].
class PlayUiTune extends ChangeNotifier {
  PlayUiTune._();

  static final PlayUiTune instance = PlayUiTune._();

  static const schemaVersion = 3;
  static const _prefsKey = 'play_ui_tune_v2';
  static const _legacyPrefsKey = 'play_ui_tune_v1';
  static const _uiTuner = bool.fromEnvironment('UI_TUNER');
  static const _storeBuild = bool.fromEnvironment('STORE_BUILD');

  /// Play AAB (`STORE_BUILD`) and public web (`WEB_DEMO` without `UI_TUNER`) hide this.
  static bool get isEditorEnabled {
    if (_storeBuild) return false;
    if (kIsWeb) return _uiTuner;
    return true;
  }

  static const Map<String, double> defaults = {
    'caption': PlayUi.kCaption,
    'body': PlayUi.kBody,
    'label': PlayUi.kLabel,
    'button': PlayUi.kButton,
    'title': PlayUi.kTitle,
    'modalInset': PlayUi.kModalInset,
    'modalInsetY': PlayUi.kModalInsetY,
    'modalPadX': PlayUi.kModalPadX,
    'modalPadY': PlayUi.kModalPadY,
    'modalMinWidth': PlayUi.kModalMinWidth,
    'modalMaxWidth': PlayUi.kModalMaxWidth,
    'modalOffsetX': PlayUi.kModalOffsetX,
    'modalOffsetY': PlayUi.kModalOffsetY,
    'rowGap': PlayUi.kRowGap,
    'buttonMaxWidth': PlayUi.kButtonMaxWidth,
    'buttonMinWidth': PlayUi.kButtonMinWidth,
    'ovalEndFraction': PlayUi.kOvalEndFraction,
    'screenPad': PlayUi.kScreenPad,
    'buttonTextOffsetX': PlayUi.kButtonTextOffsetX,
    'buttonTextOffsetY': PlayUi.kButtonTextOffsetY,
    'parchmentTextPad': PlayUi.kParchmentTextPad,
    'buttonHeightScale': 1.0,
    'titleLineHeight': 1.2,
    'bodyLineHeight': 1.4,
    'overlayOpacity': 0.0,
  };

  final Map<String, double> common = Map<String, double>.from(defaults);
  final Map<String, Map<String, double>> overlays = {};

  bool panelOpen = false;
  PlayUiTarget editingTarget = PlayUiTarget.common;

  double get caption => common['caption']!;
  set caption(double v) => common['caption'] = v;
  double get body => common['body']!;
  set body(double v) => common['body'] = v;
  double get label => common['label']!;
  set label(double v) => common['label'] = v;
  double get button => common['button']!;
  set button(double v) => common['button'] = v;
  double get title => common['title']!;
  set title(double v) => common['title'] = v;
  double get modalInset => common['modalInset']!;
  set modalInset(double v) => common['modalInset'] = v;
  double get modalInsetY => common['modalInsetY']!;
  set modalInsetY(double v) => common['modalInsetY'] = v;
  double get modalPadX => common['modalPadX']!;
  set modalPadX(double v) => common['modalPadX'] = v;
  double get modalPadY => common['modalPadY']!;
  set modalPadY(double v) => common['modalPadY'] = v;
  double get modalMinWidth => common['modalMinWidth']!;
  set modalMinWidth(double v) => common['modalMinWidth'] = v;
  double get modalMaxWidth => common['modalMaxWidth']!;
  set modalMaxWidth(double v) => common['modalMaxWidth'] = v;
  double get modalOffsetX => common['modalOffsetX']!;
  set modalOffsetX(double v) => common['modalOffsetX'] = v;
  double get modalOffsetY => common['modalOffsetY']!;
  set modalOffsetY(double v) => common['modalOffsetY'] = v;
  double get rowGap => common['rowGap']!;
  set rowGap(double v) => common['rowGap'] = v;
  double get buttonMaxWidth => common['buttonMaxWidth']!;
  set buttonMaxWidth(double v) => common['buttonMaxWidth'] = v;
  double get buttonMinWidth => common['buttonMinWidth']!;
  set buttonMinWidth(double v) => common['buttonMinWidth'] = v;
  double get ovalEndFraction => common['ovalEndFraction']!;
  set ovalEndFraction(double v) => common['ovalEndFraction'] = v;
  double get screenPad => common['screenPad']!;
  set screenPad(double v) => common['screenPad'] = v;
  double get buttonTextOffsetX => common['buttonTextOffsetX']!;
  set buttonTextOffsetX(double v) => common['buttonTextOffsetX'] = v;
  double get buttonTextOffsetY => common['buttonTextOffsetY']!;
  set buttonTextOffsetY(double v) => common['buttonTextOffsetY'] = v;
  double get parchmentTextPad => common['parchmentTextPad']!;
  set parchmentTextPad(double v) => common['parchmentTextPad'] = v;
  double get buttonHeightScale => common['buttonHeightScale']!;
  set buttonHeightScale(double v) => common['buttonHeightScale'] = v;
  double get titleLineHeight => common['titleLineHeight']!;
  set titleLineHeight(double v) => common['titleLineHeight'] = v;
  double get bodyLineHeight => common['bodyLineHeight']!;
  set bodyLineHeight(double v) => common['bodyLineHeight'] = v;
  double get overlayOpacity => common['overlayOpacity']!;
  set overlayOpacity(double v) => common['overlayOpacity'] = v;

  Map<String, double> toMap() => Map<String, double>.from(common);

  Map<String, Object> toJsonObject() => {
        'schema': schemaVersion,
        'common': toMap(),
        'targets': {
          for (final entry in overlays.entries)
            if (entry.value.isNotEmpty) entry.key: Map<String, double>.from(entry.value),
        },
      };

  String get layoutJson =>
      '${const JsonEncoder.withIndent('  ').convert(toJsonObject())}\n';

  double commonOf(String key) => common[key] ?? defaults[key] ?? 0;

  double read(String key, PlayUiTarget target) {
    final base = commonOf(key);
    if (target == PlayUiTarget.common) return base;
    return overlays[target.id]?[key] ?? base;
  }

  double editorValue(String key) => read(key, editingTarget);

  void setEditingTarget(PlayUiTarget target) {
    if (editingTarget == target) return;
    editingTarget = target;
    notifyListeners();
  }

  void setField(String key, double value) {
    final clamped = _clamp(key, value);
    if (editingTarget == PlayUiTarget.common) {
      common[key] = clamped;
    } else {
      final overlay = Map<String, double>.from(overlays[editingTarget.id] ?? {});
      if ((clamped - commonOf(key)).abs() < 0.001) {
        overlay.remove(key);
      } else {
        overlay[key] = clamped;
      }
      if (overlay.isEmpty) {
        overlays.remove(editingTarget.id);
      } else {
        overlays[editingTarget.id] = overlay;
      }
    }
    notifyListeners();
    unawaited(_save());
  }

  void resetCurrent() {
    if (editingTarget == PlayUiTarget.common) {
      common
        ..clear()
        ..addAll(defaults);
    } else {
      overlays.remove(editingTarget.id);
    }
    notifyListeners();
    unawaited(_save());
  }

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_prefsKey) ??
        preferences.getString(_legacyPrefsKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return;
      applyJson(decoded);
      notifyListeners();
    } catch (_) {}
  }

  bool importJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return false;
      applyJson(decoded);
      notifyListeners();
      unawaited(_save());
      return true;
    } catch (_) {
      return false;
    }
  }

  void applyJson(Map<String, dynamic> map) {
    final schema = map['schema'];
    if (schema is num && schema.toInt() >= 2) {
      final commonMap = map['common'];
      if (commonMap is Map<String, dynamic>) {
        _applyCommon(commonMap);
      }
      overlays.clear();
      final targets = map['targets'];
      if (targets is Map<String, dynamic>) {
        for (final entry in targets.entries) {
          if (PlayUiTarget.tryParse(entry.key) == null) continue;
          final value = entry.value;
          if (value is! Map<String, dynamic>) continue;
          final overlay = <String, double>{};
          for (final field in value.entries) {
            if (field.value is num && defaults.containsKey(field.key)) {
              overlay[field.key] = _clamp(field.key, (field.value as num).toDouble());
            }
          }
          if (overlay.isNotEmpty) overlays[entry.key] = overlay;
        }
      }
      return;
    }
    overlays.clear();
    _applyCommon(map);
  }

  void setPanelOpen(bool value) {
    if (panelOpen == value) return;
    panelOpen = value;
    notifyListeners();
  }

  void update(void Function(PlayUiTune tune) change) {
    change(this);
    _clampCommonInPlace();
    notifyListeners();
    unawaited(_save());
  }

  void reset() {
    common
      ..clear()
      ..addAll(defaults);
    overlays.clear();
    notifyListeners();
    unawaited(_save());
  }

  void _applyCommon(Map<String, dynamic> map) {
    double readNum(String key, double fallback) {
      final value = map[key];
      if (value is num) return _clamp(key, value.toDouble());
      return fallback;
    }

    for (final key in defaults.keys) {
      common[key] = readNum(key, commonOf(key));
    }
  }

  void _clampCommonInPlace() {
    for (final key in defaults.keys) {
      common[key] = _clamp(key, commonOf(key));
    }
  }

  double _clamp(String key, double value) {
    return switch (key) {
      'caption' => value.clamp(PlayUi.minType, 18),
      'body' => value.clamp(PlayUi.minType, 20),
      'label' => value.clamp(PlayUi.minType, 22),
      'button' => value.clamp(PlayUi.minType, 22),
      'title' => value.clamp(PlayUi.minType, 28),
      'modalInset' => value.clamp(8, 48),
      'modalInsetY' => value.clamp(8, 72),
      'modalPadX' => value.clamp(16, 72),
      'modalPadY' => value.clamp(16, 72),
      'modalMinWidth' => value.clamp(240, 360),
      'modalMaxWidth' => value.clamp(320, 520),
      'modalOffsetX' => value.clamp(-48, 48),
      'modalOffsetY' => value.clamp(-48, 48),
      'rowGap' => value.clamp(4, 20),
      'buttonMaxWidth' => value.clamp(96, 280),
      'buttonMinWidth' => value.clamp(72, 180),
      'ovalEndFraction' => value.clamp(0.10, 0.28),
      'screenPad' => value.clamp(8, 36),
      'buttonTextOffsetX' => value.clamp(-24, 24),
      'buttonTextOffsetY' => value.clamp(-24, 24),
      'parchmentTextPad' => value.clamp(16, 64),
      'buttonHeightScale' => value.clamp(0.7, 1.4),
      'titleLineHeight' => value.clamp(1.0, 1.6),
      'bodyLineHeight' => value.clamp(1.1, 1.8),
      'overlayOpacity' => value.clamp(0.0, 0.45),
      _ => value,
    };
  }

  Future<void> saveNow() => _save();

  Future<void> _save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_prefsKey, jsonEncode(toJsonObject()));
    savePlayUiLayout(layoutJson);
  }
}
