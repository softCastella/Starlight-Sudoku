import 'package:flutter/material.dart';

/// Parchment window that keeps copy and buttons inside the art.
class ParchmentModal extends StatelessWidget {
  const ParchmentModal({super.key, required this.child});

  static const windowAsset =
      'assets/images/SystemUI/modal_window_starlight_sudoku.png';
  static const continueAsset =
      'assets/images/SystemUI/button_modal_default_starlight_sudoku.png';
  static const exitAsset =
      'assets/images/SystemUI/button_modal_exit_starlight_sudoku.png';
  static const windowAspectRatio = 1416 / 687;
  static const buttonAspectRatio = 551 / 176;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final maxW = (size.width - 40).clamp(280.0, 420.0);
    final maxH = size.height - 48;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW, maxHeight: maxH),
        child: AspectRatio(
          aspectRatio: windowAspectRatio,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned.fill(
                child: Image.asset(
                  windowAsset,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.medium,
                ),
              ),
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final padX = constraints.maxWidth * 0.12;
                    final padY = constraints.maxHeight * 0.16;
                    return Padding(
                      padding: EdgeInsets.fromLTRB(padX, padY, padX, padY),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SizedBox(
                          width: constraints.maxWidth - padX * 2,
                          child: child,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParchmentModalButton extends StatefulWidget {
  const ParchmentModalButton({
    super.key,
    required this.asset,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String asset;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  State<ParchmentModalButton> createState() => _ParchmentModalButtonState();
}

class _ParchmentModalButtonState extends State<ParchmentModalButton> {
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
          child: AspectRatio(
            aspectRatio: ParchmentModal.buttonAspectRatio,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    widget.asset,
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.label,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: widget.color,
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
    );
  }
}
