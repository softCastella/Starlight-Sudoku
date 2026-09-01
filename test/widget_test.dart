import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/presentation/app.dart';

void main() {
  testWidgets('App launches and shows home screen', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const SudokuApp());

    // Verify that home screen appears
    expect(find.text('TYCHE SPARK'), findsOneWidget);
    expect(find.text('별빛 스도쿠'), findsOneWidget);
    expect(find.text('새 퍼즐 시작'), findsOneWidget);

    // Tap the start button
    await tester.ensureVisible(find.text('새 퍼즐 시작'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('새 퍼즐 시작'));
    await tester.pumpAndSettle();

    // Verify difficulty selection screen appears
    expect(find.text('난이도 선택'), findsOneWidget);
  });
}
