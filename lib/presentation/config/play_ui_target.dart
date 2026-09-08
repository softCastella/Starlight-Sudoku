/// Parchment / oval UI the in-app editor can target.
enum PlayUiTarget {
  common,
  titleButton,
  openingButton,
  villageButton,
  bgmGate,
  settings,
  credits,
  exitGame,
  giveUp,
  completionReward,
  trialEnd;

  String get id => name;

  String get labelKo => switch (this) {
        PlayUiTarget.common => '공통',
        PlayUiTarget.titleButton => '타이틀 버튼',
        PlayUiTarget.openingButton => '인트로 버튼',
        PlayUiTarget.villageButton => '마을 버튼',
        PlayUiTarget.bgmGate => 'BGM 버튼',
        PlayUiTarget.settings => '설정',
        PlayUiTarget.credits => '크레딧',
        PlayUiTarget.exitGame => '게임 종료',
        PlayUiTarget.giveUp => '퍼즐 포기',
        PlayUiTarget.completionReward => '완료 보상',
        PlayUiTarget.trialEnd => '체험판 종료',
      };

  bool get editsButtons => this != PlayUiTarget.common;

  bool get editsModal => switch (this) {
        PlayUiTarget.settings ||
        PlayUiTarget.credits ||
        PlayUiTarget.exitGame ||
        PlayUiTarget.giveUp ||
        PlayUiTarget.completionReward ||
        PlayUiTarget.trialEnd =>
          true,
        _ => false,
      };

  bool get usesParchmentButton => this == PlayUiTarget.titleButton;

  bool get usesOvalButton =>
      this == PlayUiTarget.openingButton ||
      this == PlayUiTarget.villageButton ||
      this == PlayUiTarget.bgmGate ||
      editsModal;

  static PlayUiTarget? tryParse(String id) {
    if (id == 'ovalButton') return PlayUiTarget.titleButton;
    for (final value in values) {
      if (value.name == id) return value;
    }
    return null;
  }
}
