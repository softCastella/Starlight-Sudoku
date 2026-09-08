import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune_persist.dart';

/// Live overrides for parchment / oval / type layout. Defaults match [PlayUi].
class PlayUiTune extends ChangeNotifier {
  PlayUiTune._();

  static final PlayUiTune instance = PlayUiTune._();

  static const schemaVersion = 3;
  static const editorPanelHeightFactor = 0.32;
  static const _prefsKey = 'play_ui_tune_v2';
  static const _legacyPrefsKey = 'play_ui_tune_v1';
  static const _uiTuner = bool.fromEnvironment('UI_TUNER');
  static const _storeBuild = bool.fromEnvironment('STORE_BUILD');
  static const localeIds = ['ko', 'en', 'ja', 'zh', 'zh_TW'];
  static const _buttonKeys = {
    'button',
    'buttonMaxWidth',
    'buttonMinWidth',
    'buttonHeightScale',
    'ovalEndFraction',
    'parchmentTextPad',
    'buttonTextOffsetX',
    'buttonTextOffsetY',
  };

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
  /// localeId → targetId → field → value. Button sizes live here.
  final Map<String, Map<String, Map<String, double>>> localeOverlays = {};

  bool panelOpen = false;
  /// When true, [PlayUi] getters follow [editingTarget]/[editingLocale]
  /// even inside LayoutBuilder after [PlayUi.using] has returned.
  bool previewReads = false;
  PlayUiTarget editingTarget = PlayUiTarget.common;
  String editingLocale = 'ko';
  final List<PlayUiTarget> _targetStack = [];
  Map<String, dynamic>? _checkpoint;
  int _epoch = 0;
  Future<void> _saveChain = Future<void>.value();

  static String localeIdFrom(Locale locale) {
    if (locale.languageCode == 'zh' && locale.countryCode == 'TW') {
      return 'zh_TW';
    }
    return locale.languageCode;
  }

  static Locale localeFromId(String id) {
    if (id == 'zh_TW') return const Locale('zh', 'TW');
    return Locale(id);
  }

