import 'dart:io';

void saveTitleButtonLayout(String json) {
  File('title_button_layout.json').writeAsStringSync(json);
}
