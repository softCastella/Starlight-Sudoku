import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';

/// Layout and type tokens. Use these instead of one-off font sizes and padding.
class PlayUi {
  PlayUi._();

  /// Smallest allowed type. Captions and scaled-down labels stop here.
  static const double minType = 11;

  static const double kCaption = 11;
  static const double kBody = 13;
  static const double kLabel = 14;
  static const double kButton = 11;
  /// Title parchment only. Other buttons stay [kButton].
  static const double kTitleButton = 15;
  static const double kTitle = 18;
  static const double kModalInset = 24;
  static const double kModalPadX = 40;
  static const double kModalPadY = 40;
  static const double kModalMinWidth = 280;
  static const double kModalMaxWidth = 420;
  static const double kRowGap = 8;
  static const double kButtonMaxWidth = 200;
  static const double kButtonMinWidth = 112;
  static const double kOvalEndFraction = 0.19;
  /// Intro / modal oval height source. Long labels grow the middle only.
  static const double kOvalCompactWidth = 80;
  static const double kScreenPad = 20;
  static const double kModalInsetY = 24;
  static const double kModalOffsetX = 0;
  static const double kModalOffsetY = 0;
  static const double kButtonTextOffsetX = 0;
  static const double kButtonTextOffsetY = 0;
  static const double kParchmentTextPad = 36;
  static const double kButtonHeightScale = 1.0;
  static const double kTitleLineHeight = 1.2;
  static const double kBodyLineHeight = 1.4;
  static const double kOverlayOpacity = 0;
  static const double ovalAspect = 551 / 176;
  static const double ovalSideInset = 22;

  static PlayUiTune get _tune => PlayUiTune.instance;
  static PlayUiTarget _target = PlayUiTarget.common;
  static String _localeId = 'ko';

  static PlayUiTarget get currentTarget => _target;

  static T using<T>(
    PlayUiTarget target,
    T Function() build, {
    Locale? locale,
  }) {
    final previous = _target;
    final previousLocale = _localeId;
    _target = target;
    if (locale != null) {
      _localeId = PlayUiTune.localeIdFrom(locale);
    }
    try {
      return build();
    } finally {
      _target = previous;
      _localeId = previousLocale;
    }
  }

  static double _v(String key) {
    if (_tune.previewReads) {
      return _tune.read(key, _tune.editingTarget, locale: _tune.editingLocale);
    }
    return _tune.read(key, _target, locale: _localeId);
  }

  /// Bind static reads to the nearest [PlayUiScope] (safe inside LayoutBuilder).
  static void applyScope(BuildContext context) {
    final scope = PlayUiScope.maybeOf(context);
    if (scope == null) return;
    _target = scope.target;
    _localeId = scope.localeId;
  }

  static double get caption => _v('caption');
  static double get body => _v('body');
  static double get label => _v('label');
  static double get button => _v('button');
  static double get title => _v('title');
  static double get modalInset => _v('modalInset');
  static double get modalPadX => _v('modalPadX');
  static double get modalPadY => _v('modalPadY');
  /// Short confirm modals: parchment bottom art is heavier; bump top.
  static double get modalPadTop {
    switch (currentTarget) {
      case PlayUiTarget.giveUp:
      case PlayUiTarget.trialEnd:
        return modalPadY + 8;
      default:
        return modalPadY;
    }
  }
  static double get modalPadBottom => modalPadY;
  static double get modalMinWidth => _v('modalMinWidth');
  static double get modalMaxWidth => _v('modalMaxWidth');
  static double get rowGap => _v('rowGap');
  static double get buttonMaxWidth => _v('buttonMaxWidth');
  static double get buttonMinWidth => _v('buttonMinWidth');
  static double get ovalEndFraction => _v('ovalEndFraction');
  static double get screenPad => _v('screenPad');
  static double get modalInsetY => _v('modalInsetY');
  static double get modalOffsetX => _v('modalOffsetX');
  static double get modalOffsetY => _v('modalOffsetY');
  static double get buttonTextOffsetX => _v('buttonTextOffsetX');
  static double get buttonTextOffsetY => _v('buttonTextOffsetY');
  static double get parchmentTextPad => _v('parchmentTextPad');
  static double get buttonHeightScale => _v('buttonHeightScale');
  static double get titleLineHeight => _v('titleLineHeight');
  static double get bodyLineHeight => _v('bodyLineHeight');
  static double get overlayOpacity => _v('overlayOpacity');

