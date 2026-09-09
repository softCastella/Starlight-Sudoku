import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';

/// Painted parchment scroll used as a primary game button.
class ParchmentButton extends StatefulWidget {
  const ParchmentButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  static const asset = 'assets/images/SystemUI/Button.png';
  static const imageAspectRatio = 2172 / 724;
  /// Button.png has empty padding above/below the scroll.
  static const cropHeightFactor = 0.686;

  /// Layout height after cropping empty PNG padding.
  static double visibleHeightFor(double width) =>
      width / imageAspectRatio * cropHeightFactor;

  final String label;
  final VoidCallback? onPressed;

  @override
  State<ParchmentButton> createState() => _ParchmentButtonState();
}

class _ParchmentButtonState extends State<ParchmentButton> {
  static const _ink = Color(0xFF24452D);

  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final locale = Localizations.localeOf(context);

    return ListenableBuilder(
      listenable: PlayUiTune.instance,
      builder: (context, _) {
        return PlayUiScope(
          target: PlayUiTarget.titleButton,
          localeId: PlayUiTune.localeIdFrom(locale),
          child: LayoutBuilder(
            builder: (context, constraints) {
              PlayUi.applyScope(context);
              final fontSize = PlayUi.button;
              final width = constraints.maxWidth.isFinite
                  ? math.min(constraints.maxWidth, PlayUi.buttonMaxWidth)
                  : PlayUi.buttonMaxWidth;
              return Center(
                child: SizedBox(
                  key: const Key('parchment-button-chrome'),
                  width: width,
                  child: Semantics(
                    button: true,
                    enabled: enabled,
                    label: widget.label,
                    child: GestureDetector(
                      onTap: widget.onPressed,
                      onTapDown: enabled
                          ? (_) => setState(() => _pressed = true)
                          : null,
                      onTapUp: enabled
                          ? (_) => setState(() => _pressed = false)
                          : null,
                      onTapCancel: enabled
                          ? () => setState(() => _pressed = false)
                          : null,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 90),
                        scale: _pressed ? 0.97 : 1,
                        // Button.png has empty padding above/below the scroll.
                        child: ClipRect(
                          child: Align(
                            alignment: const Alignment(0, -0.23),
                            heightFactor: ParchmentButton.cropHeightFactor,
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
                                      child: Center(
                                        child: Transform.translate(
                                          offset: Offset(
                                            PlayUi.buttonTextOffsetX,
                                            PlayUi.buttonTextOffsetY,
                                          ),
                                          child: Text(
                                            widget.label,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
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
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
