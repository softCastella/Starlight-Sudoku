import 'package:flutter/material.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/widgets/oval_image_button.dart';

/// Web-only startup gate that owns the browser audio choice gesture.
///
/// Keeping the visual and pointer contract in one widget lets the deployment
/// harness exercise it before a Pages build can proceed.
class WebAudioGate extends StatelessWidget {
  const WebAudioGate({
    super.key,
    required this.bgmOnLabel,
    required this.bgmOffLabel,
    required this.onBgmOnPointerDown,
    required this.onBgmOnPressed,
    required this.onBgmOffPointerDown,
    required this.onBgmOffPressed,
  });

  static const backgroundColor = Color(0x9907152F);
  static const labelDecoration = TextStyle(
    decoration: TextDecoration.none,
    decorationColor: Colors.transparent,
  );

  final String bgmOnLabel;
  final String bgmOffLabel;
  final VoidCallback onBgmOnPointerDown;
  final VoidCallback onBgmOnPressed;
  final VoidCallback onBgmOffPointerDown;
  final VoidCallback onBgmOffPressed;

  @override
  Widget build(BuildContext context) {
    return Listener(
      key: const Key('web-audio-gate'),
      behavior: HitTestBehavior.opaque,
      child: ColoredBox(
        key: const Key('web-audio-gate-background'),
        color: backgroundColor,
        child: DefaultTextStyle.merge(
          style: labelDecoration,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Listener(
                  behavior: HitTestBehavior.translucent,
                  onPointerDown: (_) => onBgmOnPointerDown(),
                  child: OvalImageButton(
                    key: const Key('web-audio-start'),
                    label: bgmOnLabel,
                    target: PlayUiTarget.bgmGate,
                    onPressed: onBgmOnPressed,
                  ),
                ),
                const SizedBox(height: 12),
                Listener(
                  behavior: HitTestBehavior.translucent,
                  onPointerDown: (_) => onBgmOffPointerDown(),
                  child: OvalImageButton(
                    key: const Key('web-audio-off'),
                    label: bgmOffLabel,
                    target: PlayUiTarget.bgmGate,
                    onPressed: onBgmOffPressed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