  static const Color ink = Color(0xFF24452D);
  static const Color muted = Color(0xFF4D6554);
  static const Color gold = Color(0xFFF5CC3D);
  /// Darker gold for day skies. `#F5CC3D` washes out on morning village.
  static const Color goldOnLight = Color(0xFFB57A14);
  static const Color cream = Color(0xFFFBF7EC);

  static TextStyle titleStyle({Color color = ink}) => TextStyle(
        fontSize: title,
        fontWeight: FontWeight.w800,
        color: color,
        height: titleLineHeight,
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

  static TextStyle bodyStyle({Color color = muted}) => TextStyle(
        fontSize: body,
        fontWeight: FontWeight.w500,
        color: color,
        height: bodyLineHeight,
      );

  static TextStyle captionStyle({Color color = muted}) => TextStyle(
        fontSize: caption,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.2,
      );
}

/// Binds the in-app editor to the screen or modal that is actually visible.
class PlayUiBind extends StatefulWidget {
  const PlayUiBind({
    super.key,
    required this.target,
    required this.child,
  });

  final PlayUiTarget target;
  final Widget child;

  @override
  State<PlayUiBind> createState() => _PlayUiBindState();
}

class _PlayUiBindState extends State<PlayUiBind> {
  @override
  void initState() {
    super.initState();
    PlayUiTune.instance.pushTarget(widget.target);
  }

  @override
  void didUpdateWidget(PlayUiBind oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target == widget.target) return;
    PlayUiTune.instance.popTarget(oldWidget.target);
    PlayUiTune.instance.pushTarget(widget.target);
  }

  @override
  void dispose() {
    PlayUiTune.instance.popTarget(widget.target);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Builds while [PlayUi] getters read [target]. Use for modal titles/body.
class PlayUiTokens extends StatelessWidget {
  const PlayUiTokens({
    super.key,
    required this.target,
    required this.builder,
  });

  final PlayUiTarget target;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PlayUiTune.instance,
      builder: (context, _) {
        return PlayUi.using(
          target,
          () => builder(context),
          locale: Localizations.localeOf(context),
        );
      },
    );
  }
}

/// Lets parchment buttons read the wrapping modal's target after [using] returns.
class PlayUiScope extends InheritedWidget {
  const PlayUiScope({
    required this.target,
    required this.localeId,
    required super.child,
    super.key,
  });

  final PlayUiTarget target;
  final String localeId;

  static PlayUiScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PlayUiScope>();

  @override
  bool updateShouldNotify(PlayUiScope oldWidget) =>
      target != oldWidget.target || localeId != oldWidget.localeId;
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

/// Oval chrome from width sliders. Font does not grow the button.
class OvalButtonLayout {
  const OvalButtonLayout({
    required this.width,
    required this.height,
    required this.fontSize,
    required this.sideInset,
    this.maxLines = 2,
  });

  final double width;
  final double height;
  final double fontSize;
  final double sideInset;
  final int maxLines;

  static OvalButtonLayout forLabel(
    String label, {
    required TextDirection direction,
    double preferredFontSize = PlayUi.kButton,
    double maxWidth = PlayUi.kButtonMaxWidth,
    double? heightScale,
    Color color = PlayUi.ink,
  }) {
    final width = math.max(1.0, maxWidth);
    final sideInset = width * PlayUi.ovalEndFraction;
    final height =
        (width / PlayUi.ovalAspect) * (heightScale ?? PlayUi.buttonHeightScale);
    return OvalButtonLayout(
      width: width,
      height: height,
      fontSize: preferredFontSize,
      sideInset: sideInset,
      maxLines: 2,
    );
  }
}
