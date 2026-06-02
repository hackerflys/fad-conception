import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/fad_colors.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/state/app_settings.dart';
import '../../core/widgets/fad_common.dart';
import '../../core/widgets/glass_panel.dart';
import '../../l10n/l10n_ext.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final s = ref.watch(settingsProvider);
    final ctrl = ref.read(settingsProvider.notifier);

    final themeOptions = [
      (ThemeMode.light, FadIcons.sun, l.settingsThemeLight),
      (ThemeMode.dark, FadIcons.moon, l.settingsThemeDark),
      (ThemeMode.system, FadIcons.autoTheme, l.settingsThemeSystem),
    ];

    return FadScaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: FadGap.lg),
          child: FadIconButton(icon: FadIcons.back, onTap: () => context.pop()),
        ),
        title: Text(l.settingsTitle),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(FadGap.lg, kToolbarHeight + 40, FadGap.lg, 120),
          children: [
            SectionHeader(title: l.settingsAppearance),
            GlassPanel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Icon(FadIcons.sun, color: c.accent, size: 18), const SizedBox(width: 8), Text(l.settingsTheme, style: t.titleSmall)]),
                const SizedBox(height: FadGap.sm),
                Row(children: [
                  for (final o in themeOptions)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: FadGap.xs),
                        child: GestureDetector(
                          onTap: () => ctrl.setThemeMode(o.$1),
                          child: AnimatedContainer(
                            duration: FadMotion.fast,
                            padding: const EdgeInsets.symmetric(vertical: FadGap.sm),
                            decoration: BoxDecoration(
                              borderRadius: FadRadius.rSm,
                              gradient: s.themeMode == o.$1 ? c.brandGradient : null,
                              color: s.themeMode == o.$1 ? null : c.surface,
                              border: Border.all(color: c.surfaceBorder),
                            ),
                            child: Column(children: [
                              Icon(o.$2, color: s.themeMode == o.$1 ? c.onPrimary : c.textMid, size: 22),
                              const SizedBox(height: 4),
                              Text(o.$3,
                                  style: t.labelSmall?.copyWith(
                                      color: s.themeMode == o.$1 ? c.onPrimary : c.textMid)),
                            ]),
                          ),
                        ),
                      ),
                    ),
                ]),
              ]),
            ),
            const SizedBox(height: FadGap.sm),
            GlassPanel(
              child: Row(children: [
                Icon(FadIcons.globe, color: c.accent),
                const SizedBox(width: FadGap.sm),
                Expanded(child: Text(l.settingsLanguage, style: t.titleMedium)),
                _LangToggle(
                  current: s.locale?.languageCode,
                  onSelect: (code) => ctrl.setLocale(code == null ? null : Locale(code)),
                ),
              ]),
            ),
            SectionHeader(title: l.settingsData),
            GlassPanel(
              child: Column(children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: s.dataSaver,
                  onChanged: ctrl.setDataSaver,
                  activeThumbColor: c.accent,
                  secondary: Icon(FadIcons.dataSaver, color: c.accent),
                  title: Text(l.settingsDataSaver, style: t.titleMedium),
                ),
                Divider(color: c.surfaceBorder, height: 1),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: s.offlineReading,
                  onChanged: ctrl.setOfflineReading,
                  activeThumbColor: c.accent,
                  secondary: Icon(FadIcons.offline, color: c.accent),
                  title: Text(l.settingsOffline, style: t.titleMedium),
                ),
              ]),
            ),
            SectionHeader(title: l.settingsAbout),
            GlassPanel(
              child: Row(children: [
                Icon(FadIcons.about, color: c.accent),
                const SizedBox(width: FadGap.sm),
                Expanded(child: Text('FAD Conception · v1.0.0', style: t.bodyLarge)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _LangToggle extends StatelessWidget {
  const _LangToggle({required this.current, required this.onSelect});
  final String? current;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    Widget seg(String code, String label) {
      final on = current == code;
      return GestureDetector(
        onTap: () => onSelect(code),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: FadGap.sm, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: FadRadius.rPill,
            gradient: on ? c.brandGradient : null,
          ),
          child: Text(label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: on ? c.onPrimary : c.textMid, fontWeight: FontWeight.w700)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: FadRadius.rPill,
        color: c.surface,
        border: Border.all(color: c.surfaceBorder),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [seg('fr', 'FR'), seg('en', 'EN')]),
    );
  }
}
