import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/presentation/widgets/web_audio_gate.dart';

void main() {
  WebAudioGate gate({
    VoidCallback? onBgmOnPointerDown,
    VoidCallback? onBgmOnPressed,
    VoidCallback? onBgmOffPointerDown,
    VoidCallback? onBgmOffPressed,
  }) {
    return WebAudioGate(
      bgmOnLabel: 'BGM ON',
      bgmOffLabel: 'BGM OFF',
      onBgmOnPointerDown: onBgmOnPointerDown ?? () {},
      onBgmOnPressed: onBgmOnPressed ?? () {},
      onBgmOffPointerDown: onBgmOffPointerDown ?? () {},
      onBgmOffPressed: onBgmOffPressed ?? () {},
    );
  }

  Widget host(Widget child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: child),
    );
  }

  testWidgets('translucent background covers the complete viewport', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Colors.red),
            gate(),
          ],
        ),
      ),
    );

    final background = tester.widget<ColoredBox>(
      find.byKey(const Key('web-audio-gate-background')),
    );
    expect(background.color, WebAudioGate.backgroundColor);
    expect(background.color.a, closeTo(0.6, 0.01));
    expect(
      tester.getSize(find.byKey(const Key('web-audio-gate'))),
      tester.getSize(find.byType(Scaffold)),
    );

    final blended = Color.alphaBlend(background.color, Colors.red);
    expect(blended, isNot(background.color));
    expect(blended, isNot(Colors.red));
  });

  testWidgets('gate blocks pointer input from reaching content behind it', (
    tester,
  ) async {
    var backgroundTaps = 0;
    await tester.pumpWidget(
      host(
        Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => backgroundTaps++,
              child: const ColoredBox(color: Colors.red),
            ),
            gate(),
          ],
        ),
      ),
    );

    await tester.tapAt(const Offset(8, 8));
    await tester.pump();

    expect(backgroundTaps, 0);
  });

  testWidgets('both labels resolve to no text decoration', (tester) async {
    await tester.pumpWidget(host(gate()));

    for (final label in ['BGM ON', 'BGM OFF']) {
      final finder = find.text(label);
      final text = tester.widget<Text>(finder);
      final inherited = DefaultTextStyle.of(tester.element(finder)).style;
      final resolved = inherited.merge(text.style);

      expect(resolved.decoration, TextDecoration.none, reason: label);
      expect(resolved.decorationColor, Colors.transparent, reason: label);
    }
  });

  testWidgets('ON pointer-down runs before the ON pressed callback', (
    tester,
  ) async {
    final events = <String>[];
    await tester.pumpWidget(
      host(
        gate(
          onBgmOnPointerDown: () => events.add('on-pointer-down'),
          onBgmOnPressed: () => events.add('on-pressed'),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('web-audio-start')));

    expect(events, ['on-pointer-down', 'on-pressed']);
  });

  testWidgets('OFF pointer-down runs before the OFF pressed callback', (
    tester,
  ) async {
    final events = <String>[];
    await tester.pumpWidget(
      host(
        gate(
          onBgmOffPointerDown: () => events.add('off-pointer-down'),
          onBgmOffPressed: () => events.add('off-pressed'),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('web-audio-off')));

    expect(events, ['off-pointer-down', 'off-pressed']);
  });
}
