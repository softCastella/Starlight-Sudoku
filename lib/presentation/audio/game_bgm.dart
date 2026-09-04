import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Title gets one track. Difficulty through stage select share one other track.
/// Switching scenes kills every live player so old audio cannot linger.
class GameBgm {
  GameBgm._();

  static const titleAsset = 'audio/BGM/1_Title_Lamplight Grid.ogg';
  static const levelAsset = 'audio/BGM/2_Level_Starfall Grid.ogg';
  static const fadeInDuration = Duration(milliseconds: 600);

  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  static final Set<AudioPlayer> _live = {};
  static AudioPlayer? _player;
  static Timer? _fadeTimer;
  static String? _current;
  static String? _wanted;
  static double _volume = 0;
  static bool _enabled = true;
  static bool _silencedForBackground = false;
  static Future<void> _chain = Future.value();

  static Future<void> setEnabled(bool on) {
    _enabled = on;
    if (!on) return _enqueue(_killAll);
    if (_silencedForBackground) return Future<void>.value();
    final wanted = _wanted;
    if (wanted == null) return Future<void>.value();
    return _enqueue(() => _play(wanted));
  }

  static Future<void> playTitle() => _setWanted(titleAsset);
  static Future<void> playLevel() => _setWanted(levelAsset);

  static Future<void> fadeOut() {
    _wanted = null;
    return _enqueue(_killAll);
  }

  static Future<void> silenceForBackground() {
    if (const bool.fromEnvironment('FLUTTER_TEST')) {
      return Future<void>.value();
    }
    if (_silencedForBackground) return Future<void>.value();
    _silencedForBackground = true;
    return _enqueue(() async {
      _fadeTimer?.cancel();
      _fadeTimer = null;
      final player = _player;
      if (player == null) return;
      try {
        await player.setVolume(0);
        await player.pause();
      } catch (_) {
        await _killAll();
      }
    });
  }

  static Future<void> restoreFromBackground() {
    if (const bool.fromEnvironment('FLUTTER_TEST')) {
      return Future<void>.value();
    }
    if (!_silencedForBackground) return Future<void>.value();
    _silencedForBackground = false;
    if (!_enabled) return Future<void>.value();
    final wanted = _wanted;
    if (wanted == null) return Future<void>.value();
    return _enqueue(() async {
      final player = _player;
      if (player != null && _current == wanted) {
        try {
          await player.resume();
          await player.setVolume(_volume.clamp(0.2, 1));
          return;
        } catch (_) {}
      }
      await _play(wanted);
    });
  }

  static Future<void> unlock() {
    if (const bool.fromEnvironment('FLUTTER_TEST')) {
      return Future<void>.value();
    }
    if (!_enabled) return Future<void>.value();
    if (_silencedForBackground) return Future<void>.value();
    final wanted = _wanted;
    if (wanted == null) return Future<void>.value();
    if (_isHolding(wanted)) return Future<void>.value();
    return _enqueue(() => _play(wanted));
  }

  static Future<void> _setWanted(String asset) {
    _wanted = asset;
    return _enqueue(() => _play(asset));
  }

  static Future<void> _enqueue(Future<void> Function() job) {
    final done = Completer<void>();
    _chain = _chain.then((_) => job()).whenComplete(done.complete);
    return done.future;
  }

  static bool _isHolding(String asset) =>
      _wanted == asset &&
      _current == asset &&
      _player != null &&
      _live.length == 1 &&
      _live.contains(_player);

  static Future<void> _play(String asset) async {
    if (const bool.fromEnvironment('FLUTTER_TEST')) return;
    if (_wanted != asset) return;
    if (!_enabled) {
      await _killAll();
      return;
    }
    if (_silencedForBackground) return;
    if (_isHolding(asset)) return;

    await _killAll();
    if (_wanted != asset) return;

    final player = AudioPlayer();
    _live.add(player);
    _player = player;
    _current = asset;
    _volume = 0;
    await player.setReleaseMode(ReleaseMode.loop);
    await player.setVolume(0);
    try {
      await player.play(AssetSource(asset));
    } catch (_) {
      await _killAll();
      return;
    }
    if (_wanted != asset || !identical(_player, player)) {
      await _disposePlayer(player);
      return;
    }
    await _fade(player, 0, 1, fadeInDuration);
  }

  static Future<void> _killAll() async {
    _fadeTimer?.cancel();
    _fadeTimer = null;
    _current = null;
    _volume = 0;
    _player = null;
    final players = _live.toList();
    _live.clear();
    for (final player in players) {
      await _disposePlayer(player);
    }
  }

  static Future<void> _disposePlayer(AudioPlayer player) async {
    _live.remove(player);
    try {
      await player.setVolume(0);
      await player.stop();
      await player.release();
      await player.dispose();
    } catch (_) {}
  }

  static Future<void> _fade(
    AudioPlayer player,
    double from,
    double target,
    Duration duration,
  ) async {
    _fadeTimer?.cancel();
    const steps = 8;
    final stepMs = (duration.inMilliseconds / steps).round().clamp(16, 80);
    var i = 0;
    final completer = Completer<void>();
    _fadeTimer = Timer.periodic(Duration(milliseconds: stepMs), (timer) {
      if (!identical(_player, player)) {
        timer.cancel();
        if (!completer.isCompleted) completer.complete();
        return;
      }
      i++;
      _volume = (from + (target - from) * (i / steps)).clamp(0, 1);
      player.setVolume(_volume);
      if (i >= steps) {
        timer.cancel();
        if (!completer.isCompleted) completer.complete();
      }
    });
    await completer.future;
  }
}

enum BgmCue { title, level, silence }

/// Applies a BGM cue while this route is on top.
class BgmScope extends StatefulWidget {
  const BgmScope({
    super.key,
    required this.cue,
    required this.child,
  });

  final BgmCue cue;
  final Widget child;

  @override
  State<BgmScope> createState() => _BgmScopeState();
}

class _BgmScopeState extends State<BgmScope> with RouteAware {
  ModalRoute<void>? _route;
  var _applied = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute && route != _route) {
      if (_route != null) GameBgm.routeObserver.unsubscribe(this);
      GameBgm.routeObserver.subscribe(this, route);
      _route = route;
      if (!_applied) {
        _applied = true;
        _apply();
      }
    }
  }

  @override
  void dispose() {
    GameBgm.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    if (_applied) return;
    _applied = true;
    _apply();
  }

  @override
  void didPopNext() => _apply();

  void _apply() {
    switch (widget.cue) {
      case BgmCue.title:
        GameBgm.playTitle();
      case BgmCue.level:
        GameBgm.playLevel();
      case BgmCue.silence:
        GameBgm.fadeOut();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
