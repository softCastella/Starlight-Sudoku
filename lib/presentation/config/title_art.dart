import 'package:flutter/widgets.dart';

/// Locale-specific title paintings. Filenames keep the delivered spelling.
class TitleArt {
  TitleArt._();

  static const korean =
      'assets/images/Scene/Title_Image_Starlight Sdoku KR.png';
  static const english =
      'assets/images/Scene/Title_Image_Starlight Sdoku EN.png';
  static const japanese =
      'assets/images/Scene/Title_Image_Starlight Sdoku JP.png';
  static const chineseSimplified =
      'assets/images/Scene/Title_Image_Starlight Sdoku CN.png';
  static const chineseTraditional =
      'assets/images/Scene/Title_Image_Starlight Sdoku TW.png';

  static const fallback = korean;

  /// Native pixel size of the locale title paintings.
  static const paintingWidth = 1080.0;
  static const paintingHeight = 2340.0;
  static const paintingAspectRatio = paintingWidth / paintingHeight;

  static String assetFor(Locale locale) {
    if (locale.languageCode == 'zh') {
      final region = locale.countryCode?.toUpperCase();
      if (region == 'TW' || region == 'HK' || region == 'MO') {
        return chineseTraditional;
      }
      return chineseSimplified;
    }

    return switch (locale.languageCode) {
      'en' => english,
      'ja' => japanese,
      'ko' => korean,
      _ => fallback,
    };
  }

  static String assetOf(BuildContext context) {
    return assetFor(Localizations.localeOf(context));
  }
}
