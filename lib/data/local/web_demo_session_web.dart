import 'package:web/web.dart' as web;

const _sessionKey = 'starlight_web_demo_progress_session_v1';

/// Returns true once per browser-tab session.
///
/// sessionStorage survives a reload in the same tab, but normally disappears
/// when that tab is closed. That makes a public demo restart for a new visit
/// without turning an accidental reload into progress loss.
bool beginWebDemoSession() {
  try {
    final storage = web.window.sessionStorage;
    if (storage.getItem(_sessionKey) != null) return false;
    storage.setItem(_sessionKey, 'active');
    return true;
  } catch (_) {
    // If sessionStorage is unavailable, preserve progress instead of deleting
    // it on every load.
    return false;
  }
}
