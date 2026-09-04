import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku_game/presentation/app.dart';
import 'package:sudoku_game/presentation/config/app_fonts.dart';
import 'package:sudoku_game/presentation/config/web_back_button.dart';
import 'package:sudoku_game/presentation/config/web_locale_entry.dart';
import 'package:sudoku_game/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppFonts.preload();
  interceptWebBackButton(SudokuApp.navigatorKey);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    kIsWeb ? HomeScreen.nightOverlayStyle : HomeScreen.splashOverlayStyle,
  );
  runApp(SudokuApp(locale: kIsWeb ? localeFromWebEntry() : null));
}
