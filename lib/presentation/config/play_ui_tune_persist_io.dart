import 'dart:io';

const _androidExportDir =
    '/storage/emulated/0/Android/data/com.tychespark.starlightsudoku/files';

/// Writes tuner JSON where USB can pull it. SharedPreferences stay private.
///
/// Android: `.../Android/data/<package>/files/play_ui_tune.json`
/// Windows: `play_ui_layout.json` in the process working directory.
Future<String?> savePlayUiLayout(String json) async {
  if (Platform.environment.containsKey('FLUTTER_TEST')) return null;
  String? path;
  if (Platform.isAndroid) {
    try {
      final dir = Directory(_androidExportDir);
      dir.createSync(recursive: true);
      final file = File('${dir.path}/play_ui_tune.json');
      file.writeAsStringSync(json);
      path = file.path;
    } catch (_) {}
  }
  try {
    const name = 'play_ui_layout.json';
    File(name).writeAsStringSync(json);
    path ??= name;
  } catch (_) {}
  return path;
}
