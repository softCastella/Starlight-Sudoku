# 별빛 스도쿠

스도쿠를 풀면 StarLight를 모아 작은 마을을 복원하는 Flutter 퍼즐 게임입니다.

- 제품 라인: Tyche Spark
- 개발사: Tyche works
- 앱 ID: `com.softcastella.sudoku_game`
- 웹 플레이: https://softcastella.github.io/Starlight-Sudoku/

## 프로젝트 개요

플레이어는 Easy, Normal, Hard 난이도를 고른 뒤 스테이지를 순서대로 풉니다. 퍼즐을 완료하면 StarLight를 받고, 그 보상으로 빵집, 도서관, 분수 광장을 차례로 복원합니다. 각 건물에는 짧은 스토리가 있고, 첫 마을을 모두 복원하면 다음 에피소드인 달빛 항구 해금 안내가 나타납니다.

현재 PHASE 1~9(코어 엔진, UI, 마을, 저장, 이어하기, 보상 연출, 힌트/실행 취소, 스토리)는 완료되어 있습니다. PHASE 10은 Android 출시 준비 단계입니다.

## 현재 기능

- Easy 20 / Normal 40 / Hard 50 스테이지
- 난이도별 유일해 퍼즐 생성 (같은 스테이지는 같은 퍼즐)
- 앞 스테이지를 완료해야 다음 스테이지 해금, 클리어한 스테이지는 다시 플레이 가능
- 메모, 힌트 3회, 힌트당 StarLight 10 감점, 실행 취소
- 첫 클리어 StarLight 보상, 마을 복원, 건물 스토리
- 진행 중 퍼즐 이어하기, 플레이 통계, 마을 진행도 로컬 저장
- GitHub Pages 웹 배포

난이도별 StarLight 보상은 Easy 80, Normal 120, Hard 180입니다.

## 화면 흐름

스플래시 → 홈 → 난이도 선택 → 스테이지 선택 → 게임 / 마을

홈에서 새 퍼즐을 시작하거나 저장된 퍼즐을 이어할 수 있고, 마을 보기에서 StarLight와 복원 진행도를 확인합니다.

## 아키텍처

| 계층 | 경로 | 역할 |
| --- | --- | --- |
| Core | `lib/core/` | UI 없는 순수 Dart. 보드, 검증, 솔버, 생성기, 난이도, 밸런스, 마을/진행도 |
| Data | `lib/data/` | `shared_preferences`로 StarLight, 통계, 진행 중 퍼즐 저장 |
| Presentation | `lib/presentation/` | 화면, 위젯, Provider 기반 `GameNotifier` |

퍼즐과 정답은 `SudokuGenerator.generatePuzzleWithSolution()`으로 한 쌍으로 생성합니다. 따로 만들면 3x3 중복이나 완료 판정 실패가 발생할 수 있습니다.

## 기술 스택

- Flutter 3.47.2 / Dart 3.13.2
- 상태 관리: Provider + `GameNotifier`
- 로컬 저장: shared_preferences
- Android 7.0+(API 24)+, 세로 방향 고정

## 개발 실행

```powershell
flutter pub get
flutter test
flutter run -d <device-id>
```

`main` 브랜치에 푸시하면 GitHub Actions가 Flutter 웹 릴리스를 빌드하고 GitHub Pages에 배포합니다.

## Android 출시 준비

앱 ID는 `com.softcastella.sudoku_game`이며 Android 7.0(API 24) 이상을 지원합니다.

출시용 AAB를 만들기 전 다음을 준비해야 합니다.

1. Android Studio SDK Manager에서 Android SDK Command-line Tools를 설치합니다.
2. `flutter doctor --android-licenses`를 실행해 라이선스를 승인합니다.
3. 비공개 keystore를 만들고 `android/key.properties`에 서명 정보를 설정합니다.
4. `flutter build appbundle --release`로 Play Store용 AAB를 생성합니다.

디버그 APK는 개발 환경이 준비된 뒤 `flutter build apk --debug`로 만들 수 있습니다.

## 다음 작업

- Android 실기기에서 스플래시와 게임 흐름 확인
- APK/AAB 또는 내부 테스트 배포
- 앱 아이콘에 Tyche Spark 로고 적용 여부 결정
- 달빛 항구 실제 지도와 콘텐츠 구현
