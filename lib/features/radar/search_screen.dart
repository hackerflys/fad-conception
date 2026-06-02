import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/demo_data.dart';
import '../../core/design/fad_colors.dart';
import '../../core/widgets/duo_icon.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/fad_common.dart';
import '../../l10n/l10n_ext.dart';
import 'widgets/signal_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final l = context.l10n;
    final signals = ref.watch(signalsProvider);
    final results = _query.isEmpty
        ? signals
        : signals.where((s) => s.title.toLowerCase().contains(_query.toLowerCase())).toList();

    return FadScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(FadGap.lg),
              child: Row(children: [
                FadIconButton(icon: FadIcons.back, onTap: () => context.pop()),
                const SizedBox(width: FadGap.sm),
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: FadGap.md),
                    decoration: BoxDecoration(
                      borderRadius: FadRadius.rPill,
                      color: c.surface,
                      border: Border.all(color: c.surfaceBorder),
                    ),
                    child: Row(children: [
                      DuoIcon(FadIcons.search, size: 20, color: c.textLow),
                      const SizedBox(width: FadGap.xs),
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          onChanged: (v) => setState(() => _query = v),
                          style: Theme.of(context).textTheme.bodyLarge,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hintText: l.radarSearchHint,
                            hintStyle: TextStyle(color: c.textLow),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(FadGap.lg, 0, FadGap.lg, 120),
                itemCount: results.length,
                separatorBuilder: (_, __) => const SizedBox(height: FadGap.sm),
                itemBuilder: (_, i) => SignalCard(signal: results[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
