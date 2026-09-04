import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/l10n/l10n_ext.dart';
import 'package:sudoku_game/presentation/notifiers/app_settings.dart';
import 'package:sudoku_game/presentation/widgets/parchment_modal.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  static const _ink = Color(0xFF24452D);
  static const _muted = Color(0xFF4D6554);
  static const _gold = Color(0xFFF5CC3D);

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
    final uri = Uri.parse(AppSettings.privacyPolicyUrl);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10nOf(context).settingsPrivacyOpenError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nOf(context);
    final settings = context.watch<AppSettings>();

    return ParchmentModal(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.settingsTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: SettingsDialog._ink,
            ),
          ),
          const SizedBox(height: 8),
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
          _SettingsLine(
            label: l10n.settingsUserId,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    settings.userId.isEmpty ? '—' : settings.userId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: SettingsDialog._ink,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: settings.userId.isEmpty
                      ? null
                      : () => _copyUserId(settings.userId),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      _copied ? Icons.check : Icons.copy,
                      size: 16,
                      color: _copied
                          ? SettingsDialog._gold
                          : SettingsDialog._muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: _openPrivacy,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.settingsPrivacyPolicy,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: SettingsDialog._ink,
                        decoration: TextDecoration.underline,
                        decorationColor: SettingsDialog._ink,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: SettingsDialog._muted,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ParchmentModalButton(
            asset: ParchmentModal.continueAsset,
            label: l10n.close,
            color: SettingsDialog._ink,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
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
    return _SettingsLine(
      label: label,
      child: Align(
        alignment: Alignment.centerRight,
        child: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeThumbColor: SettingsDialog._gold,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  const _SettingsLine({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: SettingsDialog._muted,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
