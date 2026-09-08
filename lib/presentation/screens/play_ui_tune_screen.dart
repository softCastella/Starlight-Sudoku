import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/l10n/app_localizations.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/app_navigator.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';
import 'package:sudoku_game/presentation/notifiers/app_settings.dart';
import 'package:sudoku_game/presentation/notifiers/locale_override.dart';
import 'package:sudoku_game/presentation/widgets/completion_reward_dialog.dart';
import 'package:sudoku_game/presentation/widgets/credits_dialog.dart';
import 'package:sudoku_game/presentation/widgets/exit_game_dialog.dart';
import 'package:sudoku_game/presentation/widgets/give_up_puzzle_dialog.dart';
import 'package:sudoku_game/presentation/widgets/oval_image_button.dart';
import 'package:sudoku_game/presentation/widgets/parchment_button.dart';
import 'package:sudoku_game/presentation/widgets/play_ui_tuner_panel.dart';
import 'package:sudoku_game/presentation/widgets/settings_dialog.dart';
import 'package:sudoku_game/presentation/widgets/trial_end_dialog.dart';

/// Full-page editor: live preview on top, sliders below. Does not cover the game.
class PlayUiTuneScreen extends StatefulWidget {
  const PlayUiTuneScreen({super.key});

  static Future<void> open(BuildContext context) {
    if (!PlayUiTune.isEditorEnabled) return Future<void>.value();
    final tune = PlayUiTune.instance;
    if (tune.editingTarget == PlayUiTarget.common) {
      tune.setEditingTarget(PlayUiTarget.titleButton);
    }
    final navContext = appNavigatorKey.currentContext ?? context;
    return Navigator.of(navContext, rootNavigator: true).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => const PlayUiTuneScreen(),
      ),
    );
  }

  static const _targets = [
    PlayUiTarget.titleButton,
    PlayUiTarget.openingButton,
    PlayUiTarget.villageButton,
    PlayUiTarget.bgmGate,
    PlayUiTarget.settings,
    PlayUiTarget.credits,
    PlayUiTarget.exitGame,
    PlayUiTarget.giveUp,
    PlayUiTarget.completionReward,
    PlayUiTarget.trialEnd,
  ];

  @override
  State<PlayUiTuneScreen> createState() => _PlayUiTuneScreenState();
}

class _PlayUiTuneScreenState extends State<PlayUiTuneScreen> {
  @override
  void initState() {
    super.initState();
    PlayUiTune.instance.setPreviewReads(true);
  }

