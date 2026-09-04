import 'package:flutter/material.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';

/// Small horizontal oval button with the cream modal-button art.
class OvalImageButton extends StatefulWidget {
  const OvalImageButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = PlayUi.kButtonMaxWidth,
    this.height = 40,
    this.fontSize = PlayUi.kButton,
  });

  static const asset =
      'assets/images/SystemUI/button_modal_default_starlight_sudoku.png';
  static const imageAspectRatio = PlayUi.ovalAspect;

  final String label;
  final VoidCallback onPressed;
  /// Max width. Actual size follows the label.
  final double width;
  final double height;
  final double fontSize;

  @override
  State<OvalImageButton> createState() => _OvalImageButtonState();
}

class _OvalImageButtonState extends State<OvalImageButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PlayUiTune.instance,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final cap = constraints.maxWidth.isFinite
                ? constraints.maxWidth.clamp(1.0, PlayUi.buttonMaxWidth)
                : PlayUi.buttonMaxWidth;
            final layout = OvalButtonLayout.forLabel(
              widget.label,
              direction: Directionality.of(context),
              preferredFontSize: PlayUi.button,
              maxWidth: cap,
            );

            return Semantics(
              button: true,
              label: widget.label,
              child: GestureDetector(
                onTap: widget.onPressed,
                onTapDown: (_) => setState(() => _pressed = true),
                onTapUp: (_) => setState(() => _pressed = false),
                onTapCancel: () => setState(() => _pressed = false),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 90),
                  scale: _pressed ? 0.97 : 1,
                  child: SizedBox(
                    width: layout.width,
                    height: layout.height,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            OvalImageButton.asset,
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: layout.sideInset,
                          ),
                          child: Text(
                            widget.label,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: PlayUi.buttonStyle().copyWith(
                              fontSize: layout.fontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
