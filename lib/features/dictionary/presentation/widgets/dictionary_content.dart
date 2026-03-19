import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/core/theme/app_colors.dart';
import 'package:tteomer/features/dictionary/presentation/widgets/word_tile.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/word.dart';
import '../state/dictionary_provider.dart';

class DictionaryContent extends ConsumerWidget {
  const DictionaryContent({
    super.key,
    required this.words,
    required this.topics,
  });

  final List<Word> words;
  final List<String> topics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ['All', ...topics];

    return Column(
      children: [
        const SizedBox(height: 20),
        _SearchField(ref: ref),
        const SizedBox(height: 28),
        _CategoriesChips(
          ref: ref,
          categories: categories,
        ),
        const SizedBox(height: 12),
        Expanded(child: _WordsList(words: words)),
        const SizedBox(height: 100),
      ],
    );
  }
}

class _WordsList extends StatelessWidget {
  const _WordsList({required this.words});
  final List<Word> words;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: words.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => WordTile(word: words[i]),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (value) {
          ref.read(wordsVmProvider.notifier).searchWords(value);
        },
        decoration: InputDecoration(
          hintText: l10n.searchHint,
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: AppColors.backgroundPrimary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: AppColors.accent, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _CategoriesChips extends ConsumerStatefulWidget {
  const _CategoriesChips({
    required this.ref,
    required this.categories,
  });

  final WidgetRef ref;
  final List<String> categories;

  @override
  ConsumerState<_CategoriesChips> createState() => _CategoriesChipsState();
}

class _CategoriesChipsState extends ConsumerState<_CategoriesChips> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final categories = widget.categories;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final isSelected = index == selectedIndex;
          final category = categories[index];

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) {
              setState(() => selectedIndex = index);

              final notifier = widget.ref.read(wordsVmProvider.notifier);

              if (category == 'All') {
                notifier.loadWords();
              } else {
                notifier.loadByTopic(category);
              }
            },
            backgroundColor: Colors.white,
            selectedColor: AppColors.accent,
            labelStyle: TextStyle(
              color: isSelected
                  ? Colors.white
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }
}
