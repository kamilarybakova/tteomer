import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/provider/providers.dart';
import '../widgets/documents_list.dart';

class CategoryDocumentsPage extends ConsumerStatefulWidget {
  final String? categoryId;
  final String categoryName;
  final String? level;

  const CategoryDocumentsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.level,
  });

  @override
  ConsumerState<CategoryDocumentsPage> createState() =>
      _CategoryDocumentsPageState();
}

class _CategoryDocumentsPageState extends ConsumerState<CategoryDocumentsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(materialsNotifierProvider.notifier).load(
        level: widget.level,
        categoryId: widget.categoryId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        centerTitle: true,
        title: Text(
          widget.categoryName,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: DocumentsList(
        selectedCategory: widget.categoryId,
        selectedLevel: widget.level,
      ),
    );
  }
}
