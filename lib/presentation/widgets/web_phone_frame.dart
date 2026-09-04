import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_game/presentation/widgets/twinkling_star_field.dart';

/// Desktop web demo sits in one phone frame. Real phones fill the screen.
/// APK/fold is unchanged (not wrapped).
class WebPhoneFrame extends StatelessWidget {
  const WebPhoneFrame({super.key, required this.child});

  static const double phoneWidth = 390;
  static const double phoneHeight = 844;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    final size = MediaQuery.sizeOf(context);
    final alreadyPhone = size.width <= phoneWidth + 48;

    if (alreadyPhone) return child;

    return ColoredBox(
      color: TwinklingStarField.nightSky,
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: phoneWidth,
            height: phoneHeight,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                size: const Size(phoneWidth, phoneHeight),
                padding: const EdgeInsets.only(top: 24, bottom: 12),
                viewPadding: const EdgeInsets.only(top: 24, bottom: 12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
