// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Starlight Sudoku';

  @override
  String get startNewPuzzle => 'New puzzle';

  @override
  String get continueGame => 'Continue';

  @override
  String get viewVillage => 'Village';

  @override
  String get copyright => '© Tyche Spark. All rights reserved';

  @override
  String get puzzleComplete => 'Puzzle complete!';

  @override
  String get starlightArrived => 'Starlight has reached the village.';

  @override
  String get alreadyCleared => 'You already cleared this stage.';

  @override
  String elapsedTime(String time) {
    return 'Time  $time';
  }

  @override
  String elapsedMinutesSeconds(int minutes, int seconds) {
    return '$minutes min $seconds sec';
  }

  @override
  String elapsedHoursMinutesSeconds(int hours, int minutes, int seconds) {
    return '$hours hr $minutes min $seconds sec';
  }

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get trialEndTitle => 'That\'s all for the trial.';

  @override
  String get trialEndMessage =>
      'If you\'d like to support us, a review would mean a lot.';

  @override
  String get sendReview => 'Send';

  @override
  String get close => 'Close';

  @override
  String get giveUpTitle => 'Leave this puzzle?';

  @override
  String get giveUpMessage => 'Your progress will be saved for Continue.';

  @override
  String get keepPlaying => 'Keep playing';

  @override
  String get exitPuzzle => 'Leave';

  @override
  String get giveUpTooltip => 'Give up and leave';

  @override
  String get pauseTooltip => 'Pause';

  @override
  String get retryTooltip => 'Retry';

  @override
  String get autoCompleteTooltip => 'Auto complete';

  @override
  String get memoInput => 'Memo input';

  @override
  String get numberInput => 'Number input';

  @override
  String get delete => 'Erase';

  @override
  String get memo => 'Memo';

  @override
  String get memoOn => 'Memo ON';

  @override
  String hintCount(int count) {
    return 'Hint $count';
  }

  @override
  String get undo => 'Undo';

  @override
  String get selectCellFirst => 'Select a cell first';

  @override
  String get fixedCell => 'That cell is given';

  @override
  String get selectHintCell => 'Select a cell for a hint';

  @override
  String get hintUnavailable => 'A hint cannot be used on this cell';

  @override
  String get skip => 'Skip';

  @override
  String get lightFirstWindow => 'Light the first window';

  @override
  String get openingHeadline0 => 'A sleeping village';

  @override
  String get openingBody0 =>
      'Starlight Village had been night for a long time.\nThe windows were dark, and the alleys were still.';

  @override
  String get openingHeadline1 => 'Light in the windows';

  @override
  String get openingBody1 =>
      'Each puzzle is one window.\nEvery filled cell brings a little light to the village.';

  @override
  String get openingHeadline2 => 'When morning comes';

  @override
  String get openingBody2 =>
      'When starlight gathers, the sky grows bright.\nThe bakery, library, and fountain square wake again.';

  @override
  String get difficultySelect => 'Choose a path';

  @override
  String get difficultyLead => 'Which alley’s window will you light first?';

  @override
  String get difficultySub => 'Choose a path to open that village’s stages.';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get difficultyBlurbEasy =>
      'The path where the first windows light the alley';

  @override
  String get difficultyBlurbNormal =>
      'The path where lights continue over the hill';

  @override
  String get difficultyBlurbHard =>
      'The path through the village still fast asleep';

  @override
  String get stages => 'Stages';

  @override
  String get starlight => 'StarLight';

  @override
  String stagesCleared(int completed, int total) {
    return '$completed/$total cleared';
  }

  @override
  String get previousStageFirst => 'Clear the previous stage first';

  @override
  String get preparingPuzzle => 'Preparing the puzzle';

  @override
  String stageTitle(String difficulty) {
    return '$difficulty stages';
  }

  @override
  String get morningComes =>
      'Morning comes to the village as you clear stages.';

  @override
  String get villageTitle => 'Starlight Village';

  @override
  String get mission => 'Missions';

  @override
  String restoredCount(int completed, int total) {
    return '$completed / $total restored';
  }

  @override
  String ownedStarlight(int amount) {
    return 'StarLight  $amount';
  }

  @override
  String restorationLevel(int level) {
    return 'Restoration $level / 5';
  }

  @override
  String needsMoreStarlight(int amount) {
    return '$amount more StarLight needed.';
  }

  @override
  String get harborUnlockTitle => 'Moonlit Harbor unlocked';

  @override
  String get harborUnlockBody =>
      'Starlight Village is beginning to shine again. The next story continues at Moonlit Harbor, where the sea wind blows.';

  @override
  String get towardHarbor => 'To the harbor';

  @override
  String get nextVillage => 'Next village: Moonlit Harbor';

  @override
  String get newStoryOpened => 'A new story has opened.';

  @override
  String get harborStoryTooltip => 'View the Moonlit Harbor story';

  @override
  String get missionsTitle => 'Restoration missions';

  @override
  String get missionsLead =>
      'Solve puzzles to gather starlight, and the windows light again.';

  @override
  String currentStarlight(int amount) {
    return 'Starlight now  $amount';
  }

  @override
  String get restorationComplete => 'Restored';

  @override
  String starlightRemaining(int amount) {
    return '$amount StarLight left';
  }

  @override
  String get buildingBakery => 'Bakery';

  @override
  String get buildingLibrary => 'Library';

  @override
  String get buildingFountain => 'Fountain square';

  @override
  String get bakeryHeadline => 'The first warm light';

  @override
  String get bakeryDescription =>
      'The old bakery oven is waiting for starlight.';

  @override
  String get bakeryCompleted =>
      'The oven is lit. Fresh bread scent fills the alley.';

  @override
  String get libraryHeadline => 'Sleeping stories';

  @override
  String get libraryDescription =>
      'The dusty library books wait to be read again.';

  @override
  String get libraryCompleted =>
      'The shelves are lit. The village stories continue.';

  @override
  String get fountainHeadline => 'Song returns to the square';

  @override
  String get fountainDescription =>
      'Laughter will not be far from the dry fountain square.';

  @override
  String get fountainCompleted =>
      'The fountain flows again. The heart of the village shines.';

  @override
  String get villageVista => 'Starlight Village vista';

  @override
  String gameLevelTitle(String difficulty, int level) {
    return '$difficulty $level';
  }

  @override
  String buildingLevelLabel(String name, int level) {
    return '$name  $level/5';
  }

  @override
  String buildingSemantics(String name, int level) {
    return '$name, restoration $level';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get settingsBgm => 'BGM';

  @override
  String get settingsSfx => 'Sound effects';

  @override
  String get settingsUserId => 'User ID';

  @override
  String get settingsCopyId => 'Copy';

  @override
  String get settingsIdCopied => 'Copied';

  @override
  String get settingsPrivacyPolicy => 'Privacy policy';

  @override
  String get settingsPrivacyOpenError => 'Couldn\'t open the page';

  @override
  String get exitGameTitle => 'Leave Starlight Sudoku?';

  @override
  String get exitGameMessage => 'Your progress stays on this device.';

  @override
  String get stayInGame => 'Stay';

  @override
  String get quitGame => 'Quit';
}
