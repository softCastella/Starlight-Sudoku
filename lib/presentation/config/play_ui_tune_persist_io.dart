import 'dart:io';

void savePlayUiLayout(String json) {
  File('play_ui_layout.json').writeAsStringSync(json);
}
