import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/l10n/app_localizations.dart';
import 'package:sudoku_game/presentation/config/app_fonts.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/notifiers/locale_override.dart';
import 'package:sudoku_game/presentation/screens/splash_screen.dart';

/// 메인 앱 위젯
class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key, this.locale});

  /// When set, skips device-language detection. Used by widget tests.
  final Locale? locale;

  static final navigatorKey = GlobalKey<NavigatorState>();

  static const _fallbackLocale = Locale('ko');

  static Locale _resolveLocale(Locale? locale, Iterable<Locale> supported) {
    if (locale == null) return _fallbackLocale;
    for (final candidate in supported) {
      if (candidate.languageCode == locale.languageCode &&
          candidate.countryCode == locale.countryCode) {
        return candidate;
      }
    }
    for (final candidate in supported) {
      if (candidate.languageCode == locale.languageCode) {
        return candidate;
      }
    }
    return _fallbackLocale;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final notifier = GameNotifier();
            notifier.loadProgress();
            return notifier;
          },
        ),
        ChangeNotifierProvider(create: (_) => LocaleOverride()),
      ],
      child: Consumer<LocaleOverride>(
        builder: (context, locales, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            locale: locales.override ?? locale,
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)?.appTitle ?? '별빛 스도쿠',
            localeResolutionCallback: _resolveLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: AppFonts.family,
          fontFamilyFallback: AppFonts.fallback,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue[600],
              side: BorderSide(color: Colors.blue[600]!, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
