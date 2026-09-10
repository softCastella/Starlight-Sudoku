import 'dart:math' as math;

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
    this.width,
    this.height = 40,
    this.fontSize = PlayUi.kButton,
    this.expandToFitLabel = false,
    this.target,
    this.imageAsset = OvalImageButton.asset,
    this.color = PlayUi.ink,
  });

  static const asset =
      'assets/images/SystemUI/button_modal_default_starlight_sudoku.png';
  static const imageAspectRatio = PlayUi.ovalAspect;
  static const assetSize = Size(551, 176);

  final String label;
  final VoidCallback onPressed;
  /// Compact override (인트로 「다음」). Null = this chip's 버튼 폭 slider.
  final double? width;
  final double height;
  final double fontSize;
  /// Keep [width] as height source and grow sideways for a long label.
  final bool expandToFitLabel;
  /// When omitted, inherits the wrapping modal target.
  final PlayUiTarget? target;
  final String imageAsset;
  final Color color;

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
                  final maxW = constraints.maxWidth.isFinite
                      ? constraints.maxWidth
                      : double.infinity;
                  double cap(double wanted) =>
                      maxW.isFinite && maxW < wanted ? maxW : wanted;

                  final compact = widget.width;
                  late final OvalButtonLayout layout;
                  var stretchMiddle = false;
                  if (compact != null) {
                    // Skinny oval: height follows the compact width, not the
                    // modal chip. Font is PlayUi.button. Long labels grow
                    // the middle only; star ends stay the compact size.
                    final height = compact / PlayUi.ovalAspect;
                    final endFrac = PlayUi.ovalEndFraction;
                    final inset = compact * endFrac;
                    var width = cap(compact);
                    if (widget.expandToFitLabel) {
                      final painter = TextPainter(
                        text: TextSpan(
                          text: widget.label,
                          style: PlayUi.buttonStyle().copyWith(
                            fontSize: PlayUi.button,
                          ),
                        ),
                        textDirection: Directionality.of(context),
                        maxLines: 1,
                      )..layout();
                      width = (painter.width + inset * 2 + 16).clamp(
                        math.min(compact, cap(maxW)),
                        cap(maxW),
                      );
                    }
                    layout = OvalButtonLayout(
                      width: width,
                      height: height,
                      fontSize: PlayUi.button,
                      sideInset: inset,
                      maxLines: 1,
                    );
                    stretchMiddle = width > compact + 0.5;
                  } else {
                    layout = OvalButtonLayout.forLabel(
                      widget.label,
                      direction: Directionality.of(context),
                      preferredFontSize: PlayUi.button,
                      maxWidth: cap(PlayUi.buttonMaxWidth),
                    );
                  }
                  final textOffset = Offset(
                    PlayUi.buttonTextOffsetX,
                    PlayUi.buttonTextOffsetY,
                  );
                  // Keep height: 1 from buttonStyle — 1.05 made glyphs sit low.
                  final textStyle = PlayUi.buttonStyle(color: widget.color).copyWith(
                    fontSize: layout.fontSize,
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
                                child: stretchMiddle
                                    ? _OvalMiddleStretch(
                                        asset: widget.imageAsset,
                                        endFrac: PlayUi.ovalEndFraction,
                                      )
                                    : Image.asset(
                                        widget.imageAsset,
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
                                        softWrap: layout.maxLines > 1,
                                        overflow: TextOverflow.clip,
                                        textScaler: TextScaler.noScaling,
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

/// Left/right caps stay the skinny oval's end size. Only the middle stretches.
class _OvalMiddleStretch extends StatelessWidget {
  const _OvalMiddleStretch({
    required this.asset,
    required this.endFrac,
  });

  final String asset;
  final double endFrac;

  Widget _src({required double width, required double height}) => Image.asset(
        asset,
        width: width,
        height: height,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.medium,
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final srcW = height * PlayUi.ovalAspect;
        final capW = srcW * endFrac;
        final middleSrc = math.max(1.0, srcW - capW * 2);

        Widget cap(Alignment align) => SizedBox(
              width: capW,
              height: height,
              child: ClipRect(
                child: OverflowBox(
                  alignment: align,
                  minWidth: srcW,
                  maxWidth: srcW,
                  minHeight: height,
                  maxHeight: height,
                  child: _src(width: srcW, height: height),
                ),
              ),
            );

        return Row(
          children: [
            cap(Alignment.centerLeft),
            Expanded(
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox(
                    width: middleSrc,
                    height: height,
                    child: ClipRect(
                      child: OverflowBox(
                        alignment: Alignment.center,
                        minWidth: srcW,
                        maxWidth: srcW,
                        minHeight: height,
                        maxHeight: height,
                        child: _src(width: srcW, height: height),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            cap(Alignment.centerRight),
          ],
        );
      },
    );
  }
}

