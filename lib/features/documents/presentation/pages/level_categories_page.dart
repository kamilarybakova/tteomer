import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/provider/providers.dart';
import '../provider/materials_state.dart';
import 'category_documents_page.dart';

class LevelCategoriesPage extends ConsumerWidget {
  final String level;

  const LevelCategoriesPage({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(materialsNotifierProvider);

    if (state is! MaterialsLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final categories = state.categories;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        centerTitle: true,
        title: Text(level, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.2,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryItem(
            label: category.name as String,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryDocumentsPage(
                  categoryId: category.id,
                  categoryName: category.name,
                  level: level,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _CategoryItem({required this.label, required this.onTap});

  Color _getColor(String text) {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFF43A047),
      const Color(0xFFE53935),
      const Color(0xFF1E88E5),
      const Color(0xFFFF7043),
      const Color(0xFF8E24AA),
      const Color(0xFF00ACC1),
      const Color(0xFFFFB300),
    ];
    return colors[text.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(label);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -12,
              top: -12,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.folder_rounded, color: color, size: 24),
                  ),
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
