# GitHub Pages 공개 배포

## 공개 링크

배포가 완료되면 아래 주소에서 별빛 스도쿠를 실행할 수 있습니다.

- https://softcastella.github.io/Starlight-Sudoku/

## 사용 방법

1. 위 링크를 휴대폰 또는 PC 브라우저에서 연다.
2. `새 퍼즐 시작`을 선택한다.
3. 난이도를 고르고 퍼즐을 플레이한다.
4. 마을 보기에서 StarLight와 복원 진행도를 확인한다.

## 배포 방식

- 저장소: `softCastella/Starlight-Sudoku`
- 호스팅: GitHub Pages
- 배포 대상: `pages` 브랜치 (체험판 웹 데모)
- 자동화: `.github/workflows/deploy-pages.yml`

`pages`에 변경을 푸시하면 GitHub Actions가 Flutter 웹 릴리스를 빌드하고 GitHub Pages에 자동 배포한다. `main`은 APK 작업용이며, `main` 푸시로는 Pages가 갱신되지 않는다. 공개 웹을 바꿀 때만 `pages`에 올린다.

개발은 `main`에서 한다. `pages`는 웹 데모 스냅샷이다. `sample-v1`은 읽기 전용 그대로.

## 배포 후 확인

1. GitHub 저장소의 Actions 탭에서 `Deploy Flutter web to GitHub Pages` 실행이 성공했는지 확인한다.
2. 위 공개 링크를 새 시크릿 창에서 열어 캐시 영향 없이 확인한다.
3. 홈 화면, 난이도 선택, 보드 입력, 마을 보기 흐름을 점검한다.

## 참고

- `localhost` 주소는 개발 중인 본인 컴퓨터에서만 열 수 있다.
- 공개 링크는 설치 없이 사용할 수 있는 웹 버전이다.
- Android APK/AAB 배포는 GitHub Pages와 별도의 출시 절차가 필요하다.
