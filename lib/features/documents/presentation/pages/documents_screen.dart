import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/provider/providers.dart';
import '../widgets/categories_section.dart';
import '../widgets/documents_list.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  int? selectedCategory;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(materialsNotifierProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        title: Text(l10n.tabDocs),
        centerTitle: true,
        backgroundColor: const Color(0xFFF3F3F3),
      ),
      body: Column(
        children: [
          CategoriesSection(
            selectedCategory: selectedCategory,
            onSelect: (id) => setState(() => selectedCategory = id),
          ),
          Expanded(
            child: DocumentsList(selectedCategory: selectedCategory),
          ),
        ],
      ),
    );
  }
}
