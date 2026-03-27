import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
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

  Color _getColor(String text) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.green,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];

    return colors[text.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(label);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color : color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : color.withOpacity(0.3),
          ),
        ),
        transform: Matrix4.identity()
          ..scale(selected ? 1.05 : 1.0),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}