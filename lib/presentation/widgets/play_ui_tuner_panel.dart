import 'package:flutter/material.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';

/// Slider list for the visible screen. Hosted under [PlayUiTuneScreen].
class PlayUiTunerPanel extends StatelessWidget {
  const PlayUiTunerPanel({super.key});

  static const cream = Color(0xFFFBF7EC);
  static const muted = Color(0xFFC9D4E0);
  static const navy = Color(0xFF1C2833);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PlayUiTune.instance,
      builder: (context, _) {
        final tune = PlayUiTune.instance;
        final target = tune.editingTarget;
        return Material(
          color: const Color(0xF21C2833),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
            children: [
              if (target.usesParchmentButton) ...[
                _section('이 화면 버튼'),
                _slider(tune, '버튼 글자', 'button', 11, 22),
                _slider(tune, '버튼 폭', 'buttonMaxWidth', 96, 280),
                _slider(tune, '두루마리 글자 패딩', 'parchmentTextPad', 16, 64),
                _slider(tune, '버튼 글자 가로', 'buttonTextOffsetX', -24, 24),
                _slider(tune, '버튼 글자 세로', 'buttonTextOffsetY', -24, 24),
              ],
              if (target.usesOvalButton) ...[
                _section('이 화면 버튼'),
                _slider(tune, '버튼 글자', 'button', 11, 22),
                _slider(tune, '버튼 폭', 'buttonMaxWidth', 96, 280),
                _slider(tune, '버튼 높이 배율', 'buttonHeightScale', 0.7, 1.4),
                _slider(tune, '타원 끝(별) 비율', 'ovalEndFraction', 0.10, 0.28),
                _slider(tune, '버튼 글자 가로', 'buttonTextOffsetX', -24, 24),
                _slider(tune, '버튼 글자 세로', 'buttonTextOffsetY', -24, 24),
              ],
              if (target.editsModal) ...[
                _section('이 양피지'),
                _slider(tune, '제목', 'title', 11, 28),
                _slider(tune, '본문', 'body', 11, 20),
                if (target == PlayUiTarget.settings)
                  _slider(tune, '라벨', 'label', 11, 22),
                _slider(tune, '모달 가로 여백', 'modalPadX', 16, 72),
                _slider(tune, '모달 세로 여백', 'modalPadY', 16, 72),
                _slider(tune, '모달 바깥 가로', 'modalInset', 8, 48),
                _slider(tune, '모달 바깥 세로', 'modalInsetY', 8, 72),
                _slider(tune, '모달 최소 폭', 'modalMinWidth', 240, 360),
                _slider(tune, '모달 최대 폭', 'modalMaxWidth', 320, 520),
                _slider(tune, '줄 간격', 'rowGap', 4, 20),
                _slider(tune, '모달 가로 위치', 'modalOffsetX', -48, 48),
                _slider(tune, '모달 세로 위치', 'modalOffsetY', -48, 48),
              ],
              if (!target.editsButtons && !target.editsModal) ...[
                _section('글자'),
                _slider(tune, '제목', 'title', 11, 28),
                _slider(tune, '라벨', 'label', 11, 22),
                _slider(tune, '본문', 'body', 11, 20),
                _slider(tune, '보조', 'caption', 11, 18),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 2),
      child: Text(
        title,
        style: const TextStyle(
          color: PlayUi.gold,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _slider(
    PlayUiTune tune,
    String label,
    String key,
    double min,
    double max,
  ) {
    return _KnobSlider(
      label: label,
      fieldKey: key,
      value: tune.editorValue(key).clamp(min, max),
      min: min,
      max: max,
      onChanged: (next) => tune.setField(key, next),
    );
  }
}

/// Cream circle on a gold track. Material Slider thumbs stay invisible on M3.
class _KnobSlider extends StatelessWidget {
  const _KnobSlider({
    required this.label,
    required this.fieldKey,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  static const thumbSize = 22.0;
  static const trackHeight = 4.0;
  static const hitHeight = 44.0;

  final String label;
  final String fieldKey;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  String get _valueLabel {
    if (value.abs() < 1 && value != 0) return value.toStringAsFixed(2);
    return value.toStringAsFixed(0);
  }

  void _apply(double dx, double width) {
    final usable = (width - thumbSize).clamp(1.0, width);
    final t = ((dx - thumbSize / 2) / usable).clamp(0.0, 1.0);
    onChanged(min + t * (max - min));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label  $_valueLabel',
          style: const TextStyle(color: PlayUiTunerPanel.cream, fontSize: 12),
        ),
        SizedBox(
          height: hitHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final usable = (width - thumbSize).clamp(1.0, width);
              final t = ((value - min) / (max - min)).clamp(0.0, 1.0);
              final left = t * usable;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) => _apply(details.localPosition.dx, width),
                onHorizontalDragUpdate: (details) =>
                    _apply(details.localPosition.dx, width),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: thumbSize / 2,
                      right: thumbSize / 2,
                      top: (hitHeight - trackHeight) / 2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B7C8A),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: SizedBox(height: trackHeight, width: usable),
                      ),
                    ),
                    Positioned(
                      left: thumbSize / 2,
                      width: (t * usable).clamp(0.0, usable),
                      top: (hitHeight - trackHeight) / 2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: PlayUi.gold,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const SizedBox(height: trackHeight),
                      ),
                    ),
                    Positioned(
                      left: left,
                      top: (hitHeight - thumbSize) / 2,
                      child: Container(
                        key: Key('tune-thumb-$fieldKey'),
                        width: thumbSize,
                        height: thumbSize,
                        decoration: BoxDecoration(
                          color: PlayUiTunerPanel.cream,
                          shape: BoxShape.circle,
                          border: Border.all(color: PlayUi.gold, width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x88000000),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
