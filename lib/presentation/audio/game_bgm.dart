import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Looped scene BGM with fade-in at the start and fade-out at the end.
class GameBgm {
  GameBgm._();

  static const titleAsset = 'audio/BGM/1_Title_Lamplight Grid.ogg';
  static const levelAsset = 'audio/BGM/2_Level_Starfall Grid.ogg';
  static const fadeDuration = Duration(milliseconds: 1400);

  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  static AudioPlayer? _player;
  static StreamSubscription<Duration>? _positionSub;
  static StreamSubscription<Duration>? _durationSub;
  static Timer? _fadeTimer;
  static String? _current;
  static int _generation = 0;
  static double _volume = 0;
  static Duration _lastPosition = Duration.zero;
  static Duration? _clipDuration;

  static Future<void> playTitle() => _play(titleAsset);
  static Future<void> playLevel() => _play(levelAsset);
  static Future<void> fadeOut() => _stop(fade: true);

  static Future<void> _play(String asset) async {
    if (const bool.fromEnvironment('FLUTTER_TEST')) return;
    if (_current == asset && _player != null) return;

    final generation = ++_generation;
    await _stop(fade: _player != null);
    if (generation != _generation) return;

    _current = asset;
    _lastPosition = Duration.zero;
    _clipDuration = null;
    final player = AudioPlayer();
    _player = player;
    await player.setReleaseMode(ReleaseMode.loop);
    await player.setVolume(0);
    _volume = 0;
    await player.play(AssetSource(asset));
    if (generation != _generation) return;
    _clipDuration = await player.getDuration();
    await _fadeTo(1, fadeDuration, generation);

    await _positionSub?.cancel();
    await _durationSub?.cancel();
    _durationSub = player.onDurationChanged.listen((duration) {
      if (generation == _generation) _clipDuration = duration;
    });
    _positionSub = player.onPositionChanged.listen((position) {
      if (generation != _generation) return;
      final duration = _clipDuration;
      if (duration == null || duration <= Duration.zero) {
        _lastPosition = position;
        return;
      }

      if (position < _lastPosition) {
        _volume = 0;
        player.setVolume(0);
        _fadeTo(1, fadeDuration, generation);
        _lastPosition = position;
        return;
      }
      _lastPosition = position;

      final fadeFor = duration < fadeDuration ? duration : fadeDuration;
      final remaining = duration - position;
      if (remaining > Duration.zero && remaining <= fadeFor) {
        final volume = remaining.inMilliseconds / fadeFor.inMilliseconds;
        _volume = volume.clamp(0, 1);
        player.setVolume(_volume);
      }
    });
  }

  static Future<void> _stop({required bool fade}) async {
    _fadeTimer?.cancel();
    await _positionSub?.cancel();
    _positionSub = null;
    await _durationSub?.cancel();
    _durationSub = null;
    final player = _player;
    _player = null;
    _current = null;
    if (player == null) return;
    if (fade && _volume > 0) {
      await _fadePlayer(player, _volume, 0, fadeDuration);
    }
    await player.stop();
    await player.dispose();
  }

  static Future<void> _fadeTo(
    double target,
    Duration duration,
    int generation,
  ) async {
    final player = _player;
    if (player == null) return;
    await _fadePlayer(player, _volume, target, duration, generation);
  }

  static Future<void> _fadePlayer(
    AudioPlayer player,
    double from,
    double target,
    Duration duration, [
    int? generation,
  ]) async {
    _fadeTimer?.cancel();
    const steps = 18;
    final stepMs = (duration.inMilliseconds / steps).round().clamp(16, 120);
    var i = 0;
    final completer = Completer<void>();
    _fadeTimer = Timer.periodic(Duration(milliseconds: stepMs), (timer) {
      if (generation != null && generation != _generation) {
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute && route != _route) {
      if (_route != null) GameBgm.routeObserver.unsubscribe(this);
      GameBgm.routeObserver.subscribe(this, route);
      _route = route;
      _apply();
    }
  }

  @override
  void dispose() {
    GameBgm.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() => _apply();

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