  static String localeLabel(String id) => switch (id) {
        'ko' => '한',
        'en' => 'EN',
        'ja' => '日',
        'zh' => '简',
        'zh_TW' => '繁',
        _ => id,
      };

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
        'locales': {
          for (final localeEntry in localeOverlays.entries)
            if (localeEntry.value.values.any((fields) => fields.isNotEmpty))
              localeEntry.key: {
                for (final targetEntry in localeEntry.value.entries)
                  if (targetEntry.value.isNotEmpty)
                    targetEntry.key: Map<String, double>.from(targetEntry.value),
              },
        },
      };

  String get layoutJson =>
      '${const JsonEncoder.withIndent('  ').convert(toJsonObject())}\n';

  double commonOf(String key) => common[key] ?? defaults[key] ?? 0;

  double read(String key, PlayUiTarget target, {String? locale}) {
    _promoteOverlaysIntoLocales();
    final base = commonOf(key);
    final loc = locale ?? editingLocale;
    if (target == PlayUiTarget.common) {
      return localeOverlays[loc]?[target.id]?[key] ?? base;
    }
    return localeOverlays[loc]?[target.id]?[key] ?? base;
  }

  double editorValue(String key) =>
      read(key, editingTarget, locale: editingLocale);

  void setEditingTarget(PlayUiTarget target) {
    if (editingTarget == target) return;
    editingTarget = target;
    notifyListeners();
  }

  void pushTarget(PlayUiTarget target) {
    _targetStack.add(target);
    editingTarget = target;
    notifyListeners();
  }

  void popTarget(PlayUiTarget target) {
    for (var i = _targetStack.length - 1; i >= 0; i--) {
      if (_targetStack[i] == target) {
        _targetStack.removeAt(i);
        break;
      }
    }
    editingTarget =
        _targetStack.isEmpty ? PlayUiTarget.common : _targetStack.last;
    notifyListeners();
  }

  void resetEditorChrome() {
    _targetStack.clear();
    editingTarget = PlayUiTarget.common;
    editingLocale = 'ko';
    panelOpen = false;
    previewReads = false;
  }

  void setPreviewReads(bool value) {
    if (previewReads == value) return;
    previewReads = value;
    notifyListeners();
  }

  void setEditingLocale(String locale) {
    if (editingLocale == locale) return;
    editingLocale = locale;
    notifyListeners();
  }

  void setField(String key, double value) {
    _epoch++;
    _promoteOverlaysIntoLocales();
    final clamped = _clamp(key, value);
    if (editingTarget == PlayUiTarget.common && !_buttonKeys.contains(key)) {
      common[key] = clamped;
    } else {
      _writeLocaleField(editingLocale, editingTarget, key, clamped);
    }
    notifyListeners();
    unawaited(_save());
  }

  void _writeLocaleField(
    String locale,
    PlayUiTarget target,
    String key,
    double clamped,
  ) {
    final fallback = commonOf(key);
    final byLocale = Map<String, Map<String, double>>.from(
      localeOverlays[locale] ?? {},
    );
    final overlay = Map<String, double>.from(byLocale[target.id] ?? {});
    if ((clamped - fallback).abs() < 0.001) {
      overlay.remove(key);
    } else {
      overlay[key] = clamped;
    }
    if (overlay.isEmpty) {
      byLocale.remove(target.id);
    } else {
      byLocale[target.id] = overlay;
    }
    if (byLocale.isEmpty) {
      localeOverlays.remove(locale);
    } else {
      localeOverlays[locale] = byLocale;
    }
  }

  /// Factory-defaults the selected screen + language only.
  void resetCurrent() {
    _epoch++;
    _promoteOverlaysIntoLocales();
    final byLocale = Map<String, Map<String, double>>.from(
      localeOverlays[editingLocale] ?? {},
    );
    byLocale.remove(editingTarget.id);
    if (byLocale.isEmpty) {
      localeOverlays.remove(editingLocale);
    } else {
      localeOverlays[editingLocale] = byLocale;
    }
    if (editingTarget == PlayUiTarget.common) {
      common
        ..clear()
        ..addAll(defaults);
    }
    notifyListeners();
    unawaited(_save());
  }

  /// Puts the selected screen back to the last 저장 snapshot.
  void restoreCurrentFromCheckpoint() {
    _epoch++;
    _promoteOverlaysIntoLocales();
    final snapshot = _checkpoint;
    if (snapshot == null) {
      resetCurrent();
      return;
    }
    _clearCurrentLocaleTarget();
    _applySlice(snapshot, editingLocale, editingTarget);
    notifyListeners();
    unawaited(_save());
  }

  void _clearCurrentLocaleTarget() {
    final byLocale = Map<String, Map<String, double>>.from(
      localeOverlays[editingLocale] ?? {},
    );
    byLocale.remove(editingTarget.id);
    if (byLocale.isEmpty) {
      localeOverlays.remove(editingLocale);
    } else {
      localeOverlays[editingLocale] = byLocale;
    }
    if (editingTarget == PlayUiTarget.common) {
      common
        ..clear()
        ..addAll(defaults);
    }
  }

  void _applySlice(Map<String, dynamic> map, String locale, PlayUiTarget target) {
    Map<String, double>? fields;
    final locales = map['locales'];
    if (locales is Map<String, dynamic>) {
      final byTarget = locales[locale];
      if (byTarget is Map<String, dynamic>) {
        fields = _overlayFrom(byTarget[target.id]);
      }
    }
    fields ??= _overlayFrom(
      map['targets'] is Map<String, dynamic>
          ? (map['targets'] as Map<String, dynamic>)[target.id]
          : null,
    );
    if (fields.isEmpty) return;
    final byLocale = Map<String, Map<String, double>>.from(
      localeOverlays[locale] ?? {},
    );
    byLocale[target.id] = fields;
    localeOverlays[locale] = byLocale;
  }

  void _promoteOverlaysIntoLocales() {
    if (overlays.isEmpty) return;
    for (final locale in localeIds) {
      final byTarget = Map<String, Map<String, double>>.from(
        localeOverlays[locale] ?? {},
      );
      for (final entry in overlays.entries) {
        final merged = Map<String, double>.from(byTarget[entry.key] ?? {});
        for (final field in entry.value.entries) {
          merged.putIfAbsent(field.key, () => field.value);
        }
        if (merged.isNotEmpty) byTarget[entry.key] = merged;
      }
      if (byTarget.isNotEmpty) localeOverlays[locale] = byTarget;
    }
    overlays.clear();
  }

  Map<String, dynamic> _snapshot() =>
      jsonDecode(jsonEncode(toJsonObject())) as Map<String, dynamic>;

  Future<void> load() async {
    final epoch = _epoch;
    final preferences = await SharedPreferences.getInstance();
    if (_epoch != epoch) return;
    final raw = preferences.getString(_prefsKey) ??
        preferences.getString(_legacyPrefsKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return;
      if (_epoch != epoch) return;
      applyJson(decoded);
      _checkpoint = _snapshot();
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
      localeOverlays.clear();
      final targets = map['targets'];
      if (targets is Map<String, dynamic>) {
        for (final entry in targets.entries) {
          final parsed = PlayUiTarget.tryParse(entry.key);
          if (parsed == null) continue;
          final overlay = _overlayFrom(entry.value);
          if (overlay.isNotEmpty) overlays[parsed.id] = overlay;
        }
      }
      final locales = map['locales'];
      if (locales is Map<String, dynamic>) {
        for (final localeEntry in locales.entries) {
          if (!localeIds.contains(localeEntry.key)) continue;
          final value = localeEntry.value;
          if (value is! Map<String, dynamic>) continue;
          final byTarget = <String, Map<String, double>>{};
          for (final targetEntry in value.entries) {
            final parsed = PlayUiTarget.tryParse(targetEntry.key);
            if (parsed == null) continue;
            final overlay = _overlayFrom(targetEntry.value);
            if (overlay.isNotEmpty) byTarget[parsed.id] = overlay;
          }
          if (byTarget.isNotEmpty) localeOverlays[localeEntry.key] = byTarget;
        }
      }
      _promoteOverlaysIntoLocales();
      return;
    }
    overlays.clear();
    localeOverlays.clear();
    _applyCommon(map);
  }

  Map<String, double> _overlayFrom(Object? value) {
    if (value is! Map) return {};
    final overlay = <String, double>{};
    for (final field in value.entries) {
      final key = field.key.toString();
      if (field.value is num && defaults.containsKey(key)) {
        overlay[key] = _clamp(key, (field.value as num).toDouble());
      }
    }
    return overlay;
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
    _epoch++;
    common
      ..clear()
      ..addAll(defaults);
    overlays.clear();
    localeOverlays.clear();
    editingLocale = 'ko';
    _checkpoint = null;
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

  Future<void> saveNow() {
    _epoch++;
    _checkpoint = _snapshot();
    return _save();
  }

  Future<void> _save() {
    _saveChain = _saveChain.catchError((_) {}).then((_) => _writePrefs());
    return _saveChain;
  }

  Future<void> _writePrefs() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_prefsKey, jsonEncode(toJsonObject()));
    savePlayUiLayout(layoutJson);
  }
}
