import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/presentation/app.dart';
import 'package:sudoku_game/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('App launches splash then title screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SudokuApp());

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.image(const AssetImage(SplashScreen.logoAsset)), findsOneWidget);

    await tester.pump(SplashScreen.displayDuration);
    await tester.pumpAndSettle();

    expect(find.text('TYCHE SPARK'), findsNothing);
    expect(find.text('별빛 스도쿠'), findsOneWidget);
    expect(find.text('새 퍼즐 시작'), findsOneWidget);

    await tester.ensureVisible(find.text('새 퍼즐 시작'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('새 퍼즐 시작'));
    await tester.pumpAndSettle();

    expect(find.text('난이도 선택'), findsOneWidget);
  });
}
