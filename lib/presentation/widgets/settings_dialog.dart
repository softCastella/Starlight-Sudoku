import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/config/play_ui.dart';
import 'package:sudoku_game/presentation/config/play_ui_target.dart';
import 'package:sudoku_game/presentation/config/play_ui_tune.dart';
import 'package:sudoku_game/presentation/notifiers/app_settings.dart';
import 'package:sudoku_game/presentation/screens/play_ui_tune_screen.dart';
import 'package:sudoku_game/presentation/widgets/credits_dialog.dart';
import 'package:sudoku_game/presentation/widgets/parchment_modal.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierColor: const Color(0xCC152433),
      builder: (context) => const SettingsDialog(),
    );
  }

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool _copied = false;

  Future<void> _copyUserId(String userId) async {
    await Clipboard.setData(ClipboardData(text: userId));
    if (!mounted) return;
    setState(() => _copied = true);
  }

  Future<void> _openPrivacy() async {
    final locale = Localizations.localeOf(context);
    final uri = Uri.parse(AppSettings.privacyPolicyUrlFor(locale));
    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10nOf(context).settingsPrivacyOpenError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlayUiTokens(
      target: PlayUiTarget.settings,
      builder: (context) {
        final l10n = l10nOf(context);
        final settings = context.watch<AppSettings>();

        // Hug content height (web has no user-id row). Do not lock 0.98.
        return ParchmentModal(
          target: PlayUiTarget.settings,
          alignment: Alignment.topCenter,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Same top air as the old 0.98 window: 12% of (width / 0.98).
              // Baked settings padY 16 was for tall fixed windows — when hugging,
              // pad the content bottom up to common 40 so the scroll art clears.
              final topAir = constraints.maxWidth.isFinite
                  ? (constraints.maxWidth / 0.98) * 0.12
                  : PlayUi.modalPadY;
              final bottomAir =
                  (PlayUi.kModalPadY - PlayUi.modalPadBottom).clamp(0.0, 40.0);
              return Padding(
                padding: EdgeInsets.only(top: topAir, bottom: bottomAir),
                child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FitLabel(
            l10n.settingsTitle,
            style: PlayUi.titleStyle(),
            alignment: Alignment.center,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: PlayUi.rowGap * 0.75),
          _SettingsSwitchRow(
            label: l10n.settingsBgm,
            value: settings.bgmEnabled,
            onChanged: settings.setBgmEnabled,
          ),
          _SettingsSwitchRow(
            label: l10n.settingsSfx,
            value: settings.sfxEnabled,
            onChanged: settings.setSfxEnabled,
          ),
          SizedBox(height: PlayUi.rowGap * 1.5),
          // Web demo is one-shot: no anonymous device id row.
          if (!kIsWeb) ...[
            Row(
              children: [
                Text(
                  l10n.settingsUserId,
                  style: PlayUi.captionStyle(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    settings.userId.isEmpty ? '—' : settings.userId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: PlayUi.labelStyle(color: PlayUi.ink).copyWith(
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: settings.userId.isEmpty
                      ? null
                      : () => _copyUserId(settings.userId),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      _copied ? Icons.check : Icons.copy,
                      size: 18,
                      color: _copied ? PlayUi.gold : PlayUi.muted,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: PlayUi.rowGap),
          ],
          GestureDetector(
            onTap: _openPrivacy,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    l10n.settingsPrivacyPolicy,
                    maxLines: 2,
                    style: PlayUi.labelStyle(color: PlayUi.ink).copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: PlayUi.ink,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: PlayUi.muted,
                ),
              ],
            ),
          ),
          SizedBox(height: PlayUi.rowGap),
          GestureDetector(
            onTap: () => CreditsDialog.show(context),
            onLongPress: PlayUiTune.isEditorEnabled
                ? () => PlayUiTuneScreen.open(context)
                : null,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.settingsCredits,
                style: PlayUi.labelStyle(color: PlayUi.ink).copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: PlayUi.ink,
                ),
              ),
            ),
          ),
          SizedBox(height: PlayUi.rowGap * 1.5),
          ParchmentModalButton(
            asset: ParchmentModal.continueAsset,
            label: l10n.close,
            color: PlayUi.ink,
            onPressed: () => Navigator.pop(context),
          ),
        ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: FitLabel(
              label,
              style: PlayUi.labelStyle(),
            ),
          ),
          Transform.scale(
            scale: 0.82,
            alignment: Alignment.centerRight,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeThumbColor: PlayUi.gold,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
