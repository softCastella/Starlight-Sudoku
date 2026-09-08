import 'dart:io';

void savePlayUiLayout(String json) {
  try {
    File('play_ui_layout.json').writeAsStringSync(json);
  } catch (_) {
    // Android/iOS app dirs are not a writable project root.
  }
}
