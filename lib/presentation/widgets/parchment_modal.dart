import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';

/// Parchment window that keeps copy and buttons inside the art.
class ParchmentModal extends StatelessWidget {
  const ParchmentModal({
    super.key,
    required this.child,
    this.shrinkContent = true,
    this.aspectRatio = windowAspectRatio,
    this.target = PlayUiTarget.common,
  });

  static const windowAsset =
      'assets/images/SystemUI/modal_window_starlight_sudoku.png';
  static const continueAsset =
      'assets/images/SystemUI/button_modal_default_starlight_sudoku.png';
  static const exitAsset =
      'assets/images/SystemUI/button_modal_exit_starlight_sudoku.png';
  static const windowAspectRatio = 1416 / 687;
  static const buttonAspectRatio = PlayUi.ovalAspect;

  final Widget child;
  final bool shrinkContent;
  final double aspectRatio;
  final PlayUiTarget target;

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
    final padY = PlayUi.modalPadY;
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
          constraints: BoxConstraints(maxWidth: maxW, maxHeight: maxH),
          child: PlayUiTune.instance.previewReads
              ? _parchmentBody(padX, padY, innerW, shrinkContent)
              : AspectRatio(
                  aspectRatio: aspectRatio,
                  child: _parchmentBody(padX, padY, innerW, shrinkContent),
                ),
        ),
      ),
    );
  }

  Widget _parchmentBody(
    double padX,
    double padY,
    double innerW,
    bool scaleContent,
  ) {
    return _ParchmentFrame(
      child: Padding(
        padding: EdgeInsets.fromLTRB(padX, padY, padX, padY),
        child: Center(
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
        Positioned.fill(
          child: Image.asset(
            ParchmentModal.windowAsset,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.medium,
          ),
        ),
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

class ParchmentModalButton extends StatefulWidget {
  const ParchmentModalButton({
    super.key,
    required this.asset,
    required this.label,
    required this.color,
    required this.onPressed,
    this.maxWidth,
  });

  final String asset;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final double? maxWidth;

  @override
  State<ParchmentModalButton> createState() => _ParchmentModalButtonState();
}

class _ParchmentModalButtonState extends State<ParchmentModalButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scope = PlayUiScope.maybeOf(context);
    final target = scope?.target ?? PlayUiTarget.common;
    final locale = scope != null
        ? PlayUiTune.localeFromId(scope.localeId)
        : Localizations.localeOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        PlayUi.applyScope(context);
        return PlayUi.using(
          target,
          () {
            final cap = math.min(
              widget.maxWidth ?? PlayUi.buttonMaxWidth,
              constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : PlayUi.buttonMaxWidth,
            );
            final layout = OvalButtonLayout.forLabel(
              widget.label,
              direction: Directionality.of(context),
              preferredFontSize: PlayUi.button,
              maxWidth: cap,
              color: widget.color,
            );
            final textOffset = Offset(
              PlayUi.buttonTextOffsetX,
              PlayUi.buttonTextOffsetY,
            );
            final textStyle = PlayUi.buttonStyle(color: widget.color)
                .copyWith(fontSize: layout.fontSize, height: 1.05);

            return Align(
              alignment: Alignment.center,
              child: Semantics(
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
                              widget.asset,
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
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
              ),
            );
          },
          locale: locale,
        );
      },
    );
  }
}
