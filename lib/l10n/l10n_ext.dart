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
