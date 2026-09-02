import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku_game/presentation/config/icon_layout.dart';

bool get canBakeLauncherIcons => true;

const _targets = <(String, int)>[
  ('web/favicon.png', 32),
  ('web/icons/Icon-192.png', 192),
  ('web/icons/Icon-512.png', 512),
  ('web/icons/Icon-maskable-192.png', 192),
  ('web/icons/Icon-maskable-512.png', 512),
  ('android/app/src/main/res/mipmap-mdpi/ic_launcher.png', 48),
  ('android/app/src/main/res/mipmap-hdpi/ic_launcher.png', 72),
  ('android/app/src/main/res/mipmap-xhdpi/ic_launcher.png', 96),
  ('android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png', 144),
  ('android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png', 192),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png', 20),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png', 40),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png', 60),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png', 29),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png', 58),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png', 87),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png', 40),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png', 80),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png', 120),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png', 120),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png', 180),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png', 76),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png', 152),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png', 167),
  ('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png', 1024),
];

Future<void> bakeLauncherIcons({
  required double scale,
  required bool transparentPad,
}) async {
  final data = await rootBundle.load(IconArt.sourceAsset);
  final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  final frame = await codec.getNextFrame();
  final source = frame.image;

  const masterSize = 1024;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  if (!transparentPad) {
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 1024, 1024),
      Paint()..color = IconArt.padNavy,
    );
  }
  final artSize = masterSize * scale.clamp(0.5, 1.0);
  final offset = (masterSize - artSize) / 2;
  canvas.drawImageRect(
    source,
    Rect.fromLTWH(0, 0, source.width.toDouble(), source.height.toDouble()),
    Rect.fromLTWH(offset, offset, artSize, artSize),
    Paint()..filterQuality = FilterQuality.high,
  );
  final picture = recorder.endRecording();
  final master = await picture.toImage(masterSize, masterSize);

  for (final target in _targets) {
    final bytes = await _pngBytes(master, target.$2);
    File(target.$1)
      ..parent.createSync(recursive: true)
      ..writeAsBytesSync(bytes);
  }

  master.dispose();
  source.dispose();
}

Future<Uint8List> _pngBytes(ui.Image master, int size) async {
  final ui.Image image;
  if (size == master.width) {
    image = master;
  } else {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImageRect(
      master,
      Rect.fromLTWH(0, 0, master.width.toDouble(), master.height.toDouble()),
      Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
      Paint()..filterQuality = FilterQuality.high,
    );
    image = await recorder.endRecording().toImage(size, size);
  }
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (image != master) {
    image.dispose();
  }
  return byteData!.buffer.asUint8List();
}
