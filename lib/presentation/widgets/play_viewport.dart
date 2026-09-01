import 'package:flutter/material.dart';

/// Keeps web and desktop layouts at a phone-like width so the board stays playable.
class PlayViewport extends StatelessWidget {
  static const double maxWidth = 460;

  const PlayViewport({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
