import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Layout and type tokens. Use these instead of one-off font sizes and padding.
class PlayUi {
  PlayUi._();

  /// Smallest allowed type. Captions and scaled-down labels stop here.
  static const double minType = 11;
  static const double caption = 11;
  static const double body = 13;
  static const double label = 14;
  static const double button = 15;
  static const double title = 18;

  static const Color ink = Color(0xFF24452D);
  static const Color muted = Color(0xFF4D6554);
  static const Color gold = Color(0xFFF5CC3D);
  /// Darker gold for day skies. `#F5CC3D` washes out on morning village.
  static const Color goldOnLight = Color(0xFFB57A14);
  static const Color cream = Color(0xFFFBF7EC);

  static const double screenPad = 20;
  static const double modalInset = 24;
  /// Minimum inset from the parchment art. Extra space is centering, not more pad.
  static const double modalPadX = 40;
  static const double modalPadY = 40;
  static const double modalPadTop = modalPadY;
  static const double modalPadBottom = modalPadY;
  static const double rowGap = 8;
  /// Cap after growing the oval to fit the label. Buttons do not fill the modal.
  static const double buttonMaxWidth = 200;
  static const double buttonMinWidth = 112;
  /// Pointed ends + stars. Keep copy in the flat middle of the oval.
  static const double ovalEndFraction = 0.19;
  static const double ovalAspect = 551 / 176;
  static const double ovalSideInset = 22;

  static TextStyle titleStyle({Color color = ink}) => TextStyle(
        fontSize: title,
        fontWeight: FontWeight.w800,
        color: color,
        height: 1.2,
      );

  static TextStyle labelStyle({Color color = muted, FontWeight weight = FontWeight.w700}) =>
      TextStyle(
        fontSize: label,
        fontWeight: weight,
        color: color,
        height: 1.2,
      );

  static TextStyle buttonStyle({Color color = ink}) => TextStyle(
        fontSize: button,
        fontWeight: FontWeight.w800,
        color: color,
        height: 1,
      );

  static TextStyle captionStyle({Color color = muted}) => TextStyle(
        fontSize: caption,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.2,
      );
}

/// Prefers [style] size, shrinks to [minFontSize], then wraps. Does not go below 11.
class FitLabel extends StatelessWidget {
  const FitLabel(
    this.text, {
    super.key,
    this.style,
    this.minFontSize = PlayUi.minType,
    this.maxLines = 1,
    this.textAlign,
    this.alignment = Alignment.centerLeft,
  });

  final String text;
  final TextStyle? style;
  final double minFontSize;
  final int maxLines;
  final TextAlign? textAlign;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final base = (style ?? PlayUi.labelStyle()).copyWith(
      fontSize: math.max(style?.fontSize ?? PlayUi.body, minFontSize),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        if (!maxWidth.isFinite) {
          return Text(text, maxLines: maxLines, textAlign: textAlign, style: base);
        }

        final direction = Directionality.of(context);
        final preferred = base.fontSize ?? PlayUi.body;
        final full = TextPainter(
          text: TextSpan(text: text, style: base),
          maxLines: 1,
          textDirection: direction,
          ellipsis: '…',
        )..layout();

        var size = preferred;
        if (full.width > maxWidth) {
          size = math.max(minFontSize, preferred * maxWidth / full.width);
        }

        final fitsAtMin = size > minFontSize + 0.05 || full.width <= maxWidth;
        final lines = fitsAtMin ? 1 : maxLines;

        return Align(
          alignment: alignment,
          child: Text(
            text,
            maxLines: lines,
            textAlign: textAlign,
            overflow: TextOverflow.ellipsis,
            style: base.copyWith(fontSize: size),
          ),
        );
      },
    );
  }
}

/// Oval button size from the label. Grow first, then shrink type to 11.
class OvalButtonLayout {
  const OvalButtonLayout({
    required this.width,
    required this.height,
    required this.fontSize,
    required this.sideInset,
  });

  final double width;
  final double height;
  final double fontSize;
  final double sideInset;

  static OvalButtonLayout forLabel(
    String label, {
    required TextDirection direction,
    double preferredFontSize = PlayUi.button,
    double maxWidth = PlayUi.buttonMaxWidth,
    Color color = PlayUi.ink,
  }) {
    final cap = math.max(1.0, maxWidth);
    final minWidth = math.min(PlayUi.buttonMinWidth, cap);
    var fontSize = preferredFontSize;
    final preferred = PlayUi.buttonStyle(color: color).copyWith(
      fontSize: fontSize,
      height: 1,
    );
    final painter = TextPainter(
      text: TextSpan(text: label, style: preferred),
      maxLines: 1,
      textDirection: direction,
    )..layout();

    final usableFraction = 1 - 2 * PlayUi.ovalEndFraction;
    var width = (painter.width / usableFraction).clamp(minWidth, cap);
    var sideInset = width * PlayUi.ovalEndFraction;
    var usable = width - sideInset * 2;

    if (painter.width > usable + 0.5) {
      fontSize = math.max(
        PlayUi.minType,
        preferredFontSize * usable / painter.width,
      );
      final shrunk = TextPainter(
        text: TextSpan(
          text: label,
          style: preferred.copyWith(fontSize: fontSize),
        ),
        maxLines: 1,
        textDirection: direction,
      )..layout();
      if (shrunk.width > usable + 0.5 && width < cap) {
        width = (shrunk.width / usableFraction).clamp(minWidth, cap);
        sideInset = width * PlayUi.ovalEndFraction;
        usable = width - sideInset * 2;
      }
      if (shrunk.width > usable + 0.5) {
        fontSize = math.max(PlayUi.minType, fontSize * usable / shrunk.width);
      }
    }

    return OvalButtonLayout(
      width: width,
      height: width / PlayUi.ovalAspect,
      fontSize: fontSize,
      sideInset: sideInset,
    );
  }
}
