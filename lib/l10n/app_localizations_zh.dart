// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '星光数独';

  @override
  String get startNewPuzzle => '新的谜题';

  @override
  String get continueGame => '继续游戏';

  @override
  String get viewVillage => '查看村庄';

  @override
  String get copyright => '© Tyche Spark. All rights reserved';

  @override
  String get puzzleComplete => '谜题完成！';

  @override
  String get starlightArrived => '星光已经抵达村庄。';

  @override
  String get alreadyCleared => '这一关已经通关过了。';

  @override
  String elapsedTime(String time) {
    return '用时  $time';
  }

  @override
  String elapsedMinutesSeconds(int minutes, int seconds) {
    return '$minutes分 $seconds秒';
  }

  @override
  String elapsedHoursMinutesSeconds(int hours, int minutes, int seconds) {
    return '$hours小时 $minutes分 $seconds秒';
  }

  @override
  String get next => '下一步';

  @override
  String get done => '完成';

  @override
  String get giveUpTitle => '要离开这道谜题吗？';

  @override
  String get giveUpMessage => '当前进度会保存在“继续游戏”里。';

  @override
  String get keepPlaying => '继续解';

  @override
  String get exitPuzzle => '离开';

  @override
  String get giveUpTooltip => '放弃并离开';

  @override
  String get pauseTooltip => '暂停';

  @override
  String get retryTooltip => '重玩';

  @override
  String get autoCompleteTooltip => '自动完成';

  @override
  String get memoInput => '笔记输入';

  @override
  String get numberInput => '数字输入';

  @override
  String get delete => '清除';

  @override
  String get memo => '笔记';

  @override
  String get memoOn => '笔记 ON';

  @override
  String hintCount(int count) {
    return '提示 $count';
  }

  @override
  String get undo => '撤销';

  @override
  String get selectCellFirst => '请先选择一个格子';

  @override
  String get fixedCell => '这是题目给出的数字';

  @override
  String get selectHintCell => '请先选择要看提示的格子';

  @override
  String get hintUnavailable => '这个格子不能使用提示';

  @override
  String get skip => '跳过';

  @override
  String get lightFirstWindow => '点亮第一扇窗';

  @override
  String get openingHeadline0 => '沉睡的村庄';

  @override
  String get openingBody0 => '星光村已经夜里很久了。\n窗户熄灭，巷弄也很安静。';

  @override
  String get openingHeadline1 => '窗里的光';

  @override
  String get openingBody1 => '每一盘谜题，就是一扇窗。\n每填好一格，村里就会多一点光。';

  @override
  String get openingHeadline2 => '清晨到来时';

  @override
  String get openingBody2 => '星光汇聚，天空就会亮起来。\n沉睡的面包店、图书馆和喷泉广场会再次醒来。';

  @override
  String get difficultySelect => '选择难度';

  @override
  String get difficultyLead => '要先点亮哪条巷子的窗户？';

  @override
  String get difficultySub => '选好路之后，就会打开那座村庄的关卡。';

  @override
  String get difficultyEasy => '简单';

  @override
  String get difficultyNormal => '普通';

  @override
  String get difficultyHard => '困难';

  @override
  String get difficultyBlurbEasy => '巷子里第一扇窗亮起的路';

  @override
  String get difficultyBlurbNormal => '越过山丘灯光相连的路';

  @override
  String get difficultyBlurbHard => '仍在沉睡的村庄之路';

  @override
  String get stages => '关卡';

  @override
  String get starlight => '星光';

  @override
  String stagesCleared(int completed, int total) {
    return '$completed/$total 已通关';
  }

  @override
  String get previousStageFirst => '请先完成上一关';

  @override
  String get preparingPuzzle => '正在准备谜题';

  @override
  String stageTitle(String difficulty) {
    return '$difficulty 关卡';
  }

  @override
  String get morningComes => '通关越多，村里的清晨就越近。';

  @override
  String get villageTitle => '星光村';

  @override
  String get mission => '任务';

  @override
  String restoredCount(int completed, int total) {
    return '已修复 $completed / $total';
  }

  @override
  String ownedStarlight(int amount) {
    return '持有星光  $amount';
  }

  @override
  String restorationLevel(int level) {
    return '修复阶段 $level / 5';
  }

  @override
  String needsMoreStarlight(int amount) {
    return '还需要 $amount StarLight。';
  }

  @override
  String get harborUnlockTitle => '解锁月光港';

  @override
  String get harborUnlockBody => '星光村重新亮了起来。下一个故事，会在海风吹拂的月光港继续。';

  @override
  String get towardHarbor => '前往港口';

  @override
  String get nextVillage => '下一座村庄：月光港';

  @override
  String get newStoryOpened => '新的故事已经开启。';

  @override
  String get harborStoryTooltip => '查看月光港的故事';

  @override
  String get missionsTitle => '修复任务';

  @override
  String get missionsLead => '解开谜题就能收集星光，窗户会再次亮起。';

  @override
  String currentStarlight(int amount) {
    return '当前星光  $amount';
  }

  @override
  String get restorationComplete => '修复完成';

  @override
  String starlightRemaining(int amount) {
    return '还差 $amount 星光';
  }

  @override
  String get buildingBakery => '面包店';

  @override
  String get buildingLibrary => '图书馆';

  @override
  String get buildingFountain => '喷泉广场';

  @override
  String get bakeryHeadline => '第一簇温暖的光';

  @override
  String get bakeryDescription => '老面包店的烤炉正在等待星光。';

  @override
  String get bakeryCompleted => '烤炉亮了。巷子里飘着刚出炉的面包香。';

  @override
  String get libraryHeadline => '沉睡的故事';

  @override
  String get libraryDescription => '积满灰尘的图书馆书籍，等待再次被翻开。';

  @override
  String get libraryCompleted => '书架亮了。村庄的故事继续往下写。';

  @override
  String get fountainHeadline => '回到广场的歌声';

  @override
  String get fountainDescription => '干涸的喷泉广场，离人们的笑声已经不远了。';

  @override
  String get fountainCompleted => '喷泉再次流动。村庄的中心明亮起来。';

  @override
  String get villageVista => '星光村景色';

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
    return '$name，修复 $level';
  }
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => '星光數獨';

  @override
  String get startNewPuzzle => '新的謎題';

  @override
  String get continueGame => '繼續遊戲';

  @override
  String get viewVillage => '查看村莊';

  @override
  String get copyright => '© Tyche Spark. All rights reserved';

  @override
  String get puzzleComplete => '謎題完成！';

  @override
  String get starlightArrived => '星光已經抵達村莊。';

  @override
  String get alreadyCleared => '這一關已經通關過了。';

  @override
  String elapsedTime(String time) {
    return '用時  $time';
  }

  @override
  String elapsedMinutesSeconds(int minutes, int seconds) {
    return '$minutes分 $seconds秒';
  }

  @override
  String elapsedHoursMinutesSeconds(int hours, int minutes, int seconds) {
    return '$hours小時 $minutes分 $seconds秒';
  }

  @override
  String get next => '下一步';

  @override
  String get done => '完成';

  @override
  String get giveUpTitle => '要離開這道謎題嗎？';

  @override
  String get giveUpMessage => '目前進度會保存在「繼續遊戲」裡。';

  @override
  String get keepPlaying => '繼續解';

  @override
  String get exitPuzzle => '離開';

  @override
  String get giveUpTooltip => '放棄並離開';

  @override
  String get pauseTooltip => '暫停';

  @override
  String get retryTooltip => '重玩';

  @override
  String get autoCompleteTooltip => '自動完成';

  @override
  String get memoInput => '筆記輸入';

  @override
  String get numberInput => '數字輸入';

  @override
  String get delete => '清除';

  @override
  String get memo => '筆記';

  @override
  String get memoOn => '筆記 ON';

  @override
  String hintCount(int count) {
    return '提示 $count';
  }

  @override
  String get undo => '復原';

  @override
  String get selectCellFirst => '請先選擇一個格子';

  @override
  String get fixedCell => '這是題目給定的數字';

  @override
  String get selectHintCell => '請先選擇要看提示的格子';

  @override
  String get hintUnavailable => '這個格子不能使用提示';

  @override
  String get skip => '跳過';

  @override
  String get lightFirstWindow => '點亮第一扇窗';

  @override
  String get openingHeadline0 => '沉睡的村莊';

  @override
  String get openingBody0 => '星光村已經夜裡很久了。\n窗戶熄滅，巷弄也很安靜。';

  @override
  String get openingHeadline1 => '窗裡的光';

  @override
  String get openingBody1 => '每一盤謎題，就是一扇窗。\n每填好一格，村裡就會多一點光。';

  @override
  String get openingHeadline2 => '清晨到來時';

  @override
  String get openingBody2 => '星光匯聚，天空就會亮起來。\n沉睡的麵包店、圖書館和噴泉廣場會再次醒來。';

  @override
  String get difficultySelect => '選擇難度';

  @override
  String get difficultyLead => '要先點亮哪條巷子的窗戶？';

  @override
  String get difficultySub => '選好路之後，就會打開那座村莊的關卡。';

  @override
  String get difficultyEasy => '簡單';

  @override
  String get difficultyNormal => '普通';

  @override
  String get difficultyHard => '困難';

  @override
  String get difficultyBlurbEasy => '巷子裡第一扇窗亮起的路';

  @override
  String get difficultyBlurbNormal => '越過山丘燈光相連的路';

  @override
  String get difficultyBlurbHard => '仍在沉睡的村莊之路';

  @override
  String get stages => '關卡';

  @override
  String get starlight => '星光';

  @override
  String stagesCleared(int completed, int total) {
    return '$completed/$total 已通關';
  }

  @override
  String get previousStageFirst => '請先完成上一關';

  @override
  String get preparingPuzzle => '正在準備謎題';

  @override
  String stageTitle(String difficulty) {
    return '$difficulty 關卡';
  }

  @override
  String get morningComes => '通關越多，村裡的清晨就越近。';

  @override
  String get villageTitle => '星光村';

  @override
  String get mission => '任務';

  @override
  String restoredCount(int completed, int total) {
    return '已修復 $completed / $total';
  }

  @override
  String ownedStarlight(int amount) {
    return '持有星光  $amount';
  }

  @override
  String restorationLevel(int level) {
    return '修復階段 $level / 5';
  }

  @override
  String needsMoreStarlight(int amount) {
    return '還需要 $amount StarLight。';
  }

  @override
  String get harborUnlockTitle => '解鎖月光港';

  @override
  String get harborUnlockBody => '星光村重新亮了起來。下一個故事，會在海風吹拂的月光港繼續。';

  @override
  String get towardHarbor => '前往港口';

  @override
  String get nextVillage => '下一座村莊：月光港';

  @override
  String get newStoryOpened => '新的故事已經開啟。';

  @override
  String get harborStoryTooltip => '查看月光港的故事';

  @override
  String get missionsTitle => '修復任務';

  @override
  String get missionsLead => '解開謎題就能收集星光，窗戶會再次亮起。';

  @override
  String currentStarlight(int amount) {
    return '目前星光  $amount';
  }

  @override
  String get restorationComplete => '修復完成';

  @override
  String starlightRemaining(int amount) {
    return '還差 $amount 星光';
  }

  @override
  String get buildingBakery => '麵包店';

  @override
  String get buildingLibrary => '圖書館';

  @override
  String get buildingFountain => '噴泉廣場';

  @override
  String get bakeryHeadline => '第一簇溫暖的光';

  @override
  String get bakeryDescription => '老麵包店的烤爐正在等待星光。';

  @override
  String get bakeryCompleted => '烤爐亮了。巷子裡飄著剛出爐的麵包香。';

  @override
  String get libraryHeadline => '沉睡的故事';

  @override
  String get libraryDescription => '積滿灰塵的圖書館書籍，等待再次被翻開。';

  @override
  String get libraryCompleted => '書架亮了。村莊的故事繼續往下寫。';

  @override
  String get fountainHeadline => '回到廣場的歌聲';

  @override
  String get fountainDescription => '乾涸的噴泉廣場，離人們的笑聲已經不遠了。';

  @override
  String get fountainCompleted => '噴泉再次流動。村莊的中心明亮起來。';

  @override
  String get villageVista => '星光村景色';

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
    return '$name，修復 $level';
  }
}
