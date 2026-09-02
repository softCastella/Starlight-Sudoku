import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

bool _armed = false;

/// Keeps an extra browser history entry so the phone back button pops Flutter
/// routes instead of leaving the page.
void interceptWebBackButton(GlobalKey<NavigatorState> navigatorKey) {
  if (_armed) return;
  _armed = true;

  final href = web.window.location.href;
  web.window.history.pushState(null, '', href);

  web.window.addEventListener(
    'popstate',
    (web.Event _) {
      web.window.history.pushState(null, '', web.window.location.href);
      final nav = navigatorKey.currentState;
      if (nav != null) {
        unawaited(nav.maybePop());
      }
    }.toJS,
  );
}
