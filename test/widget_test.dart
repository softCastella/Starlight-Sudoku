import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/presentation/app.dart';
import 'package:sudoku_game/presentation/screens/home_screen.dart';
import 'package:sudoku_game/presentation/screens/splash_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App launches splash then title screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SudokuApp());
    await tester.pump();
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.image(const AssetImage(SplashScreen.logoAsset)), findsOneWidget);

    await tester.pump(SplashScreen.displayDuration);
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsWidgets);
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
}
