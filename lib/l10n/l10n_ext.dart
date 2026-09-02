import 'package:flutter/widgets.dart';
import 'package:sudoku_game/core/sudoku/sudoku_difficulty.dart';
import 'package:sudoku_game/l10n/app_localizations.dart';

AppLocalizations l10nOf(BuildContext context) => AppLocalizations.of(context)!;

extension StarlightL10n on AppLocalizations {
  String difficultyName(SudokuDifficulty difficulty) {
    return switch (difficulty) {
      SudokuDifficulty.easy => difficultyEasy,
      SudokuDifficulty.normal => difficultyNormal,
      SudokuDifficulty.hard => difficultyHard,
    };
  }

  /// Localized name, plus English when they differ (e.g. `쉬움 · Easy`).
  String difficultyPathTitle(SudokuDifficulty difficulty) {
    final localized = difficultyName(difficulty);
    final english = DifficultyConfig.getConfig(difficulty).getDisplayName();
    if (localized == english) return localized;
    return '$localized · $english';
  }

  String formatElapsed(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hours > 0) {
      return elapsedHoursMinutesSeconds(hours, minutes, secs);
    }
    return elapsedMinutesSeconds(minutes, secs);
  }

  String difficultyBlurb(SudokuDifficulty difficulty) {
    return switch (difficulty) {
      SudokuDifficulty.easy => difficultyBlurbEasy,
      SudokuDifficulty.normal => difficultyBlurbNormal,
      SudokuDifficulty.hard => difficultyBlurbHard,
    };
  }

  String buildingName(String id) {
    return switch (id) {
      'bakery' => buildingBakery,
      'library' => buildingLibrary,
      'fountain' => buildingFountain,
      _ => id,
    };
  }

  String villageHeadline(String id) {
    return switch (id) {
      'bakery' => bakeryHeadline,
      'library' => libraryHeadline,
      'fountain' => fountainHeadline,
      _ => id,
    };
  }

  String villageDescription(String id) {
    return switch (id) {
      'bakery' => bakeryDescription,
      'library' => libraryDescription,
      'fountain' => fountainDescription,
      _ => id,
    };
  }

  String villageCompleted(String id) {
    return switch (id) {
      'bakery' => bakeryCompleted,
      'library' => libraryCompleted,
      'fountain' => fountainCompleted,
      _ => id,
    };
  }

  String openingHeadline(int index) {
    return switch (index) {
      0 => openingHeadline0,
      1 => openingHeadline1,
      _ => openingHeadline2,
    };
  }

  String openingBody(int index) {
    return switch (index) {
      0 => openingBody0,
      1 => openingBody1,
      _ => openingBody2,
    };
  }
}
