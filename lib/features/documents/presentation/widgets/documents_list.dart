import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/core/widgets/icon_data.dart';

import '../../../auth/presentation/provider/providers.dart';
import '../pages/document_webview_page.dart';
import '../provider/materials_state.dart';

class DocumentsList extends ConsumerStatefulWidget {
  final int? selectedCategory;
  final String? selectedLevel;
  const DocumentsList({
    super.key,
    required this.selectedCategory,
    this.selectedLevel,
  });

  @override
  ConsumerState<DocumentsList> createState() => _DocumentsListState();
}

class _DocumentsListState extends ConsumerState<DocumentsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (widget.selectedLevel != null) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      ref.read(materialsNotifierProvider.notifier).load(
        level: widget.selectedLevel,
        categoryId: widget.selectedCategory,
        reset: false,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(materialsNotifierProvider);

    return switch (state) {
      MaterialsLoading() => const Center(child: CircularProgressIndicator()),
      MaterialsError(:final message) => _Error(message),
      MaterialsLoaded(:final materials, :final hasMore, :final isLoading) =>
          Stack(
            children: [
              _buildList(materials, hasMore, ref),
              if (isLoading)
                const Positioned(
                  top: 0, left: 0, right: 0,
                  child: LinearProgressIndicator(),
                ),
            ],
          ),
      _ => const SizedBox(),
    };
  }

  Widget _buildList(List materials, bool hasMore, WidgetRef ref) {
    final filteredByLevel = widget.selectedLevel == null
        ? materials
        : materials
            .where((m) => (m.level as String).toUpperCase() == widget.selectedLevel)
            .toList();
    final filtered = widget.selectedCategory == null
        ? filteredByLevel
        : filteredByLevel.where((m) => m.category?.id == widget.selectedCategory).toList();

    final pinned = filtered.where((e) => e.isPinned).toList();
    final normal = filtered.where((e) => !e.isPinned).toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(materialsNotifierProvider.notifier).load(
          reset: true,
        );
      },
      child: ListView(
        controller: _scrollController,
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
          if (hasMore && widget.selectedLevel == null)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
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
                getIcon(material.file),
                color: color,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    material.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
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
