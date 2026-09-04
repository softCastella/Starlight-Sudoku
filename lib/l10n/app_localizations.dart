import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Starlight Sudoku Trial'**
  String get appTitle;

  /// No description provided for @startNewPuzzle.
  ///
  /// In en, this message translates to:
  /// **'New puzzle'**
  String get startNewPuzzle;

  /// No description provided for @continueGame.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueGame;

  /// No description provided for @viewVillage.
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get viewVillage;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© Tyche Spark. All rights reserved'**
  String get copyright;

  /// No description provided for @puzzleComplete.
  ///
  /// In en, this message translates to:
  /// **'Puzzle complete!'**
  String get puzzleComplete;

  /// No description provided for @starlightArrived.
  ///
  /// In en, this message translates to:
  /// **'Starlight has reached the village.'**
  String get starlightArrived;

  /// No description provided for @alreadyCleared.
  ///
  /// In en, this message translates to:
  /// **'You already cleared this stage.'**
  String get alreadyCleared;

  /// No description provided for @elapsedTime.
  ///
  /// In en, this message translates to:
  /// **'Time  {time}'**
  String elapsedTime(String time);

  /// No description provided for @elapsedMinutesSeconds.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min {seconds} sec'**
  String elapsedMinutesSeconds(int minutes, int seconds);

  /// No description provided for @elapsedHoursMinutesSeconds.
  ///
  /// In en, this message translates to:
  /// **'{hours} hr {minutes} min {seconds} sec'**
  String elapsedHoursMinutesSeconds(int hours, int minutes, int seconds);

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @trialEndTitle.
  ///
  /// In en, this message translates to:
  /// **'That\'s all for the trial.'**
  String get trialEndTitle;

  /// No description provided for @trialEndMessage.
  ///
  /// In en, this message translates to:
  /// **'A review would mean a lot.'**
  String get trialEndMessage;

  /// No description provided for @sendReview.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get sendReview;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @giveUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave this puzzle?'**
  String get giveUpTitle;

  /// No description provided for @giveUpMessage.
  ///
  /// In en, this message translates to:
  /// **'Your progress will be saved for Continue.'**
  String get giveUpMessage;

  /// No description provided for @keepPlaying.
  ///
  /// In en, this message translates to:
  /// **'Keep playing'**
  String get keepPlaying;

  /// No description provided for @exitPuzzle.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get exitPuzzle;

  /// No description provided for @giveUpTooltip.
  ///
  /// In en, this message translates to:
  /// **'Give up and leave'**
  String get giveUpTooltip;

  /// No description provided for @pauseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseTooltip;

  /// No description provided for @retryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryTooltip;

  /// No description provided for @autoCompleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Auto complete'**
  String get autoCompleteTooltip;

  /// No description provided for @skipTrialTooltip.
  ///
  /// In en, this message translates to:
  /// **'Test: clear 10 stages'**
  String get skipTrialTooltip;

  /// No description provided for @memoInput.
  ///
  /// In en, this message translates to:
  /// **'Memo input'**
  String get memoInput;

  /// No description provided for @numberInput.
  ///
  /// In en, this message translates to:
  /// **'Number input'**
  String get numberInput;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Erase'**
  String get delete;

  /// No description provided for @memo.
  ///
  /// In en, this message translates to:
  /// **'Memo'**
  String get memo;

  /// No description provided for @memoOn.
  ///
  /// In en, this message translates to:
  /// **'Memo ON'**
  String get memoOn;

  /// No description provided for @hintCount.
  ///
  /// In en, this message translates to:
  /// **'Hint {count}'**
  String hintCount(int count);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @selectCellFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a cell first'**
  String get selectCellFirst;

  /// No description provided for @fixedCell.
  ///
  /// In en, this message translates to:
  /// **'That cell is given'**
  String get fixedCell;

  /// No description provided for @selectHintCell.
  ///
  /// In en, this message translates to:
  /// **'Select a cell for a hint'**
  String get selectHintCell;

  /// No description provided for @hintUnavailable.
  ///
  /// In en, this message translates to:
  /// **'A hint cannot be used on this cell'**
  String get hintUnavailable;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @lightFirstWindow.
  ///
  /// In en, this message translates to:
  /// **'Light the first window'**
  String get lightFirstWindow;

  /// No description provided for @openingHeadline0.
  ///
  /// In en, this message translates to:
  /// **'A sleeping village'**
  String get openingHeadline0;

  /// No description provided for @openingBody0.
  ///
  /// In en, this message translates to:
  /// **'Starlight Village had been night for a long time.\nThe windows were dark, and the alleys were still.'**
  String get openingBody0;

  /// No description provided for @openingHeadline1.
  ///
  /// In en, this message translates to:
  /// **'Light in the windows'**
  String get openingHeadline1;

  /// No description provided for @openingBody1.
  ///
  /// In en, this message translates to:
  /// **'Each puzzle is one window.\nEvery filled cell brings a little light to the village.'**
  String get openingBody1;

  /// No description provided for @openingHeadline2.
  ///
  /// In en, this message translates to:
  /// **'When morning comes'**
  String get openingHeadline2;

  /// No description provided for @openingBody2.
  ///
  /// In en, this message translates to:
  /// **'When starlight gathers, the sky grows bright.\nThe bakery, library, and fountain square wake again.'**
  String get openingBody2;

  /// No description provided for @difficultySelect.
  ///
  /// In en, this message translates to:
  /// **'Choose a path'**
  String get difficultySelect;

  /// No description provided for @difficultyLead.
  ///
  /// In en, this message translates to:
  /// **'Which alley’s window will you light first?'**
  String get difficultyLead;

  /// No description provided for @difficultySub.
  ///
  /// In en, this message translates to:
  /// **'Choose a path to open that village’s stages.'**
  String get difficultySub;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get difficultyNormal;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @difficultyBlurbEasy.
  ///
  /// In en, this message translates to:
  /// **'The path where the first windows light the alley'**
  String get difficultyBlurbEasy;

  /// No description provided for @difficultyBlurbNormal.
  ///
  /// In en, this message translates to:
  /// **'The path where lights continue over the hill'**
  String get difficultyBlurbNormal;

  /// No description provided for @difficultyBlurbHard.
  ///
  /// In en, this message translates to:
  /// **'The path through the village still fast asleep'**
  String get difficultyBlurbHard;

  /// No description provided for @stages.
  ///
  /// In en, this message translates to:
  /// **'Stages'**
  String get stages;

  /// No description provided for @starlight.
  ///
  /// In en, this message translates to:
  /// **'StarLight'**
  String get starlight;

  /// No description provided for @stagesCleared.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} cleared'**
  String stagesCleared(int completed, int total);

  /// No description provided for @previousStageFirst.
  ///
  /// In en, this message translates to:
  /// **'Clear the previous stage first'**
  String get previousStageFirst;

  /// No description provided for @preparingPuzzle.
  ///
  /// In en, this message translates to:
  /// **'Preparing the puzzle'**
  String get preparingPuzzle;

  /// No description provided for @stageTitle.
  ///
  /// In en, this message translates to:
  /// **'{difficulty} stages'**
  String stageTitle(String difficulty);

  /// No description provided for @morningComes.
  ///
  /// In en, this message translates to:
  /// **'Morning comes to the village as you clear stages.'**
  String get morningComes;

  /// No description provided for @villageTitle.
  ///
  /// In en, this message translates to:
  /// **'Starlight Village'**
  String get villageTitle;

  /// No description provided for @mission.
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get mission;

  /// No description provided for @restoredCount.
  ///
  /// In en, this message translates to:
  /// **'{completed} / {total} restored'**
  String restoredCount(int completed, int total);

  /// No description provided for @ownedStarlight.
  ///
  /// In en, this message translates to:
  /// **'StarLight  {amount}'**
  String ownedStarlight(int amount);

  /// No description provided for @restorationLevel.
  ///
  /// In en, this message translates to:
  /// **'Restoration {level} / 5'**
  String restorationLevel(int level);

  /// No description provided for @needsMoreStarlight.
  ///
  /// In en, this message translates to:
  /// **'{amount} more StarLight needed.'**
  String needsMoreStarlight(int amount);

  /// No description provided for @harborUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Moonlit Harbor unlocked'**
  String get harborUnlockTitle;

  /// No description provided for @harborUnlockBody.
  ///
  /// In en, this message translates to:
  /// **'Starlight Village is beginning to shine again. The next story continues at Moonlit Harbor, where the sea wind blows.'**
  String get harborUnlockBody;

  /// No description provided for @towardHarbor.
  ///
  /// In en, this message translates to:
  /// **'To the harbor'**
  String get towardHarbor;

  /// No description provided for @nextVillage.
  ///
  /// In en, this message translates to:
  /// **'Next village: Moonlit Harbor'**
  String get nextVillage;

  /// No description provided for @newStoryOpened.
  ///
  /// In en, this message translates to:
  /// **'A new story has opened.'**
  String get newStoryOpened;

  /// No description provided for @harborStoryTooltip.
  ///
  /// In en, this message translates to:
  /// **'View the Moonlit Harbor story'**
  String get harborStoryTooltip;

  /// No description provided for @missionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Restoration missions'**
  String get missionsTitle;

  /// No description provided for @missionsLead.
  ///
  /// In en, this message translates to:
  /// **'Solve puzzles to gather starlight, and the windows light again.'**
  String get missionsLead;

  /// No description provided for @currentStarlight.
  ///
  /// In en, this message translates to:
  /// **'Starlight now  {amount}'**
  String currentStarlight(int amount);

  /// No description provided for @restorationComplete.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get restorationComplete;

  /// No description provided for @starlightRemaining.
  ///
  /// In en, this message translates to:
  /// **'{amount} StarLight left'**
  String starlightRemaining(int amount);

  /// No description provided for @buildingBakery.
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get buildingBakery;

  /// No description provided for @buildingLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get buildingLibrary;

  /// No description provided for @buildingFountain.
  ///
  /// In en, this message translates to:
  /// **'Fountain square'**
  String get buildingFountain;

  /// No description provided for @bakeryHeadline.
  ///
  /// In en, this message translates to:
  /// **'The first warm light'**
  String get bakeryHeadline;

  /// No description provided for @bakeryDescription.
  ///
  /// In en, this message translates to:
  /// **'The old bakery oven is waiting for starlight.'**
  String get bakeryDescription;

  /// No description provided for @bakeryCompleted.
  ///
  /// In en, this message translates to:
  /// **'The oven is lit. Fresh bread scent fills the alley.'**
  String get bakeryCompleted;

  /// No description provided for @libraryHeadline.
  ///
  /// In en, this message translates to:
  /// **'Sleeping stories'**
  String get libraryHeadline;

  /// No description provided for @libraryDescription.
  ///
  /// In en, this message translates to:
  /// **'The dusty library books wait to be read again.'**
  String get libraryDescription;

  /// No description provided for @libraryCompleted.
  ///
  /// In en, this message translates to:
  /// **'The shelves are lit. The village stories continue.'**
  String get libraryCompleted;

  /// No description provided for @fountainHeadline.
  ///
  /// In en, this message translates to:
  /// **'Song returns to the square'**
  String get fountainHeadline;

  /// No description provided for @fountainDescription.
  ///
  /// In en, this message translates to:
  /// **'Laughter will not be far from the dry fountain square.'**
  String get fountainDescription;

  /// No description provided for @fountainCompleted.
  ///
  /// In en, this message translates to:
  /// **'The fountain flows again. The heart of the village shines.'**
  String get fountainCompleted;

  /// No description provided for @villageVista.
  ///
  /// In en, this message translates to:
  /// **'Starlight Village vista'**
  String get villageVista;

  /// No description provided for @gameLevelTitle.
  ///
  /// In en, this message translates to:
  /// **'{difficulty} {level}'**
  String gameLevelTitle(String difficulty, int level);

  /// No description provided for @buildingLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'{name}  {level}/5'**
  String buildingLevelLabel(String name, int level);

  /// No description provided for @buildingSemantics.
  ///
  /// In en, this message translates to:
  /// **'{name}, restoration {level}'**
  String buildingSemantics(String name, int level);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @settingsBgm.
  ///
  /// In en, this message translates to:
  /// **'BGM'**
  String get settingsBgm;

  /// No description provided for @settingsSfx.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get settingsSfx;

  /// No description provided for @settingsUserId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get settingsUserId;

  /// No description provided for @settingsCopyId.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get settingsCopyId;

  /// No description provided for @settingsIdCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get settingsIdCopied;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsPrivacyOpenError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the page'**
  String get settingsPrivacyOpenError;

  /// No description provided for @exitGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Starlight Sudoku?'**
  String get exitGameTitle;

  /// No description provided for @exitGameMessage.
  ///
  /// In en, this message translates to:
  /// **'Your progress stays on this device.'**
  String get exitGameMessage;

  /// No description provided for @stayInGame.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stayInGame;

  /// No description provided for @quitGame.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quitGame;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
