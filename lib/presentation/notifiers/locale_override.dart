import 'package:flutter/widgets.dart';

/// Session-only locale override for title-screen language testing.
class LocaleOverride extends ChangeNotifier {
  Locale? _override;

  Locale? get override => _override;

  void setOverride(Locale? locale) {
    if (_override == locale) return;
    _override = locale;
    notifyListeners();
  }
}
