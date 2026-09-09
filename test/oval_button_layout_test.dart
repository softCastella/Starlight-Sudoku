import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/l10n/app_localizations.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';
import 'package:sudoku_game/presentation/widgets/oval_image_button.dart';
import 'package:sudoku_game/presentation/widgets/parchment_modal.dart';
import 'package:sudoku_game/presentation/widgets/give_up_puzzle_dialog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PlayUiTune.instance.reset();
    PlayUiTune.instance.resetEditorChrome();
    PlayUiTune.instance.setEditingTarget(PlayUiTarget.openingButton);
    PlayUiTune.instance.setEditingLocale('en');
  });

  test('short label keeps the button token and uses the width slider', () {
    final layout = OvalButtonLayout.forLabel(
      '닫기',
      direction: TextDirection.ltr,
    );
    expect(layout.fontSize, PlayUi.button);
    expect(layout.width, PlayUi.buttonMaxWidth);
    expect(layout.height, layout.width / PlayUi.ovalAspect * PlayUi.buttonHeightScale);
    expect(layout.sideInset, closeTo(layout.width * PlayUi.ovalEndFraction, 0.01));
  });

  test('width slider sets oval width for a short label', () {
    final layout = OvalButtonLayout.forLabel(
      '닫기',
      direction: TextDirection.ltr,
      maxWidth: 180,
    );
    expect(layout.width, 180);
  });

  test('raising the font does not grow the oval', () {
    const label = '닫기';
    final small = OvalButtonLayout.forLabel(
      label,
      direction: TextDirection.ltr,
      preferredFontSize: 11,
    );
    final large = OvalButtonLayout.forLabel(
      label,
      direction: TextDirection.ltr,
      preferredFontSize: 22,
    );
    expect(large.width, small.width);
    expect(large.height, small.height);
    expect(large.fontSize, 22);
    expect(small.fontSize, 11);
  });

  test('long English keeps the font slider, not the oval-end inset', () {
    const label = 'Light the first window';
    final small = OvalButtonLayout.forLabel(
      label,
      direction: TextDirection.ltr,
      preferredFontSize: 11,
    );
    final large = OvalButtonLayout.forLabel(
      label,
      direction: TextDirection.ltr,
      preferredFontSize: 22,
    );
    expect(large.width, small.width);
    expect(small.fontSize, 11);
    expect(large.fontSize, 22);
  });

  test('oval end fraction does not change English font size', () {
    final tune = PlayUiTune.instance;
    tune.setField('button', 22);
    late double insetLoose;
    late double insetTight;
    late double fontLoose;
    late double fontTight;
    PlayUi.using(PlayUiTarget.openingButton, () {
      tune.setField('ovalEndFraction', 0.10);
      final loose = OvalButtonLayout.forLabel(
        'Light the first window',
        direction: TextDirection.ltr,
        preferredFontSize: PlayUi.button,
      );
      insetLoose = loose.sideInset;
      fontLoose = loose.fontSize;
      tune.setField('ovalEndFraction', 0.28);
      final tight = OvalButtonLayout.forLabel(
        'Light the first window',
        direction: TextDirection.ltr,
        preferredFontSize: PlayUi.button,
      );
      insetTight = tight.sideInset;
      fontTight = tight.fontSize;
    }, locale: const Locale('en'));
    expect(fontLoose, 22);
    expect(fontTight, 22);
    expect(insetTight, greaterThan(insetLoose));
  });

  test('parent narrower than min width does not overflow it', () {
    final layout = OvalButtonLayout.forLabel(
      'Next',
      direction: TextDirection.ltr,
      maxWidth: 80,
    );
    expect(layout.width, 80);
    expect(layout.fontSize, PlayUi.button);
  });

  testWidgets('opening ovals stay skinny and keep 11px inside the chrome', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    PlayUiTune.instance.setEditingLocale('ko');
    PlayUiTune.instance.setEditingTarget(PlayUiTarget.openingButton);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ko'),
        home: PlayUiScope(
          target: PlayUiTarget.openingButton,
          localeId: 'ko',
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OvalImageButton(
                    key: const Key('opening-next'),
                    label: '다음',
                    target: PlayUiTarget.openingButton,
                    width: 80,
                    expandToFitLabel: true,
                    onPressed: () {},
                  ),
                  OvalImageButton(
                    key: const Key('opening-last'),
                    label: '첫 창문을 밝히기',
                    target: PlayUiTarget.openingButton,
                    width: 80,
                    expandToFitLabel: true,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final next = tester.getSize(find.byKey(const Key('opening-next')));
    final last = tester.getSize(find.byKey(const Key('opening-last')));
    final skinny = 80 / PlayUi.ovalAspect;
    expect(next.height, closeTo(skinny, 0.5));
    expect(last.height, closeTo(next.height, 0.5));
    expect(last.width, greaterThan(next.width + 20));
    PlayUi.using(PlayUiTarget.openingButton, () {
      final chipHeight =
          (PlayUi.buttonMaxWidth / PlayUi.ovalAspect) * PlayUi.buttonHeightScale;
      expect(next.height, lessThan(chipHeight - 8));
    }, locale: const Locale('ko'));

    final nextLabel = tester.getRect(find.text('다음'));
    final lastLabel = tester.getRect(find.text('첫 창문을 밝히기'));
    final nextChrome = tester.getRect(find.byKey(const Key('opening-next')));
    final lastChrome = tester.getRect(find.byKey(const Key('opening-last')));
    expect(tester.widget<Text>(find.text('다음')).style?.fontSize, 11);
    expect(
      tester.widget<Text>(find.text('첫 창문을 밝히기')).style?.fontSize,
      tester.widget<Text>(find.text('다음')).style?.fontSize,
    );
    expect(lastLabel.height, closeTo(nextLabel.height, 1));
    expect(nextLabel.center.dy, closeTo(nextChrome.center.dy, 4));
    expect(lastLabel.center.dy, closeTo(lastChrome.center.dy, 4));
    expect(nextLabel.top, greaterThanOrEqualTo(nextChrome.top - 0.5));
    expect(nextLabel.bottom, lessThanOrEqualTo(nextChrome.bottom + 0.5));
    expect(lastLabel.top, greaterThanOrEqualTo(lastChrome.top - 0.5));
    expect(lastLabel.bottom, lessThanOrEqualTo(lastChrome.bottom + 0.5));
    expect(lastLabel.height, lessThan(20));
    expect(find.text('첫 창문을 밝히기'), findsOneWidget);
    expect(last.width, greaterThan(100));
    PlayUi.using(PlayUiTarget.openingButton, () {
      final end = 80 * PlayUi.ovalEndFraction;
      expect(lastLabel.left, greaterThanOrEqualTo(lastChrome.left + end - 1));
      expect(lastLabel.right, lessThanOrEqualTo(lastChrome.right - end + 1));
    }, locale: const Locale('ko'));
    for (final image in tester.widgetList<Image>(
      find.descendant(
        of: find.byKey(const Key('opening-last')),
        matching: find.byType(Image),
      ),
    )) {
      expect(image.centerSlice, isNull);
    }
  });

  testWidgets('modal close oval matches intro compact height', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    PlayUiTune.instance.setEditingLocale('ko');
    PlayUiTune.instance.setEditingTarget(PlayUiTarget.settings);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ko'),
        home: PlayUiScope(
          target: PlayUiTarget.settings,
          localeId: 'ko',
          child: Center(
            child: ParchmentModalButton(
              key: const Key('modal-close'),
              asset: ParchmentModal.continueAsset,
              label: '닫기',
              color: PlayUi.ink,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final close = tester.getSize(find.byType(OvalImageButton));
    final skinny = PlayUi.kOvalCompactWidth / PlayUi.ovalAspect;
    expect(close.height, closeTo(skinny, 0.5));
    expect(close.width, closeTo(PlayUi.kOvalCompactWidth, 1));
    expect(tester.widget<Text>(find.text('닫기')).style?.fontSize, 11);
  });

  testWidgets('village mission oval matches intro compact height', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    PlayUiTune.instance.setEditingLocale('ko');
    PlayUiTune.instance.setEditingTarget(PlayUiTarget.villageButton);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ko'),
        home: PlayUiScope(
          target: PlayUiTarget.villageButton,
          localeId: 'ko',
          child: Center(
            child: OvalImageButton(
              key: const Key('village-mission'),
              label: '미션',
              target: PlayUiTarget.villageButton,
              width: PlayUi.kOvalCompactWidth,
              expandToFitLabel: true,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final mission = tester.getSize(find.byKey(const Key('village-mission')));
    final skinny = PlayUi.kOvalCompactWidth / PlayUi.ovalAspect;
    expect(mission.height, closeTo(skinny, 0.5));
    expect(mission.width, closeTo(PlayUi.kOvalCompactWidth, 1));
    expect(tester.widget<Text>(find.text('미션')).style?.fontSize, 11);
    PlayUi.using(PlayUiTarget.villageButton, () {
      final chipHeight =
          (PlayUi.buttonMaxWidth / PlayUi.ovalAspect) * PlayUi.buttonHeightScale;
      expect(mission.height, lessThan(chipHeight - 8));
    }, locale: const Locale('ko'));
  });

  testWidgets('modal ovals share close height and grow with the label', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    PlayUiTune.instance.setEditingLocale('ko');
    PlayUiTune.instance.setEditingTarget(PlayUiTarget.giveUp);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ko'),
        home: PlayUiScope(
          target: PlayUiTarget.giveUp,
          localeId: 'ko',
          child: Center(
            child: ParchmentModalButtonRow(
              children: [
                ParchmentModalButton(
                  key: const Key('modal-short'),
                  asset: ParchmentModal.continueAsset,
                  label: '닫기',
                  color: PlayUi.ink,
                  onPressed: () {},
                ),
                ParchmentModalButton(
                  key: const Key('modal-long'),
                  asset: ParchmentModal.continueAsset,
                  label: '첫 창문을 밝히기',
                  color: PlayUi.ink,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final short = tester.getSize(find.byKey(const Key('modal-short')));
    final long = tester.getSize(find.byKey(const Key('modal-long')));
    final skinny = PlayUi.kOvalCompactWidth / PlayUi.ovalAspect;
    expect(short.height, closeTo(skinny, 0.5));
    expect(long.height, closeTo(short.height, 0.5));
    expect(short.width, closeTo(PlayUi.kOvalCompactWidth, 1));
    expect(long.width, greaterThan(short.width + 20));
    expect(tester.widget<Text>(find.text('닫기')).style?.fontSize, 11);
    expect(
      tester.widget<Text>(find.text('첫 창문을 밝히기')).style?.fontSize,
      11,
    );
  });

  testWidgets('give-up buttons keep close height after the copy', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    PlayUiTune.instance.setEditingLocale('ko');
    PlayUiTune.instance.setEditingTarget(PlayUiTarget.giveUp);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ko'),
        home: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog<void>(
                context: context,
                barrierColor: const Color(0xCC152433),
                builder: (_) => const GiveUpPuzzleDialog(),
              );
            });
            return const SizedBox.expand();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final ovals = find.descendant(
      of: find.byType(GiveUpPuzzleDialog),
      matching: find.byType(OvalImageButton),
    );
    expect(ovals, findsNWidgets(2));
    final keep = tester.getSize(ovals.at(0));
    final leave = tester.getSize(ovals.at(1));
    final skinny = PlayUi.kOvalCompactWidth / PlayUi.ovalAspect;
    expect(keep.height, closeTo(skinny, 0.5));
    expect(leave.height, closeTo(keep.height, 0.5));
    expect(keep.width, greaterThan(leave.width));
    expect(tester.widget<Text>(find.text('계속 풀기')).style?.fontSize, 11);
    expect(tester.widget<Text>(find.text('나가기')).style?.fontSize, 11);

    final parchment = tester.getSize(find.byKey(const Key('parchment-window')));
    expect(parchment.height, lessThan(420));
    expect(parchment.height, greaterThan(140));
    for (final image in tester.widgetList<Image>(
      find.descendant(
        of: find.byType(GiveUpPuzzleDialog),
        matching: find.byType(Image),
      ),
    )) {
      expect(image.centerSlice, isNull);
    }
  });
}
