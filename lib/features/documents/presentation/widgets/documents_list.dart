import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/provider/providers.dart';
import '../pages/document_webview_page.dart';
import '../provider/materials_state.dart';

class DocumentsList extends ConsumerWidget {
  final int? selectedCategory;

  const DocumentsList({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(materialsNotifierProvider);

    return switch (state) {
      MaterialsLoading() =>
      const Center(child: CircularProgressIndicator()),

      MaterialsError(message: final message) =>
          _Error(message),

      MaterialsLoaded(materials: final materials) =>
          _buildList(materials, ref),

      _ => const SizedBox(),
    };
  }

  Widget _buildList(List materials, WidgetRef ref) {
    final filtered = selectedCategory == null
        ? materials
        : materials.where((m) => m.category?.id == selectedCategory);

    final pinned = filtered.where((e) => e.isPinned).toList();
    final normal = filtered.where((e) => !e.isPinned).toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(materialsNotifierProvider.notifier).load();
      },
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          if (pinned.isNotEmpty) ...[
            const _SectionTitle('📌 Pinned'),
            const SizedBox(height: 8),
            ...pinned.map((m) => _MaterialCard(m)),
            const SizedBox(height: 16),
          ],
          ...normal.map((m) => _MaterialCard(m)),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final dynamic material;

  const _MaterialCard(this.material);

  Color _getColor(String text) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.green,
      Colors.teal,
    ];
    return colors[text.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(material.title);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DocumentWebViewPage(
              url: material.file,
              title: material.title,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getFileIcon(material.file),
                color: color,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${material.category?.name ?? "Все"} • ${material.fileSizeMb}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon(String file) {
    final ext = file.split('.').last.toLowerCase();

    if (ext == 'pdf') return Icons.picture_as_pdf;
    if (ext == 'doc' || ext == 'docx') return Icons.description;

    return Icons.insert_drive_file;
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _Error extends StatelessWidget {
  final String message;

  const _Error(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}