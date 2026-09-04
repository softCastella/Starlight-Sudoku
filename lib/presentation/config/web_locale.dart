import 'package:flutter/widgets.dart';

const storedLandingLangKey = 'starlight_lang';

/// Landing CTA passes `?lang=` so the web game matches that page, not the OS.
Locale? localeFromLangCode(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;

  final normalized = raw.trim().replaceAll('_', '-').toLowerCase();
  if (normalized.startsWith('zh-tw') ||
      normalized.startsWith('zh-hant') ||
      normalized == 'tw' ||
      normalized == 'zh-hk' ||
      normalized == 'zh-mo') {
    return const Locale('zh', 'TW');
  }
  if (normalized.startsWith('zh')) return const Locale('zh');
  if (normalized.startsWith('ja')) return const Locale('ja');
  if (normalized.startsWith('en')) return const Locale('en');
  if (normalized.startsWith('ko')) return const Locale('ko');
  return null;
}

String langCodeFromLocale(Locale locale) {
  if (locale.languageCode == 'zh' && locale.countryCode == 'TW') {
    return 'zh-TW';
  }
  return locale.languageCode;
}

Locale? localeFromQuery(Uri uri) {
  final fromQuery = localeFromLangCode(
    uri.queryParameters['lang'] ?? uri.queryParameters['locale'],
  );
  if (fromQuery != null) return fromQuery;

  final fragment = uri.fragment;
  final queryAt = fragment.indexOf('?');
  if (queryAt < 0) return null;
  final fragmentQuery = Uri.splitQueryString(fragment.substring(queryAt + 1));
  return localeFromLangCode(fragmentQuery['lang'] ?? fragmentQuery['locale']);
}
