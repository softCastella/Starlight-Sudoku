import 'dart:convert';

import 'package:flutter/services.dart';

/// Bundled UI typefaces. Preload before [runApp] so CJK glyphs never flash
/// as .notdef "X" boxes while Flutter would otherwise download fallbacks.
class AppFonts {
  AppFonts._();

  static const family = 'StarlightSans';
  static const fallback = <String>['StarlightSansCJK'];

  static Future<void> preload() async {
    final encoded = await rootBundle.loadString('FontManifest.json');
    final manifest = jsonDecode(encoded) as List<dynamic>;
    final pending = <Future<void>>[];
    for (final item in manifest) {
      final loader = FontLoader(item['family'] as String);
      for (final font in item['fonts'] as List<dynamic>) {
        loader.addFont(rootBundle.load(font['asset'] as String));
      }
      pending.add(loader.load());
    }
    await Future.wait(pending);
  }
}
