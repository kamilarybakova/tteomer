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

class _SearchField extends ConsumerStatefulWidget {
  const _SearchField({required this.ref});

  final WidgetRef ref;

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
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
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
            /// ИКОНКА
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
                color: isFocused
                    ? AppColors.accent
                    : Colors.grey,
              ),
            ),

            const SizedBox(width: 10),

            /// INPUT
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: (value) {
                  widget.ref
                      .read(wordsVmProvider.notifier)
                      .searchWords(value);
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),

            /// CLEAR BUTTON
            if (controller.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  controller.clear();
                  widget.ref
                      .read(wordsVmProvider.notifier)
                      .searchWords('');
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

  Color _getColor(String category) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.green,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
    ];

    final hash = category.hashCode;
    return colors[hash.abs() % colors.length];
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

              final notifier =
              widget.ref.read(wordsVmProvider.notifier);

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
                color: isSelected
                    ? color
                    : color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? color
                      : color.withOpacity(0.3),
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