  @override
  void dispose() {
    PlayUiTune.instance.setPreviewReads(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PlayUiTune.instance,
      builder: (context, _) {
        final tune = PlayUiTune.instance;
        return Scaffold(
          backgroundColor: const Color(0xFF0E2040),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1C2833),
            foregroundColor: PlayUiTunerPanel.cream,
            title: const Text('UI 편집'),
            actions: [
              TextButton(
                onPressed: tune.restoreCurrentFromCheckpoint,
                child: const Text('이 화면'),
              ),
              TextButton(
                onPressed: () => _confirmReset(context, tune),
                child: const Text('초기화'),
              ),
              const _SaveTuneButton(),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    for (final locale in PlayUiTune.localeIds)
                      _Chip(
                        id: 'tune-locale-$locale',
                        label: PlayUiTune.localeLabel(locale),
                        selected: tune.editingLocale == locale,
                        onTap: () => _selectLocale(context, tune, locale),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      for (final target in PlayUiTuneScreen._targets)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: _Chip(
                            id: 'tune-target-${target.id}',
                            label: target.labelKo,
                            selected: tune.editingTarget == target,
                            onTap: () => tune.setEditingTarget(target),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ColoredBox(
                  color: const Color(0xFF0B1A33),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const phone = Size(360, 640);
                      return FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          key: const Key('tune-preview'),
                          width: phone.width,
                          height: phone.height,
                          child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(size: phone),
                            child: Localizations.override(
                              context: context,
                              locale: PlayUiTune.localeFromId(tune.editingLocale),
                              child: Builder(
                                builder: (context) {
                                  return IgnorePointer(
                                    child: PlayUiScope(
                                      target: tune.editingTarget,
                                      localeId: tune.editingLocale,
                                      child: _preview(l10nOf(context)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Expanded(
                flex: 2,
                child: PlayUiTunerPanel(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _preview(AppLocalizations l10n) {
    final target = PlayUiTune.instance.editingTarget;
    return switch (target) {
      PlayUiTarget.titleButton => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ParchmentButton(label: l10n.startNewPuzzle, onPressed: () {}),
            const SizedBox(height: 10),
            ParchmentButton(label: l10n.continueGame, onPressed: () {}),
            const SizedBox(height: 10),
            ParchmentButton(label: l10n.viewVillage, onPressed: () {}),
          ],
        ),
      PlayUiTarget.openingButton => Center(
          child: OvalImageButton(
            label: l10n.lightFirstWindow,
            target: PlayUiTarget.openingButton,
            onPressed: () {},
          ),
        ),
      PlayUiTarget.villageButton => Center(
          child: OvalImageButton(
            label: l10n.mission,
            target: PlayUiTarget.villageButton,
            onPressed: () {},
          ),
        ),
      PlayUiTarget.bgmGate => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OvalImageButton(
              label: 'BGM ON',
              target: PlayUiTarget.bgmGate,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            OvalImageButton(
              label: 'BGM OFF',
              target: PlayUiTarget.bgmGate,
              onPressed: () {},
            ),
          ],
        ),
      PlayUiTarget.settings => const _SettingsPreview(),
      PlayUiTarget.credits => const CreditsDialog(),
      PlayUiTarget.exitGame => const ExitGameDialog(),
      PlayUiTarget.giveUp => const GiveUpPuzzleDialog(),
      PlayUiTarget.completionReward => CompletionRewardDialog(
          starLight: 10,
          elapsedTimeLabel: '1:20',
          onViewVillage: () {},
          onClose: () {},
        ),
      PlayUiTarget.trialEnd => const TrialEndDialog(),
      PlayUiTarget.common => const SizedBox.shrink(),
    };
  }

  void _selectLocale(BuildContext context, PlayUiTune tune, String locale) {
    tune.setEditingLocale(locale);
    try {
      context.read<LocaleOverride>().setOverride(PlayUiTune.localeFromId(locale));
    } on ProviderNotFoundException {
      // Widget tests mount the screen without app providers.
    }
  }

  Future<void> _confirmReset(BuildContext context, PlayUiTune tune) async {
    const cream = PlayUiTunerPanel.cream;
    final action = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C2833),
        title: const Text('초기화', style: TextStyle(color: cream)),
        content: Text(
          '${tune.editingTarget.labelKo}만 기본값으로 되돌립니다. 저장해 둔 다른 화면·언어는 그대로입니다.',
          style: const TextStyle(color: cream),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'all'),
            child: const Text('모든 화면'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'one'),
            child: const Text('이 화면만'),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    if (action == 'one') {
      tune.resetCurrent();
      return;
    }
    if (action != 'all') return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C2833),
        title: const Text('모든 화면', style: TextStyle(color: cream)),
        content: const Text(
          '맞춘 값 전부가 기본값으로 돌아갑니다.',
          style: TextStyle(color: cream),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('지우기'),
          ),
        ],
      ),
    );
    if (confirmed == true) tune.reset();
  }
}

class _SettingsPreview extends StatelessWidget {
  const _SettingsPreview();

  @override
  Widget build(BuildContext context) {
    try {
      context.read<AppSettings>();
      return const SettingsDialog();
    } on ProviderNotFoundException {
      return ChangeNotifierProvider(
        create: (_) => AppSettings(),
        child: const SettingsDialog(),
      );
    }
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.id,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String id;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? PlayUi.gold : const Color(0xFF2C3A48),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        key: Key(id),
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? PlayUiTunerPanel.navy : PlayUiTunerPanel.cream,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _SaveTuneButton extends StatefulWidget {
  const _SaveTuneButton();

  @override
  State<_SaveTuneButton> createState() => _SaveTuneButtonState();
}

class _SaveTuneButtonState extends State<_SaveTuneButton> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await PlayUiTune.instance.saveNow();
        await Clipboard.setData(
          ClipboardData(text: PlayUiTune.instance.layoutJson),
        );
        if (!mounted) return;
        setState(() => _saved = true);
        await Future<void>.delayed(const Duration(seconds: 2));
        if (mounted) setState(() => _saved = false);
      },
      child: Text(_saved ? '저장됨' : '저장'),
    );
  }
}

/// Bottom-left tab that opens the full editor page.
class PlayUiTuneHandle extends StatelessWidget {
  const PlayUiTuneHandle({super.key});

  @override
  Widget build(BuildContext context) {
    if (!PlayUiTune.isEditorEnabled) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.bottomLeft,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
          child: Material(
            color: PlayUi.gold,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              key: const Key('tune-open-handle'),
              onTap: () {
                final navContext = appNavigatorKey.currentContext ?? context;
                PlayUiTuneScreen.open(navContext);
              },
              borderRadius: BorderRadius.circular(16),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Text(
                  'UI',
                  style: TextStyle(
                    color: PlayUiTunerPanel.navy,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
