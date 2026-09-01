import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku_game/presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Portrait 방향만 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const SudokuApp());
}

