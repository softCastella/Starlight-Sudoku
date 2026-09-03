import 'package:flutter/material.dart';

/// Small horizontal oval button with the cream modal-button art.
class OvalImageButton extends StatefulWidget {
  const OvalImageButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 168,
    this.height = 40,
    this.fontSize = 14,
  });

  static const asset =
      'assets/images/SystemUI/button_modal_default_starlight_sudoku.png';
  static const imageAspectRatio = 551 / 176;

  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double fontSize;

  @override
  State<OvalImageButton> createState() => _OvalImageButtonState();
}

class _OvalImageButtonState extends State<OvalImageButton> {
  static const _ink = Color(0xFF24452D);

  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
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
            width: widget.width,
            height: widget.width / OvalImageButton.imageAspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    OvalImageButton.asset,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                        height: 1,
                      ),
                    ),
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
