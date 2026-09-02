import 'package:flutter/material.dart';

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
          child: AspectRatio(
            aspectRatio: ParchmentButton.imageAspectRatio,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 52),
                  child: Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                      height: 1,
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
