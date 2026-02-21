import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../state/add_words_viewmodel.dart';

class ScanPreviewScreen extends ConsumerWidget {
  const ScanPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final words = ref.watch(addWordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.reviewWordsTitle(words.length),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(words[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ref
                          .read(addWordsProvider.notifier)
                          .removeWord(index);
                    },
                  ),
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
                onPressed: words.isEmpty
                    ? null
                    : () {
                  // TODO: send to backend
                },
                child: Text(
                  l10n.addWordsButton(words.length),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
