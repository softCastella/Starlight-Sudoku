// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '별빛 스도쿠 체험판';

  @override
  String get startNewPuzzle => '새 퍼즐 시작';

  @override
  String get continueGame => '이어서 하기';

  @override
  String get viewVillage => '마을 보기';

  @override
  String get copyright => '© Tyche Spark. All rights reserved';

  @override
  String get puzzleComplete => '퍼즐 완성!';

  @override
  String get starlightArrived => '마을에 별빛이 도착했어요.';

  @override
  String get alreadyCleared => '이미 클리어한 스테이지예요.';

  @override
  String elapsedTime(String time) {
    return '소요 시간  $time';
  }

  @override
  String elapsedMinutesSeconds(int minutes, int seconds) {
    return '$minutes분 $seconds초';
  }

  @override
  String elapsedHoursMinutesSeconds(int hours, int minutes, int seconds) {
    return '$hours시간 $minutes분 $seconds초';
  }

  @override
  String get next => '다음';

  @override
  String get done => '완료';

  @override
  String get trialEndTitle => '체험판은 여기까지입니다.';

  @override
  String get trialEndMessage => '리뷰를 남겨주시면 큰 힘이 됩니다.';

  @override
  String get sendReview => '이동하기';

  @override
  String get close => '닫기';

  @override
  String get giveUpTitle => '퍼즐을 나갈까요?';

  @override
  String get giveUpMessage => '현재 진행 상황은 이어하기에 저장됩니다.';

  @override
  String get keepPlaying => '계속 풀기';

  @override
  String get exitPuzzle => '나가기';

  @override
  String get giveUpTooltip => '포기하고 나가기';

  @override
  String get pauseTooltip => '일시 정지';

  @override
  String get retryTooltip => '다시 풀기';

  @override
  String get autoCompleteTooltip => '자동 완성';

  @override
  String get skipTrialTooltip => '테스트: 10판 클리어';

  @override
  String get memoInput => '메모 입력';

  @override
  String get numberInput => '숫자 입력';

  @override
  String get delete => '삭제';

  @override
  String get memo => '메모';

  @override
  String get memoOn => '메모 ON';

  @override
  String hintCount(int count) {
    return '힌트 $count';
  }

  @override
  String get undo => '실행취소';

  @override
  String get selectCellFirst => '셀을 먼저 선택하세요';

  @override
  String get fixedCell => '고정된 셀입니다';

  @override
  String get selectHintCell => '힌트를 볼 셀을 먼저 선택하세요';

  @override
  String get hintUnavailable => '이 셀에는 힌트를 사용할 수 없습니다';

  @override
  String get skip => '건너뛰기';

  @override
  String get lightFirstWindow => '첫 창문을 밝히기';

  @override
  String get openingHeadline0 => '잠든 마을';

  @override
  String get openingBody0 => '별빛 마을은 오래도록 밤이었습니다.\n창문은 꺼지고, 골목도 조용했습니다.';

  @override
  String get openingHeadline1 => '창문의 불빛';

  @override
  String get openingBody1 => '퍼즐 한 판이 창문 하나입니다.\n칸을 채울 때마다 마을에 작은 불이 들어옵니다.';

  @override
  String get openingHeadline2 => '아침이 오면';

  @override
  String get openingBody2 => '별빛이 모이면 하늘이 밝아집니다.\n잠든 빵집과 도서관, 분수 광장이 다시 깨어납니다.';

  @override
  String get difficultySelect => '난이도 선택';

  @override
  String get difficultyLead => '어느 골목의 창문을 먼저 밝혀 볼까요';

  @override
  String get difficultySub => '길을 고르면 그 마을의 스테이지가 열립니다.';

  @override
  String get difficultyEasy => '쉬움';

  @override
  String get difficultyNormal => '보통';

  @override
  String get difficultyHard => '어려움';

  @override
  String get difficultyBlurbEasy => '골목에 첫 창문이 켜지는 길';

  @override
  String get difficultyBlurbNormal => '언덕 너머 불이 이어지는 길';

  @override
  String get difficultyBlurbHard => '아직 깊이 잠든 마을의 길';

  @override
  String get stages => '스테이지';

  @override
  String get starlight => '별빛';

  @override
  String stagesCleared(int completed, int total) {
    return '$completed/$total 클리어';
  }

  @override
  String get previousStageFirst => '이전 스테이지를 먼저 완료하세요';

  @override
  String get preparingPuzzle => '퍼즐을 준비하고 있어요';

  @override
  String stageTitle(String difficulty) {
    return '$difficulty 스테이지';
  }

  @override
  String get morningComes => '스테이지를 클리어할수록 마을에 아침이 와요.';

  @override
  String get villageTitle => '별빛 마을';

  @override
  String get mission => '미션';

  @override
  String restoredCount(int completed, int total) {
    return '$completed / $total개 복원';
  }

  @override
  String ownedStarlight(int amount) {
    return '보유 스타라이트  $amount';
  }

  @override
  String restorationLevel(int level) {
    return '복원 단계 $level / 5';
  }

  @override
  String needsMoreStarlight(int amount) {
    return '$amount StarLight가 더 필요합니다.';
  }

  @override
  String get harborUnlockTitle => '달빛 항구 해금';

  @override
  String get harborUnlockBody =>
      '별빛 마을이 다시 빛나기 시작했습니다. 다음 이야기는 바닷바람이 부는 달빛 항구에서 이어집니다.';

  @override
  String get towardHarbor => '항구를 향해';

  @override
  String get nextVillage => '다음 마을: 달빛 항구';

  @override
  String get newStoryOpened => '새로운 이야기가 열렸습니다.';

  @override
  String get harborStoryTooltip => '달빛 항구 이야기 보기';

  @override
  String get missionsTitle => '복원 미션';

  @override
  String get missionsLead => '퍼즐을 풀면 별빛이 모이고, 창문이 다시 켜집니다.';

  @override
  String currentStarlight(int amount) {
    return '지금 별빛  $amount';
  }

  @override
  String get restorationComplete => '복원 완료';

  @override
  String starlightRemaining(int amount) {
    return '별빛 $amount 남음';
  }

  @override
  String get buildingBakery => '빵집';

  @override
  String get buildingLibrary => '도서관';

  @override
  String get buildingFountain => '분수 광장';

  @override
  String get bakeryHeadline => '첫 번째 따뜻한 불빛';

  @override
  String get bakeryDescription => '오래된 빵집의 오븐은 별빛을 기다리고 있습니다.';

  @override
  String get bakeryCompleted => '오븐에 불이 들어왔습니다. 골목에 갓 구운 빵 향기가 퍼집니다.';

  @override
  String get libraryHeadline => '잠든 이야기들';

  @override
  String get libraryDescription => '먼지 쌓인 도서관의 책들은 다시 읽히기를 기다립니다.';

  @override
  String get libraryCompleted => '책장에 불빛이 켜졌습니다. 마을의 이야기가 다시 이어집니다.';

  @override
  String get fountainHeadline => '광장으로 돌아온 노래';

  @override
  String get fountainDescription => '마른 분수 광장에 사람들의 웃음이 돌아올 날이 멀지 않았습니다.';

  @override
  String get fountainCompleted => '분수가 다시 흐르기 시작했습니다. 마을의 중심이 환하게 빛납니다.';

  @override
  String get villageVista => '별빛 마을 전경';

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
    return '$name, 복원 단계 $level';
  }

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsTooltip => '설정';

  @override
  String get settingsBgm => 'BGM';

  @override
  String get settingsSfx => '효과음';

  @override
  String get settingsUserId => '유저 ID';

  @override
  String get settingsCopyId => '복사';

  @override
  String get settingsIdCopied => '복사했어요';

  @override
  String get settingsPrivacyPolicy => '개인정보처리방침';

  @override
  String get settingsPrivacyOpenError => '페이지를 열 수 없어요';

  @override
  String get settingsCredits => '크레딧';

  @override
  String get creditsTitle => '크레딧';

  @override
  String get creditsBody =>
      '별빛 스도쿠\n\n개발  티케웍스 (Tyche Works)\n라인  티케스파크 (Tyche Spark)\n\n© Tyche Spark. All rights reserved';

  @override
  String get exitGameTitle => '별빛 스도쿠를 종료할까요?';

  @override
  String get exitGameMessage => '진행 상황은 이 기기에 저장되어 있습니다.';

  @override
  String get stayInGame => '계속하기';

  @override
  String get quitGame => '종료';
}
