import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';

/// Live sliders for parchment, oval buttons, and type. Hidden from store chrome.
class PlayUiTunerPanel extends StatelessWidget {
  const PlayUiTunerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final tune = PlayUiTune.instance;
    return Material(
      color: const Color(0xF21C2833),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 8, 4),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'UI 여백·크기',
                      style: TextStyle(
                        color: Color(0xFFFBF7EC),
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: tune.reset,
                    child: const Text('초기화'),
                  ),
                  IconButton(
                    tooltip: 'JSON 복사',
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: tune.layoutJson));
                    },
                    icon: const Icon(Icons.copy, color: Color(0xFFFBF7EC), size: 18),
                  ),
                  IconButton(
                    onPressed: () => tune.setPanelOpen(false),
                    icon: const Icon(Icons.close, color: Color(0xFFFBF7EC)),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Text(
                'Credit을 길게 누르면 엽니다. 설정·모달을 연 채로 맞춰 보세요.',
                style: TextStyle(color: Color(0xFFC9D4E0), fontSize: 11, height: 1.3),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                children: [
                  _slider('제목', tune.title, 11, 28, (v) => tune.update((t) => t.title = v)),
                  _slider('버튼 글자', tune.button, 11, 22, (v) => tune.update((t) => t.button = v)),
                  _slider('라벨', tune.label, 11, 22, (v) => tune.update((t) => t.label = v)),
                  _slider('본문', tune.body, 11, 20, (v) => tune.update((t) => t.body = v)),
                  _slider('보조', tune.caption, 11, 18, (v) => tune.update((t) => t.caption = v)),
                  _slider('모달 가로 여백', tune.modalPadX, 16, 72, (v) => tune.update((t) => t.modalPadX = v)),
                  _slider('모달 세로 여백', tune.modalPadY, 16, 72, (v) => tune.update((t) => t.modalPadY = v)),
                  _slider('모달 바깥 간격', tune.modalInset, 8, 48, (v) => tune.update((t) => t.modalInset = v)),
                  _slider('모달 최소 폭', tune.modalMinWidth, 240, 360, (v) => tune.update((t) => t.modalMinWidth = v)),
                  _slider('모달 최대 폭', tune.modalMaxWidth, 320, 520, (v) => tune.update((t) => t.modalMaxWidth = v)),
                  _slider('줄 간격', tune.rowGap, 4, 20, (v) => tune.update((t) => t.rowGap = v)),
                  _slider('버튼 최대 폭', tune.buttonMaxWidth, 96, 280, (v) => tune.update((t) => t.buttonMaxWidth = v)),
                  _slider('버튼 최소 폭', tune.buttonMinWidth, 72, 180, (v) => tune.update((t) => t.buttonMinWidth = v)),
                  _slider('타원 끝(별) 비율', tune.ovalEndFraction, 0.10, 0.28, (v) => tune.update((t) => t.ovalEndFraction = v), divisions: 18),
                  _slider('화면 패딩', tune.screenPad, 8, 36, (v) => tune.update((t) => t.screenPad = v)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged, {
    int? divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label  ${value.toStringAsFixed(value < 1 ? 2 : 0)}',
          style: const TextStyle(color: Color(0xFFFBF7EC), fontSize: 12),
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions ?? (max - min).round().clamp(8, 40),
          activeColor: PlayUi.gold,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
