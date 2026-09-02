import 'dart:io';

void saveIconLayout(String json) {
  File('icon_layout.json').writeAsStringSync(json);
}
