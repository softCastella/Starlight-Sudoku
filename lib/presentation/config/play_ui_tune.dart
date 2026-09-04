import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune_persist.dart';

/// Live overrides for parchment / oval / type layout. Defaults match [PlayUi].
class PlayUiTune extends ChangeNotifier {
  PlayUiTune._();

  static final PlayUiTune instance = PlayUiTune._();

  static const _prefsKey = 'play_ui_tune_v1';

  bool panelOpen = false;

  double caption = PlayUi.kCaption;
  double body = PlayUi.kBody;
  double label = PlayUi.kLabel;
  double button = PlayUi.kButton;
  double title = PlayUi.kTitle;

  double modalInset = PlayUi.kModalInset;
  double modalInsetY = PlayUi.kModalInsetY;
  double modalPadX = PlayUi.kModalPadX;
  double modalPadY = PlayUi.kModalPadY;
  double modalMinWidth = PlayUi.kModalMinWidth;
  double modalMaxWidth = PlayUi.kModalMaxWidth;
  double modalOffsetX = PlayUi.kModalOffsetX;
  double modalOffsetY = PlayUi.kModalOffsetY;

  double rowGap = PlayUi.kRowGap;
  double buttonMaxWidth = PlayUi.kButtonMaxWidth;
  double buttonMinWidth = PlayUi.kButtonMinWidth;
  double ovalEndFraction = PlayUi.kOvalEndFraction;
  double screenPad = PlayUi.kScreenPad;
  double buttonTextOffsetX = PlayUi.kButtonTextOffsetX;
  double buttonTextOffsetY = PlayUi.kButtonTextOffsetY;
  double parchmentTextPad = PlayUi.kParchmentTextPad;

  Map<String, double> toMap() => {
        'caption': caption,
        'body': body,
        'label': label,
        'button': button,
        'title': title,
        'modalInset': modalInset,
        'modalInsetY': modalInsetY,
        'modalPadX': modalPadX,
        'modalPadY': modalPadY,
        'modalMinWidth': modalMinWidth,
        'modalMaxWidth': modalMaxWidth,
        'modalOffsetX': modalOffsetX,
        'modalOffsetY': modalOffsetY,
        'rowGap': rowGap,
        'buttonMaxWidth': buttonMaxWidth,
        'buttonMinWidth': buttonMinWidth,
        'ovalEndFraction': ovalEndFraction,
        'screenPad': screenPad,
        'buttonTextOffsetX': buttonTextOffsetX,
        'buttonTextOffsetY': buttonTextOffsetY,
        'parchmentTextPad': parchmentTextPad,
      };

  String get layoutJson =>
      '${const JsonEncoder.withIndent('  ').convert(toMap())}\n';

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _applyMap(map);
      notifyListeners();
    } catch (_) {}
  }

  void setPanelOpen(bool value) {
    if (panelOpen == value) return;
    panelOpen = value;
    notifyListeners();
  }

  void update(void Function(PlayUiTune tune) change) {
    change(this);
    caption = caption.clamp(PlayUi.minType, 18);
    body = body.clamp(PlayUi.minType, 20);
    label = label.clamp(PlayUi.minType, 22);
    button = button.clamp(PlayUi.minType, 22);
    title = title.clamp(PlayUi.minType, 28);
    notifyListeners();
    unawaited(_save());
  }

  void reset() {
    caption = PlayUi.kCaption;
    body = PlayUi.kBody;
    label = PlayUi.kLabel;
    button = PlayUi.kButton;
    title = PlayUi.kTitle;
    modalInset = PlayUi.kModalInset;
    modalInsetY = PlayUi.kModalInsetY;
    modalPadX = PlayUi.kModalPadX;
    modalPadY = PlayUi.kModalPadY;
    modalMinWidth = PlayUi.kModalMinWidth;
    modalMaxWidth = PlayUi.kModalMaxWidth;
    modalOffsetX = PlayUi.kModalOffsetX;
    modalOffsetY = PlayUi.kModalOffsetY;
    rowGap = PlayUi.kRowGap;
    buttonMaxWidth = PlayUi.kButtonMaxWidth;
    buttonMinWidth = PlayUi.kButtonMinWidth;
    ovalEndFraction = PlayUi.kOvalEndFraction;
    screenPad = PlayUi.kScreenPad;
    buttonTextOffsetX = PlayUi.kButtonTextOffsetX;
    buttonTextOffsetY = PlayUi.kButtonTextOffsetY;
    parchmentTextPad = PlayUi.kParchmentTextPad;
    notifyListeners();
    unawaited(_save());
  }

  void _applyMap(Map<String, dynamic> map) {
    double read(String key, double fallback) {
      final value = map[key];
      if (value is num) return value.toDouble();
      return fallback;
    }

    caption = read('caption', caption);
    body = read('body', body);
    label = read('label', label);
    button = read('button', button);
    title = read('title', title);
    modalInset = read('modalInset', modalInset);
    modalInsetY = read('modalInsetY', modalInsetY);
    modalPadX = read('modalPadX', modalPadX);
    modalPadY = read('modalPadY', modalPadY);
    modalMinWidth = read('modalMinWidth', modalMinWidth);
    modalMaxWidth = read('modalMaxWidth', modalMaxWidth);
    modalOffsetX = read('modalOffsetX', modalOffsetX);
    modalOffsetY = read('modalOffsetY', modalOffsetY);
    rowGap = read('rowGap', rowGap);
    buttonMaxWidth = read('buttonMaxWidth', buttonMaxWidth);
    buttonMinWidth = read('buttonMinWidth', buttonMinWidth);
    ovalEndFraction = read('ovalEndFraction', ovalEndFraction);
    screenPad = read('screenPad', screenPad);
    buttonTextOffsetX = read('buttonTextOffsetX', buttonTextOffsetX);
    buttonTextOffsetY = read('buttonTextOffsetY', buttonTextOffsetY);
    parchmentTextPad = read('parchmentTextPad', parchmentTextPad);
  }

  Future<void> _save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_prefsKey, jsonEncode(toMap()));
    savePlayUiLayout(layoutJson);
  }
}
