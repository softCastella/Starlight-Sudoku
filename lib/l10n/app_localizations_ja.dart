// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'スターライト数独';

  @override
  String get startNewPuzzle => '新しいパズル';

  @override
  String get continueGame => 'つづきから';

  @override
  String get viewVillage => '村を見る';

  @override
  String get copyright => '© Tyche Spark. All rights reserved';

  @override
  String get puzzleComplete => 'パズル完成！';

  @override
  String get starlightArrived => '村に星の光が届きました。';

  @override
  String get alreadyCleared => 'すでにクリアしたステージです。';

  @override
  String elapsedTime(String time) {
    return '経過時間  $time';
  }

  @override
  String elapsedMinutesSeconds(int minutes, int seconds) {
    return '$minutes分 $seconds秒';
  }

  @override
  String elapsedHoursMinutesSeconds(int hours, int minutes, int seconds) {
    return '$hours時間 $minutes分 $seconds秒';
  }

  @override
  String get next => '次へ';

  @override
  String get done => '完了';

  @override
  String get trialEndTitle => '体験版はここまでです。';

  @override
  String get trialEndMessage => '応援していただけるなら、レビューを残していただけると大きな力になります。';

  @override
  String get sendReview => '送信';

  @override
  String get close => '閉じる';

  @override
  String get giveUpTitle => 'パズルを終了しますか？';

  @override
  String get giveUpMessage => 'いまの進行は「つづきから」に保存されます。';

  @override
  String get keepPlaying => '続ける';

  @override
  String get exitPuzzle => '終了';

  @override
  String get giveUpTooltip => 'あきらめて戻る';

  @override
  String get pauseTooltip => '一時停止';

  @override
  String get retryTooltip => 'やり直す';

  @override
  String get autoCompleteTooltip => '自動完成';

  @override
  String get memoInput => 'メモ入力';

  @override
  String get numberInput => '数字入力';

  @override
  String get delete => '消す';

  @override
  String get memo => 'メモ';

  @override
  String get memoOn => 'メモ ON';

  @override
  String hintCount(int count) {
    return 'ヒント $count';
  }

  @override
  String get undo => '元に戻す';

  @override
  String get selectCellFirst => '先にマスを選んでください';

  @override
  String get fixedCell => '最初から入っている数字です';

  @override
  String get selectHintCell => 'ヒントを見るマスを選んでください';

  @override
  String get hintUnavailable => 'このマスにはヒントを使えません';

  @override
  String get skip => 'スキップ';

  @override
  String get lightFirstWindow => '最初の窓を灯す';

  @override
  String get openingHeadline0 => '眠る村';

  @override
  String get openingBody0 => '星明り村は長いあいだ夜のままでした。\n窓は消え、路地も静かでした。';

  @override
  String get openingHeadline1 => '窓のあかり';

  @override
  String get openingBody1 => 'パズル一枚が、窓ひとつです。\nマスを埋めるたびに、村へ小さな灯が届きます。';

  @override
  String get openingHeadline2 => '朝がくると';

  @override
  String get openingBody2 => '星の光が集まると、空が明るくなります。\n眠っていたパン屋、図書館、噴水広場が目を覚まします。';

  @override
  String get difficultySelect => '難易度';

  @override
  String get difficultyLead => 'どの路地の窓から灯しますか';

  @override
  String get difficultySub => '道を選ぶと、その村のステージが開きます。';

  @override
  String get difficultyEasy => 'かんたん';

  @override
  String get difficultyNormal => 'ふつう';

  @override
  String get difficultyHard => 'むずかしい';

  @override
  String get difficultyBlurbEasy => '路地に最初の窓が灯る道';

  @override
  String get difficultyBlurbNormal => '丘の向こうまで灯が続く道';

  @override
  String get difficultyBlurbHard => 'まだ深く眠る村の道';

  @override
  String get stages => 'ステージ';

  @override
  String get starlight => 'スターライト';

  @override
  String stagesCleared(int completed, int total) {
    return '$completed/$total クリア';
  }

  @override
  String get previousStageFirst => '前のステージを先にクリアしてください';

  @override
  String get preparingPuzzle => 'パズルを用意しています';

  @override
  String stageTitle(String difficulty) {
    return '$difficulty ステージ';
  }

  @override
  String get morningComes => 'ステージをクリアするほど、村に朝が来ます。';

  @override
  String get villageTitle => '星明り村';

  @override
  String get mission => 'ミッション';

  @override
  String restoredCount(int completed, int total) {
    return '$completed / $total 復元';
  }

  @override
  String ownedStarlight(int amount) {
    return '所持スターライト  $amount';
  }

  @override
  String restorationLevel(int level) {
    return '復元 $level / 5';
  }

  @override
  String needsMoreStarlight(int amount) {
    return 'StarLightがあと $amount 必要です。';
  }

  @override
  String get harborUnlockTitle => '月明かりの港 解禁';

  @override
  String get harborUnlockBody => '星明り村が再び輝きはじめました。次の物語は、海風の吹く月明かりの港へ続きます。';

  @override
  String get towardHarbor => '港へ';

  @override
  String get nextVillage => '次の村：月明かりの港';

  @override
  String get newStoryOpened => '新しい物語が開きました。';

  @override
  String get harborStoryTooltip => '月明かりの港の物語を見る';

  @override
  String get missionsTitle => '復元ミッション';

  @override
  String get missionsLead => 'パズルを解くと星の光が集まり、窓が再び灯ります。';

  @override
  String currentStarlight(int amount) {
    return 'いまの星の光  $amount';
  }

  @override
  String get restorationComplete => '復元完了';

  @override
  String starlightRemaining(int amount) {
    return '星の光 残り $amount';
  }

  @override
  String get buildingBakery => 'パン屋';

  @override
  String get buildingLibrary => '図書館';

  @override
  String get buildingFountain => '噴水広場';

  @override
  String get bakeryHeadline => '最初のあたたかい灯';

  @override
  String get bakeryDescription => '古いパン屋のオーブンは星の光を待っています。';

  @override
  String get bakeryCompleted => 'オーブンに火が入りました。路地に焼きたてのパンの香りが広がります。';

  @override
  String get libraryHeadline => '眠っていた物語';

  @override
  String get libraryDescription => 'ほこりの積もった図書館の本は、再び読まれるのを待っています。';

  @override
  String get libraryCompleted => '本棚に灯がともりました。村の物語がまた続きます。';

  @override
  String get fountainHeadline => '広場に戻った歌';

  @override
  String get fountainDescription => '乾いた噴水広場に、人々の笑い声が戻る日は遠くありません。';

  @override
  String get fountainCompleted => '噴水が再び流れ始めました。村の中心が明るく輝きます。';

  @override
  String get villageVista => '星明り村の景色';

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
    return '$name、復元 $level';
  }
}
