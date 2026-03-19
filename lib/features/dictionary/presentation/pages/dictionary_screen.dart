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
  ConsumerState<DictionaryScreen> createState() =>
      _DictionaryScreenState();
}

class _DictionaryScreenState
    extends ConsumerState<DictionaryScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.microtask(() {
      ref.read(wordsVmProvider.notifier).loadWords();
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(wordsVmProvider.notifier).loadWords();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        title: Text(l10n.tabDictionary),
        actions: [
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
          )
        ]
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
