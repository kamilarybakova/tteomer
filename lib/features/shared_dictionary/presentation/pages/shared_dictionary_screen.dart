import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/tts/tts_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/shared_dictionary_word.dart';
import '../state/shared_dictionary_provider.dart';
import '../state/shared_dictionary_state.dart';

class SharedDictionaryScreen extends ConsumerStatefulWidget {
  const SharedDictionaryScreen({super.key});

  @override
  ConsumerState<SharedDictionaryScreen> createState() =>
      _SharedDictionaryScreenState();
}

class _SharedDictionaryScreenState
    extends ConsumerState<SharedDictionaryScreen> {
  String? _localeCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localeCode = Localizations.localeOf(context).languageCode;
    if (_localeCode == localeCode) return;
    _localeCode = localeCode;
    Future.microtask(() => ref.read(sharedDictionaryProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(sharedDictionaryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.sharedDictionaryTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: switch (state) {
        SharedDictionaryLoading() => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        SharedDictionaryError(:final message) => _ErrorState(
          message: message,
          onRetry: () => ref.read(sharedDictionaryProvider.notifier).load(),
        ),
        SharedDictionaryData() => _DictionaryContent(state: state),
      },
    );
  }
}

class _DictionaryContent extends ConsumerStatefulWidget {
  final SharedDictionaryData state;

  const _DictionaryContent({required this.state});

  @override
  ConsumerState<_DictionaryContent> createState() => _DictionaryContentState();
}

class _DictionaryContentState extends ConsumerState<_DictionaryContent> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _openPage(int page) async {
    await ref.read(sharedDictionaryProvider.notifier).load(page: page);
    if (!mounted || !_scrollController.hasClients) return;
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = widget.state;

    return Stack(
      children: [
        RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () => ref.read(sharedDictionaryProvider.notifier).load(),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _UnitFilters(selectedUnit: state.selectedTopic),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _searchController,
                        onChanged: ref
                            .read(sharedDictionaryProvider.notifier)
                            .search,
                        decoration: InputDecoration(
                          hintText: l10n.searchHint,
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    ref
                                        .read(sharedDictionaryProvider.notifier)
                                        .search('');
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              if (state.words.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(
                    title: l10n.sharedDictionaryEmpty,
                    subtitle: l10n.sharedDictionaryEmptySubtitle,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  sliver: SliverList.separated(
                    itemCount: state.words.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _SharedWordCard(word: state.words[index]);
                    },
                  ),
                ),
              if (state.currentPage > 1 || state.hasMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                    child: _Pagination(
                      currentPage: state.currentPage,
                      hasMore: state.hasMore,
                      isLoading: state.isUpdating,
                      onPageSelected: _openPage,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (state.isUpdating)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(color: AppColors.accent),
          ),
      ],
    );
  }
}

class _UnitFilters extends ConsumerWidget {
  final String? selectedUnit;

  const _UnitFilters({required this.selectedUnit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final units = <String?>[
      null,
      ...List.generate(8, (index) => 'Ünite ${index + 1}'),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: units.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final unit = units[index];
          final selected = unit == selectedUnit;
          return ChoiceChip(
            label: Text(unit ?? l10n.categoryAll),
            selected: selected,
            onSelected: (_) =>
                ref.read(sharedDictionaryProvider.notifier).selectTopic(unit),
            selectedColor: AppColors.accent,
            labelStyle: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w700,
            ),
            side: BorderSide.none,
            backgroundColor: Colors.white,
          );
        },
      ),
    );
  }
}

class _Pagination extends StatelessWidget {
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final ValueChanged<int> onPageSelected;

  const _Pagination({
    required this.currentPage,
    required this.hasMore,
    required this.isLoading,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filledTonal(
          onPressed: currentPage > 1 && !isLoading
              ? () => onPageSelected(currentPage - 1)
              : null,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        const SizedBox(width: 14),
        Container(
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$currentPage',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 14),
        IconButton.filledTonal(
          onPressed: hasMore && !isLoading
              ? () => onPageSelected(currentPage + 1)
              : null,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}

class _SharedWordCard extends StatefulWidget {
  final SharedDictionaryWord word;

  const _SharedWordCard({required this.word});

  @override
  State<_SharedWordCard> createState() => _SharedWordCardState();
}

class _SharedWordCardState extends State<_SharedWordCard> {
  static final TtsService _tts = TtsService();
  bool _speaking = false;

  Future<void> _speak() async {
    setState(() => _speaking = true);
    await _tts.stop();
    await _tts.speak(
      text: widget.word.turkish,
      languageCode: 'tr-TR',
      speed: 0.45,
      pitch: 1,
    );
    if (mounted) setState(() => _speaking = false);
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.word;
    final metadata = [
      word.level,
      word.partOfSpeech,
      word.topic,
    ].where((value) => value.isNotEmpty).join(' • ');

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _speak,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _speak,
                  icon: Icon(
                    _speaking
                        ? Icons.graphic_eq_rounded
                        : Icons.volume_up_rounded,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.turkish,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      word.translation,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                    if (metadata.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        metadata,
                        style: const TextStyle(
                          color: Color(0xFF6C63FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (word.example.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        word.example,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_stories_rounded,
              size: 56,
              color: AppColors.accent,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 52,
              color: Color(0xFF6B7280),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.sharedDictionaryError,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: Text(l10n.checkAgain)),
          ],
        ),
      ),
    );
  }
}
