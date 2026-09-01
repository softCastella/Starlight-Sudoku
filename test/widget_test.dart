import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/presentation/app.dart';

void main() {
  testWidgets('App launches and shows home screen', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const SudokuApp());

    // Verify that home screen appears
    expect(find.text('Sudoku'), findsOneWidget);
    expect(find.text('Cozy Puzzle Game'), findsOneWidget);
    expect(find.text('게임 시작'), findsOneWidget);

    // Tap the start button
    await tester.tap(find.text('게임 시작'));
    await tester.pumpAndSettle();

    // Verify difficulty selection screen appears
    expect(find.text('난이도 선택'), findsOneWidget);
  });
}
