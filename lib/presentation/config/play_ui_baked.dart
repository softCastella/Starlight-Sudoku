/// Factory layout from the 2026-09-09 device JSON (schema 3 locales).
///
/// Per language × screen. The same chip (인트로, 마을, 설정, …) is allowed
/// to differ by locale. User slider overlays sit on top of these values.
/// Common tokens (oval/modal button 11, title parchment 15, oval end 0.19,
/// default modal pad 40) stay in [PlayUi] — they are not baked here.
class PlayUiBaked {
  PlayUiBaked._();

  static double? value(String locale, String targetId, String key) =>
      locales[locale]?[targetId]?[key];

  /// Baked first, then [user] overlays.
  static Map<String, Map<String, Map<String, double>>> merge(
    Map<String, Map<String, Map<String, double>>> user,
  ) {
    final out = <String, Map<String, Map<String, double>>>{};
    for (final locale in {...locales.keys, ...user.keys}) {
      final byTarget = <String, Map<String, double>>{};
      final bakedTargets = locales[locale] ?? const {};
      final userTargets = user[locale] ?? const {};
      for (final id in {...bakedTargets.keys, ...userTargets.keys}) {
        byTarget[id] = {
          ...?bakedTargets[id],
          ...?userTargets[id],
        };
      }
      if (byTarget.isNotEmpty) out[locale] = byTarget;
    }
    return out;
  }

  static const Map<String, Map<String, Map<String, double>>> locales = {
    'ko': {
      'titleButton': {'buttonMaxWidth': 208.86, 'button': 15},
      'openingButton': {
        'buttonMaxWidth': 174.61,
        'buttonHeightScale': 0.767,
      },
      'villageButton': {'buttonMaxWidth': 112.91},
      'bgmGate': {'buttonMaxWidth': 112.7},
      'settings': {
        'buttonMaxWidth': 113.32,
        'label': 15.61,
        'modalPadX': 45.76,
        'modalPadY': 16,
        'modalInset': 23.92,
        'modalInsetY': 24.07,
        'rowGap': 4,
      },
      'credits': {
        'buttonMaxWidth': 112.91,
        'modalInset': 37.12,
        'modalPadY': 28.81,
      },
    },
    'en': {
      'titleButton': {'button': 15},
      'openingButton': {'buttonMaxWidth': 180.48},
      'villageButton': {'buttonMaxWidth': 113.22},
      'bgmGate': {'buttonMaxWidth': 112.6},
      'settings': {
        'buttonMaxWidth': 112.91,
        'rowGap': 4,
        'modalPadY': 16,
      },
      'credits': {
        'buttonMaxWidth': 112.65,
        'modalInset': 37.10,
        'modalPadY': 28.87,
      },
    },
    'ja': {
      'titleButton': {'button': 15},
      'openingButton': {
        'buttonMaxWidth': 173.94,
        'buttonHeightScale': 0.84,
      },
      'villageButton': {
        'buttonMaxWidth': 127.18,
        'buttonHeightScale': 0.91,
      },
      'bgmGate': {'buttonMaxWidth': 112.7},
      'settings': {
        'buttonMaxWidth': 112.86,
        'rowGap': 4,
        'modalInsetY': 23.57,
        'modalPadY': 16,
      },
      'credits': {'buttonMaxWidth': 112.65},
      'exitGame': {'modalInset': 40.92},
      'giveUp': {'modalPadX': 44.31},
    },
    'zh': {
      'titleButton': {'button': 15},
      'openingButton': {
        'buttonMaxWidth': 151.12,
        'buttonHeightScale': 0.941,
      },
      'villageButton': {'buttonMaxWidth': 112.7},
      'bgmGate': {'buttonMaxWidth': 113.42},
      'settings': {
        'buttonMaxWidth': 113.17,
        'modalPadY': 16,
        'rowGap': 4,
      },
      'credits': {
        'buttonMaxWidth': 113.17,
        'modalInset': 36.65,
        'modalPadY': 29.17,
      },
    },
    'zh_TW': {
      'titleButton': {'button': 15},
      'openingButton': {
        'buttonMaxWidth': 151.28,
        'buttonHeightScale': 0.939,
      },
      'villageButton': {'buttonMaxWidth': 113.17},
      'bgmGate': {'buttonMaxWidth': 112.91},
      'settings': {
        'buttonMaxWidth': 112.91,
        'modalInsetY': 24.15,
        'modalPadY': 16,
        'rowGap': 4,
      },
      'credits': {
        'buttonMaxWidth': 112.96,
        'modalInset': 37.23,
        'modalPadY': 29.33,
      },
    },
  };
}
