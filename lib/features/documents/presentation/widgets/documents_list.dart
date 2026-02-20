import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../auth/presentation/provider/providers.dart';
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
        : materials.where((m) => m.category.id == selectedCategory).toList();

    final pinned = filtered.where((e) => e.isPinned).toList();
    final normal = filtered.where((e) => !e.isPinned).toList();

    return RefreshIndicator(
      onRefresh: () async {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(materialsNotifierProvider.notifier).load();
        });
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (pinned.isNotEmpty) ...[
            const _SectionTitle('📌 Pinned'),
            ...pinned.map((m) => _MaterialCard(m)),
            const SizedBox(height: 12),
          ],
          ...normal.map((m) => _MaterialCard(m)),
        ],
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final dynamic material;

  const _MaterialCard(this.material);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(.1),
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: _FileIcon(material.file),
        title: Text(
          material.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${material.category.name} • ${material.fileSizeMb}',
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () async {
          final uri = Uri.parse(material.file);

          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
  }
}

class _FileIcon extends StatelessWidget {
  final String file;

  const _FileIcon(this.file);

  @override
  Widget build(BuildContext context) {
    final ext = file.split('.').last.toLowerCase();

    IconData icon = Icons.insert_drive_file;

    if (ext == 'pdf') icon = Icons.picture_as_pdf;
    if (ext == 'doc' || ext == 'docx') icon = Icons.description;

    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.blue.withOpacity(.1),
      child: Icon(icon, color: Colors.blue),
    );
  }
}

class _Error extends StatelessWidget {
  final String message;
  const _Error(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.red)),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }
}
