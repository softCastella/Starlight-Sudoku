import 'package:flutter/material.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';

/// Exit confirmation used only on the puzzle screen.
class GiveUpPuzzleDialog extends StatelessWidget {
  const GiveUpPuzzleDialog({super.key});

  static const windowAsset =
      'assets/images/SystemUI/modal_window_starlight_sudoku.png';
  static const continueAsset =
      'assets/images/SystemUI/button_modal_default_starlight_sudoku.png';
  static const exitAsset =
      'assets/images/SystemUI/button_modal_exit_starlight_sudoku.png';

  static const _ink = Color(0xFF24452D);
  static const _muted = Color(0xFF4D6554);
  static const _cream = Color(0xFFFBF7EC);

  @override
  Widget build(BuildContext context) {
    final l10n = l10nOf(context);
    final width = (MediaQuery.sizeOf(context).width - 40).clamp(280.0, 420.0);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: width,
          child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              windowAsset,
              fit: BoxFit.fitWidth,
              filterQuality: FilterQuality.medium,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 36, 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.giveUpTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.giveUpMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: _muted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ModalImageButton(
                        asset: continueAsset,
                        label: l10n.keepPlaying,
                        color: _ink,
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      const SizedBox(width: 12),
                      _ModalImageButton(
                        asset: exitAsset,
                        label: l10n.exitPuzzle,
                        color: _cream,
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _ModalImageButton extends StatefulWidget {
  const _ModalImageButton({
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
  State<_ModalImageButton> createState() => _ModalImageButtonState();
}

class _ModalImageButtonState extends State<_ModalImageButton> {
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
            height: 30,
            width: 88,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    widget.asset,
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
                Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: widget.color,
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
