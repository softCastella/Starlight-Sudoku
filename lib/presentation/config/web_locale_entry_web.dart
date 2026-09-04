import 'package:flutter/widgets.dart';
import 'package:sudoku_game/presentation/config/web_locale.dart';
import 'package:web/web.dart' as web;

/// Reads landing `?lang=` first, then the value stored before Flutter's hash URL.
Locale? localeFromWebEntry() {
  final fromUri = localeFromQuery(Uri.parse(web.window.location.href));
  if (fromUri != null) {
    _store(langCodeFromLocale(fromUri));
    return fromUri;
  }
  try {
    return localeFromLangCode(
      web.window.sessionStorage.getItem(storedLandingLangKey),
    );
  } catch (_) {
    return null;
  }
}

void _store(String lang) {
  try {
    web.window.sessionStorage.setItem(storedLandingLangKey, lang);
  } catch (_) {}
}
