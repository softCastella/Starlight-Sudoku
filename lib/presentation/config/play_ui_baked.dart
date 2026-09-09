/// Factory button sizes from the 2026-09-09 device JSON.
///
/// Per language × screen. The same chip (인트로, 마을, …) is allowed to
/// differ by locale. User slider overlays sit on top of these values.
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
      'settings': {'buttonMaxWidth': 113.32},
      'credits': {'buttonMaxWidth': 112.91},
    },
    'en': {
      'titleButton': {'button': 15},
      'openingButton': {'buttonMaxWidth': 180.48},
      'villageButton': {'buttonMaxWidth': 113.22},
      'bgmGate': {'buttonMaxWidth': 112.6},
      'settings': {'buttonMaxWidth': 112.91},
      'credits': {'buttonMaxWidth': 112.65},
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
      'settings': {'buttonMaxWidth': 112.86},
      'credits': {'buttonMaxWidth': 112.65},
    },
    'zh': {
      'titleButton': {'button': 15},
      'openingButton': {
        'buttonMaxWidth': 151.12,
        'buttonHeightScale': 0.941,
      },
      'villageButton': {'buttonMaxWidth': 112.7},
      'bgmGate': {'buttonMaxWidth': 113.42},
      'settings': {'buttonMaxWidth': 113.17},
      'credits': {'buttonMaxWidth': 113.17},
    },
    'zh_TW': {
      'titleButton': {'button': 15},
      'openingButton': {
        'buttonMaxWidth': 151.28,
        'buttonHeightScale': 0.939,
      },
      'villageButton': {'buttonMaxWidth': 113.17},
      'bgmGate': {'buttonMaxWidth': 112.91},
      'settings': {'buttonMaxWidth': 112.91},
      'credits': {'buttonMaxWidth': 112.96},
    },
  };
}
