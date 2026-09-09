import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/l10n/app_localizations.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';
import 'package:sudoku_game/presentation/screens/play_ui_tune_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PlayUiTune.instance.reset();
    PlayUiTune.instance.resetEditorChrome();
    PlayUiTune.instance.setEditingTarget(PlayUiTarget.titleButton);
  });

  testWidgets('editor shows a live preview above button sliders', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('ko'),
        home: PlayUiTuneScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tune-preview')), findsOneWidget);
    expect(find.text('새 퍼즐 시작'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('새 퍼즐 시작')).style?.fontSize,
      15,
    );

    final thumb = find.byKey(const Key('tune-thumb-button'));
    expect(thumb, findsOneWidget);
    expect(tester.getSize(thumb), const Size(22, 22));

    final preview = tester.getRect(find.byKey(const Key('tune-preview')));
    final slider = tester.getRect(thumb);
    expect(preview.bottom, lessThanOrEqualTo(slider.top + 1));
    expect(preview.height, greaterThan(120));

    await tester.ensureVisible(find.byKey(const Key('tune-target-giveUp')));
    await tester.tap(find.byKey(const Key('tune-target-giveUp')));
    await tester.pumpAndSettle();
    expect(PlayUiTune.instance.editingTarget, PlayUiTarget.giveUp);
    expect(find.byKey(const Key('tune-thumb-button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('tune-locale-en')));
    await tester.pumpAndSettle();
    expect(PlayUiTune.instance.editingLocale, 'en');
  });

  testWidgets('button width and modal title sliders change the preview', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('ko'),
        home: PlayUiTuneScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final before = tester.getSize(find.byKey(const Key('parchment-button-chrome')).first);
    PlayUiTune.instance.setField('buttonMaxWidth', 260);
    await tester.pumpAndSettle();
    final after = tester.getSize(find.byKey(const Key('parchment-button-chrome')).first);
    expect(after.width, greaterThan(before.width + 20));

    await tester.ensureVisible(find.byKey(const Key('tune-target-giveUp')));
    await tester.tap(find.byKey(const Key('tune-target-giveUp')));
    await tester.pumpAndSettle();
    PlayUiTune.instance.setField('title', 26);
    await tester.pumpAndSettle();
    final title = tester.widget<Text>(find.text('퍼즐을 나갈까요?'));
    expect(title.style?.fontSize, 26);
  });

  testWidgets('parchment label stays inside the scroll', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('ko'),
        home: PlayUiTuneScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final chrome =
        tester.getRect(find.byKey(const Key('parchment-button-chrome')).first);
    final label = tester.getRect(find.text('새 퍼즐 시작'));
    expect(label.center.dy, closeTo(chrome.center.dy, 8));
    expect(label.top, greaterThanOrEqualTo(chrome.top - 0.5));
    expect(label.bottom, lessThanOrEqualTo(chrome.bottom + 0.5));
  });

  testWidgets('English intro button font follows the 11 slider', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('ko'),
        home: PlayUiTuneScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('tune-target-openingButton')));
    await tester.tap(find.byKey(const Key('tune-target-openingButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tune-locale-en')));
    await tester.pumpAndSettle();

    final atDefault = tester.widget<Text>(find.text('Light the first window'));
    expect(atDefault.style?.fontSize, 11);

    PlayUiTune.instance.setField('button', 22);
    await tester.pumpAndSettle();
    final raised = tester.widget<Text>(find.text('Light the first window'));
    expect(raised.style?.fontSize, 22);
  });
}
