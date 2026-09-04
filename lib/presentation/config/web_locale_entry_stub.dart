import 'package:flutter/widgets.dart';
import 'package:sudoku_game/presentation/config/web_locale.dart';

Locale? localeFromWebEntry() => localeFromQuery(Uri.base);
