# 별빛 스도쿠

스도쿠 퍼즐을 풀어 StarLight를 모으고 작은 마을을 복원하는 Flutter 퍼즐 게임입니다.

## 현재 기능

- Easy, Normal, Hard 난이도의 유일해 스도쿠 생성
- 메모, 힌트 제한 및 실행 취소
- StarLight 보상, 마을 복원, 건물 스토리
- 진행 중 퍼즐, 통계, 마을 진행도 로컬 저장

## 개발 실행

```powershell
flutter pub get
flutter test
flutter run -d <device-id>
```

## Android 출시 준비

앱 ID는 `com.softcastella.sudoku_game`이며 Android 7.0(API 24) 이상을 지원합니다.

출시용 AAB를 만들기 전 다음을 준비해야 합니다.

1. Android Studio SDK Manager에서 Android SDK Command-line Tools를 설치합니다.
2. `flutter doctor --android-licenses`를 실행해 라이선스를 승인합니다.
3. 비공개 keystore를 만들고 `android/key.properties`에 서명 정보를 설정합니다.
4. `flutter build appbundle --release`로 Play Store용 AAB를 생성합니다.

디버그 APK는 개발 환경이 준비된 뒤 `flutter build apk --debug`로 만들 수 있습니다.
