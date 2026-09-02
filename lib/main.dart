import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku_game/presentation/app.dart';
import 'package:sudoku_game/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(HomeScreen.nightOverlayStyle);
  runApp(const SudokuApp());
}

