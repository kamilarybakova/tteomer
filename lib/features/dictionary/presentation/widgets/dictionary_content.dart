import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/core/theme/app_colors.dart';
import 'package:tteomer/features/dictionary/presentation/widgets/word_tile.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/word.dart';
import '../state/dictionary_provider.dart';
import '../state/dictionary_state.dart';

class DictionaryScreen extends ConsumerWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wordsVmProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: switch (state) {
        DictionaryInitialLoading() => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        DictionaryError(:final message) => Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.red),
          ),
        ),
        DictionaryData(:final words, :final topics, :final isUpdating) => Stack(
          children: [
            DictionaryContent(words: words, topics: topics),
            if (isUpdating)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  color: AppColors.accent,
                  backgroundColor: Colors.transparent,
                ),
              ),
          ],
        ),
      },
    );
  }
}

class DictionaryContent extends ConsumerWidget {
  const DictionaryContent({
    super.key,
    required this.words,
    required this.topics,
  });

  final List<Word> words;
  final List<String?> topics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final categories = [l10n.categoryAll, ...topics.whereType<String>()];

    return Column(
      children: [
        const SizedBox(height: 20),
        const _SearchField(),
        const SizedBox(height: 28),
        _CategoriesChips(categories: categories),
        const SizedBox(height: 12),
        Expanded(
          child: words.isEmpty
              ? const _EmptyState()
              : _WordsList(words: words),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}

class _WordsList extends ConsumerWidget {
  const _WordsList({required this.words});
  final List<Word> words;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: words.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final word = words[i];
        return WordTile(
          word: word,
          onDelete: () =>
              ref.read(wordsVmProvider.notifier).deleteWord(word.wordId),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: AppColors.accent,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.dictionaryEmpty,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.dictionaryEmptySubtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends ConsumerStatefulWidget {
  const _SearchField();

  @override
  ConsumerState<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<_SearchField> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() => isFocused = focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isFocused
                ? AppColors.accent
                : Colors.grey.withOpacity(0.2),
            width: isFocused ? 1.5 : 1,
          ),
          boxShadow: [
            if (isFocused)
              BoxShadow(
                color: AppColors.accent.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isFocused
                    ? AppColors.accent.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search,
                color: isFocused ? AppColors.accent : Colors.grey,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: (value) {
                  ref.read(wordsVmProvider.notifier).searchWords(value);
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
              ),
            ),
            if (controller.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  controller.clear();
                  ref.read(wordsVmProvider.notifier).searchWords('');
                  setState(() {});
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesChips extends ConsumerStatefulWidget {
  const _CategoriesChips({required this.categories});

  final List<String> categories;

  @override
  ConsumerState<_CategoriesChips> createState() => _CategoriesChipsState();
}

class _CategoriesChipsState extends ConsumerState<_CategoriesChips> {
  int selectedIndex = 0;

  Color _getColor(String category) {
    const colors = [
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.green,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
    ];
    return colors[category.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.categories;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final category = categories[index];
          final isSelected = index == selectedIndex;
          final color = _getColor(category);

          return GestureDetector(
            onTap: () {
              setState(() => selectedIndex = index);
              final notifier = ref.read(wordsVmProvider.notifier);
              if (category == 'All') {
                notifier.loadWords();
              } else {
                notifier.loadByTopic(category);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? color : color.withOpacity(0.3),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}