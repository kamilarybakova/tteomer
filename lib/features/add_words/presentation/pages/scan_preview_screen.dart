import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/core/theme/app_colors.dart';
import 'package:tteomer/features/add_words/presentation/widgets/word_item.dart';

import '../../../../l10n/app_localizations.dart';
import '../state/add_words_notifier.dart';

class ScanPreviewScreen extends ConsumerWidget {
  const ScanPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final words = ref.watch(addWordsProvider);

    Future<void> submit() async {
      await ref.read(submitAddWordsProvider)();
      if (context.mounted) Navigator.of(context).pop();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.reviewWordsTitle(words.length),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: words.isEmpty
                ? Center(
              child: Text(
                l10n.emptyDictionaryTitle,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: words.length,
              itemBuilder: (context, index) {
                return WordItem(
                  word: words[index],
                  onDelete: () =>
                      ref.read(addWordsProvider.notifier).removeWord(index),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: words.isEmpty ? null : submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  l10n.addWordsButton(words.length),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}