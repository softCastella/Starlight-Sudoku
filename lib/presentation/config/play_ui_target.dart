/// Parchment / oval UI the in-app editor can target.
enum PlayUiTarget {
  common,
  settings,
  credits,
  exitGame,
  giveUp,
  completionReward,
  trialEnd,
  ovalButton;

  String get id => name;

  String get labelKo => switch (this) {
        PlayUiTarget.common => '공통',
        PlayUiTarget.settings => '설정',
        PlayUiTarget.credits => '크레딧',
        PlayUiTarget.exitGame => '게임 종료',
        PlayUiTarget.giveUp => '퍼즐 포기',
        PlayUiTarget.completionReward => '완료 보상',
        PlayUiTarget.trialEnd => '체험판 종료',
        PlayUiTarget.ovalButton => '타원 버튼',
      };

  static PlayUiTarget? tryParse(String id) {
    for (final value in values) {
      if (value.name == id) return value;
    }
    return null;
  }
}
