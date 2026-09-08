import 'package:flutter/material.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
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
    this.target,
  });

  static const asset =
      'assets/images/SystemUI/button_modal_default_starlight_sudoku.png';
  static const imageAspectRatio = PlayUi.ovalAspect;

  final String label;
  final VoidCallback onPressed;
  /// Width follows the 버튼 폭 slider. Font does not change it.
  final double width;
  final double height;
  final double fontSize;
  /// When omitted, inherits the wrapping modal target.
  final PlayUiTarget? target;

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
        final target = widget.target ??
            PlayUiScope.maybeOf(context)?.target ??
            (PlayUi.currentTarget == PlayUiTarget.common
                ? PlayUiTarget.titleButton
                : PlayUi.currentTarget);
        final localeId = PlayUiScope.maybeOf(context)?.localeId ??
            PlayUiTune.localeIdFrom(Localizations.localeOf(context));
        return PlayUiScope(
          target: target,
          localeId: localeId,
          child: LayoutBuilder(
            builder: (context, constraints) {
              PlayUi.applyScope(context);
              return PlayUi.using(
                target,
                () {
                  final wanted = PlayUi.buttonMaxWidth;
                  final cap = constraints.maxWidth.isFinite
                      ? (constraints.maxWidth < wanted
                          ? constraints.maxWidth
                          : wanted)
                      : wanted;
                  final layout = OvalButtonLayout.forLabel(
                    widget.label,
                    direction: Directionality.of(context),
                    preferredFontSize: PlayUi.button,
                    maxWidth: cap,
                  );
                  final textOffset = Offset(
                    PlayUi.buttonTextOffsetX,
                    PlayUi.buttonTextOffsetY,
                  );
                  final textStyle = PlayUi.buttonStyle().copyWith(
                    fontSize: layout.fontSize,
                    height: 1.05,
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
                              Positioned.fill(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: layout.sideInset,
                                  ),
                                  child: Center(
                                    child: Transform.translate(
                                      offset: textOffset,
                                      child: Text(
                                        widget.label,
                                        maxLines: layout.maxLines,
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        overflow: TextOverflow.clip,
                                        style: textStyle,
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
                },
                locale: PlayUiTune.localeFromId(localeId),
              );
            },
          ),
        );
      },
    );
  }
}
