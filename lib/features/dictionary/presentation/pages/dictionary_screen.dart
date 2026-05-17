import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../add_words/presentation/pages/add_words_bottomsheet.dart';
import '../state/dictionary_provider.dart';
import '../state/dictionary_state.dart';
import '../widgets/dictionary_content.dart';
import '../widgets/empty_dictionary.dart';

class DictionaryScreen extends ConsumerStatefulWidget {
  const DictionaryScreen({super.key});

  @override
  ConsumerState<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends ConsumerState<DictionaryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(wordsVmProvider.notifier).loadWords(reset: true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.microtask(() {
      ref.read(wordsVmProvider.notifier).loadWords(reset: true);
    });
  }

  Future<void> _confirmClearAll(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.clearDictionaryContent),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.clearDictionaryConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(wordsVmProvider.notifier).clearDictionary();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(wordsVmProvider);
    final hasWords = state is DictionaryData && state.words.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, 
        centerTitle: true,
        title: Text(
          l10n.tabDictionary,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (hasWords)
            IconButton(
              tooltip: 'Очистить словарь',
              icon: Container(
                width: 36,
                height: 36,
                child: const Icon(
                  Icons.delete_sweep_rounded,
                  color: Color(0xFFFF3B30),
                  size: 22,
                ),
              ),
              onPressed: () => _confirmClearAll(context),
            ),
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => const AddWordsMethodBottomSheet(),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const DictionaryBody(),
    );
  }
}

class DictionaryBody extends ConsumerWidget {
  const DictionaryBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wordsVmProvider);

    return switch (state) {
      DictionaryInitialLoading() =>
      const Center(child: CircularProgressIndicator()),

      DictionaryError(:final message) =>
          Center(child: Text(message)),

      DictionaryData(:final words, :final topics, :final isUpdating) =>
          Stack(
            children: [
              words.isEmpty
                  ? const EmptyDictionary()
                  : DictionaryContent(words: words, topics: topics),
              if (isUpdating)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(color: AppColors.accent),
                ),
            ],
          ),

      _ => const SizedBox.shrink(),
    };
  }
}