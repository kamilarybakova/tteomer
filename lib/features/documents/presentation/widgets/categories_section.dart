import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/icon_data.dart';
import '../../../auth/presentation/provider/providers.dart';
import '../pages/category_documents_page.dart';
import '../pages/level_categories_page.dart';
import '../provider/materials_state.dart';

class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  static const _levelOrder = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(materialsNotifierProvider);
    final roleAsync = ref.watch(userRoleProvider);

    if (state is! MaterialsLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final levels = state.materials
        .map((m) => m.level?.toString().trim().toUpperCase() ?? '')
        .where((level) => _levelOrder.contains(level))
        .toSet();
    final orderedLevels = _levelOrder.where(levels.contains).toList();

    final role = roleAsync.valueOrNull?.trim().toUpperCase();
    final showTeacherFolders = role == 'TEACHER';
    if (showTeacherFolders) {
      final visibleLevels = role == 'TEACHER' ? _levelOrder : orderedLevels;

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.2,
        ),
        itemCount: visibleLevels.length,
        itemBuilder: (context, i) {
          final level = visibleLevels[i];
          return _CategoryCard(
            label: level,
            icon: Icons.folder_copy_rounded,
            onTap: () async {
              await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LevelCategoriesPage(level: level),
              ),
              );
            },
          );
        },
      );
    }

    final categories = state.categories;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, i) {
        final cat = categories[i];

        return _CategoryCard(
          label: cat.name,
          icon: getIcon(cat.name),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryDocumentsPage(
                  categoryId: cat.id,
                  categoryName: cat.name,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

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
              color: color.withOpacity(0.12),
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
                  color: color.withOpacity(0.08),
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
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 24),
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
