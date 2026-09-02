import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/presentation/app.dart';
import 'package:sudoku_game/presentation/config/app_fonts.dart';
import 'package:sudoku_game/presentation/config/title_art.dart';
import 'package:sudoku_game/presentation/screens/home_screen.dart';
import 'package:sudoku_game/presentation/screens/splash_screen.dart';
import 'package:sudoku_game/presentation/screens/village_screen.dart';

Finder _assetImage(String assetName) {
  bool matches(ImageProvider image) {
    if (image is AssetImage) return image.assetName == assetName;
    if (image is ResizeImage) return matches(image.imageProvider);
    return false;
  }

  return find.byWidgetPredicate((widget) {
    return widget is Image && matches(widget.image);
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('bundled CJK fonts preload from the font manifest', (
    WidgetTester tester,
  ) async {
    await AppFonts.preload();
  });

  testWidgets('App launches splash then title screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SudokuApp(locale: Locale('ko')));
    await tester.pump();
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.image(const AssetImage(SplashScreen.logoAsset)), findsOneWidget);

    await tester.pump(SplashScreen.displayDuration);
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsWidgets);
    expect(_assetImage(TitleArt.korean), findsWidgets);
    expect(find.text('새 퍼즐 시작'), findsOneWidget);

    await tester.ensureVisible(find.text('새 퍼즐 시작'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('새 퍼즐 시작'));
    await tester.pumpAndSettle();

    expect(find.text('잠든 마을'), findsOneWidget);
    await tester.tap(find.text('건너뛰기'));
    await tester.pumpAndSettle();

    expect(find.text('난이도 선택'), findsOneWidget);
    expect(find.textContaining('스테이지'), findsWidgets);

    await tester.tap(find.text('쉬움 · Easy'));
    await tester.pumpAndSettle();

    expect(find.text('쉬움 스테이지'), findsOneWidget);
    expect(find.text('0/20 클리어'), findsOneWidget);
  });

  testWidgets('English locale shows English title art and home buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SudokuApp(locale: Locale('en')));
    await tester.pump();
    await tester.pump();

    await tester.pump(SplashScreen.displayDuration);
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsWidgets);
    expect(_assetImage(TitleArt.english), findsWidgets);
    expect(find.text('New puzzle'), findsOneWidget);
    expect(find.text('Village'), findsOneWidget);
  });

  testWidgets('Traditional Chinese uses the TW title painting', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SudokuApp(locale: Locale('zh', 'TW')));
    await tester.pump();
    await tester.pump();

    await tester.pump(SplashScreen.displayDuration);
    await tester.pumpAndSettle();

    expect(_assetImage(TitleArt.chineseTraditional), findsWidgets);
    expect(find.text('新的謎題'), findsOneWidget);
  });

  testWidgets('title locale dropdown switches title art and buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SudokuApp(locale: Locale('ko')));
    await tester.pump();
    await tester.pump();
    await tester.pump(SplashScreen.displayDuration);
    await tester.pumpAndSettle();

    expect(find.text('새 퍼즐 시작'), findsOneWidget);

    await tester.tap(find.byKey(const Key('locale-debug-menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();

    expect(find.text('New puzzle'), findsOneWidget);
    expect(_assetImage(TitleArt.english), findsWidgets);
  });

  testWidgets('system back returns from village to title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SudokuApp(locale: Locale('ko')));
    await tester.pump();
    await tester.pump();
    await tester.pump(SplashScreen.displayDuration);
    await tester.pumpAndSettle();

    await tester.tap(find.text('마을 보기'));
    await tester.pumpAndSettle();
    expect(find.byType(VillageScreen), findsOneWidget);

    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();

    expect(find.byType(VillageScreen), findsNothing);
    expect(find.text('새 퍼즐 시작'), findsOneWidget);
  });

  testWidgets('system back returns from opening story to title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SudokuApp(locale: Locale('ko')));
    await tester.pump();
    await tester.pump();
    await tester.pump(SplashScreen.displayDuration);
    await tester.pumpAndSettle();

    await tester.tap(find.text('새 퍼즐 시작'));
    await tester.pumpAndSettle();
    expect(find.text('잠든 마을'), findsOneWidget);

    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();

    expect(find.text('잠든 마을'), findsNothing);
    expect(find.text('새 퍼즐 시작'), findsOneWidget);
  });
}
