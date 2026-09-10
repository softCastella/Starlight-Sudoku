import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';
import 'package:sudoku_game/presentation/widgets/oval_image_button.dart';

/// Parchment window that keeps copy and buttons inside the art.
class ParchmentModal extends StatelessWidget {
  const ParchmentModal({
    super.key,
    required this.child,
    this.shrinkContent = false,
    this.aspectRatio,
    this.target = PlayUiTarget.common,
    this.alignment = Alignment.center,
  });

  static const windowAsset =
      'assets/images/SystemUI/modal_window_starlight_sudoku.png';
  static const continueAsset =
      'assets/images/SystemUI/button_modal_default_starlight_sudoku.png';
  static const exitAsset =
      'assets/images/SystemUI/button_modal_exit_starlight_sudoku.png';
  static const windowAspectRatio = 1416 / 687;
  static const buttonAspectRatio = PlayUi.ovalAspect;
  static const windowSrcWidth = 1416.0;
  static const windowSrcHeight = 687.0;
  /// Caps outside the red (horizontal) / blue (vertical) stretch guides.
  static const windowSliceLeft = 0.430;
  static const windowSliceRight = 0.422;
  static const windowSliceTop = 0.382;
  static const windowSliceBottom = 0.456;

  final Widget child;
  final bool shrinkContent;
  final double? aspectRatio;
  final PlayUiTarget target;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PlayUiTune.instance,
      builder: (context, _) {
        final locale = Localizations.localeOf(context);
        return PlayUiScope(
          target: target,
          localeId: PlayUiTune.localeIdFrom(locale),
          child: Builder(
            builder: (context) {
              PlayUi.applyScope(context);
              return PlayUi.using(
                target,
                () => _buildDialog(context),
                locale: locale,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDialog(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final panelOpen = PlayUiTune.isEditorEnabled &&
        PlayUiTune.instance.panelOpen &&
        !PlayUiTune.instance.previewReads;
    final panelHeight =
        panelOpen ? size.height * PlayUiTune.editorPanelHeightFactor : 0.0;
    final maxW = (size.width - PlayUi.modalInset * 2).clamp(
      PlayUi.modalMinWidth,
      PlayUi.modalMaxWidth,
    );
    final maxH = math.max(
      120.0,
      size.height - PlayUi.modalInsetY * 2 - panelHeight,
    );
    final padX = PlayUi.modalPadX;
    final padTop = PlayUi.modalPadTop;
    final padBottom = PlayUi.modalPadBottom;
    final innerW = math.max(0.0, maxW - padX * 2);

    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: panelOpen ? Alignment.topCenter : Alignment.center,
      insetPadding: EdgeInsets.fromLTRB(
        PlayUi.modalInset,
        PlayUi.modalInsetY,
        PlayUi.modalInset,
        PlayUi.modalInsetY + panelHeight,
      ),
      child: Transform.translate(
        offset: Offset(PlayUi.modalOffsetX, PlayUi.modalOffsetY),
        child: ConstrainedBox(
          key: const Key('parchment-window'),
          constraints: BoxConstraints(maxWidth: maxW, maxHeight: maxH),
          child: aspectRatio == null
              ? _parchmentBody(
                  padX,
                  padTop,
                  padBottom,
                  innerW,
                  shrinkContent,
                  hug: true,
                )
              : AspectRatio(
                  aspectRatio: aspectRatio!,
                  child: _parchmentBody(
                    padX,
                    padTop,
                    padBottom,
                    innerW,
                    shrinkContent,
                    hug: false,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _parchmentBody(
    double padX,
    double padTop,
    double padBottom,
    double innerW,
    bool scaleContent, {
    required bool hug,
  }) {
    return _ParchmentFrame(
      child: Padding(
        padding: EdgeInsets.fromLTRB(padX, padTop, padX, padBottom),
        child: Align(
          alignment: alignment,
          widthFactor: hug ? 1 : null,
          heightFactor: hug ? 1 : null,
          child: scaleContent
              ? FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: SizedBox(width: innerW, child: child),
                )
              : SizedBox(width: innerW, child: child),
        ),
      ),
    );
  }
}

class _ParchmentFrame extends StatelessWidget {
  const _ParchmentFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    PlayUi.applyScope(context);
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.hardEdge,
      children: [
        const Positioned.fill(child: _ParchmentNineSlice()),
        if (PlayUi.overlayOpacity > 0)
          Positioned.fill(
            child: ColoredBox(
              color: Color.fromRGBO(0, 0, 0, PlayUi.overlayOpacity),
            ),
          ),
        child,
      ],
    );
  }
}

/// Corners stay. Red guide grows sideways, blue guide grows up/down.
class _ParchmentNineSlice extends StatelessWidget {
  const _ParchmentNineSlice();

  Widget _src(double width, double height) => Image.asset(
        ParchmentModal.windowAsset,
        width: width,
        height: height,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.medium,
      );

  Widget _cell({
    required Alignment alignment,
    required double destW,
    required double destH,
    required double srcW,
    required double srcH,
    required double clipW,
    required double clipH,
  }) {
    Widget clip = SizedBox(
      width: clipW,
      height: clipH,
      child: ClipRect(
        child: OverflowBox(
          alignment: alignment,
          minWidth: srcW,
          maxWidth: srcW,
          minHeight: srcH,
          maxHeight: srcH,
          child: _src(srcW, srcH),
        ),
      ),
    );
    if ((destW - clipW).abs() > 0.5 || (destH - clipH).abs() > 0.5) {
      clip = FittedBox(fit: BoxFit.fill, child: clip);
    }
    return SizedBox(
      width: destW,
      height: destH,
      child: ClipRect(child: clip),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        const srcW = ParchmentModal.windowSrcWidth;
        const srcH = ParchmentModal.windowSrcHeight;
        const leftFrac = ParchmentModal.windowSliceLeft;
        const rightFrac = ParchmentModal.windowSliceRight;
        const topFrac = ParchmentModal.windowSliceTop;
        const bottomFrac = ParchmentModal.windowSliceBottom;
        var scale = math.min(w / srcW, h / srcH);
        scale = math.min(
          scale,
          math.min(
            (w - 1) / ((leftFrac + rightFrac) * srcW),
            (h - 1) / ((topFrac + bottomFrac) * srcH),
          ),
        );
        final nw = srcW * scale;
        final nh = srcH * scale;
        final left = nw * leftFrac;
        final right = nw * rightFrac;
        final top = nh * topFrac;
        final bottom = nh * bottomFrac;
        final midSrcW = math.max(1.0, nw - left - right);
        final midSrcH = math.max(1.0, nh - top - bottom);
        final midW = math.max(1.0, w - left - right);
        final midH = math.max(1.0, h - top - bottom);

        Widget cell(Alignment align, double dw, double dh, double cw, double ch) =>
            _cell(
              alignment: align,
              destW: dw,
              destH: dh,
              srcW: nw,
              srcH: nh,
              clipW: cw,
              clipH: ch,
            );

        return Column(
          children: [
            SizedBox(
              height: top,
              child: Row(
                children: [
                  cell(Alignment.topLeft, left, top, left, top),
                  cell(Alignment.topCenter, midW, top, midSrcW, top),
                  cell(Alignment.topRight, right, top, right, top),
                ],
              ),
            ),
            SizedBox(
              height: midH,
              child: Row(
                children: [
                  cell(Alignment.centerLeft, left, midH, left, midSrcH),
                  cell(Alignment.center, midW, midH, midSrcW, midSrcH),
                  cell(Alignment.centerRight, right, midH, right, midSrcH),
                ],
              ),
            ),
            SizedBox(
              height: bottom,
              child: Row(
                children: [
                  cell(Alignment.bottomLeft, left, bottom, left, bottom),
                  cell(Alignment.bottomCenter, midW, bottom, midSrcW, bottom),
                  cell(Alignment.bottomRight, right, bottom, right, bottom),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ParchmentModalButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      widthFactor: 1,
      heightFactor: 1,
      child: OvalImageButton(
        label: label,
        onPressed: onPressed,
        width: PlayUi.kOvalCompactWidth,
        expandToFitLabel: true,
        imageAsset: asset,
        color: color,
      ),
    );
  }
}

/// Side-by-side modal ovals. Each keeps the close-button height and grows
/// only as wide as its label.
class ParchmentModalButtonRow extends StatelessWidget {
  const ParchmentModalButtonRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: PlayUi.rowGap),
          Flexible(fit: FlexFit.loose, child: children[i]),
        ],
      ],
    );
  }
}
