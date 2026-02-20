import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/core/theme/app_colors.dart';

import '../../../auth/presentation/provider/providers.dart';
import '../provider/materials_state.dart';

class CategoriesSection extends ConsumerWidget {
  final int? selectedCategory;
  final ValueChanged<int?> onSelect;

  const CategoriesSection({
    super.key,
    required this.selectedCategory,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(materialsNotifierProvider);

    if (state is! MaterialsLoaded) return const SizedBox(height: 60);

    final categories = state.categories;

    return SizedBox(
      height: 60,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          if (i == 0) {
            return _Chip(
              label: 'Все',
              selected: selectedCategory == null,
              onTap: () => onSelect(null),
            );
          }

          final cat = categories[i - 1];
          return _Chip(
            label: cat.name,
            selected: selectedCategory == cat.id,
            onTap: () => onSelect(cat.id),
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.white,
      selectedColor: AppColors.accent,
      checkmarkColor: selected ? Colors.white : AppColors.textSecondary,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.textSecondary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}