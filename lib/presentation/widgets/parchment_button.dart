import 'package:flutter/material.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';

/// Painted parchment scroll used as a primary game button.
class ParchmentButton extends StatefulWidget {
  const ParchmentButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fontSize = 19,
  });

  static const asset = 'assets/images/SystemUI/Button.png';
  static const imageAspectRatio = 2172 / 724;

  final String label;
  final VoidCallback? onPressed;
  final double fontSize;

  @override
  State<ParchmentButton> createState() => _ParchmentButtonState();
}

class _ParchmentButtonState extends State<ParchmentButton> {
  static const _ink = Color(0xFF24452D);

  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;

    return ListenableBuilder(
      listenable: PlayUiTune.instance,
      builder: (context, _) {
        final fontSize = widget.fontSize + (PlayUi.title - PlayUi.kTitle);
        return Semantics(
          button: true,
          enabled: enabled,
          label: widget.label,
          child: GestureDetector(
            onTap: widget.onPressed,
            onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
            onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
            onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 90),
              scale: _pressed ? 0.97 : 1,
              // Button.png has empty padding above/below the scroll. Crop that
              // only (content rows 87–583 of 724), aligned so the rolls stay in view.
              child: ClipRect(
                child: Align(
                  alignment: const Alignment(0, -0.23),
                  heightFactor: 0.686,
                  child: AspectRatio(
                    aspectRatio: ParchmentButton.imageAspectRatio,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned.fill(
                          child: Opacity(
                            opacity: enabled ? 1 : 0.55,
                            child: Image.asset(
                              ParchmentButton.asset,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              filterQuality: FilterQuality.medium,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: PlayUi.parchmentTextPad,
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Transform.translate(
                                offset: Offset(
                                  PlayUi.buttonTextOffsetX,
                                  PlayUi.buttonTextOffsetY,
                                ),
                                child: Text(
                                  widget.label,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w800,
                                    color: _ink,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
