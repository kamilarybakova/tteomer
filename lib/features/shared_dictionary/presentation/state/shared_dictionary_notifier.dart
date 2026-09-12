import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_shared_dictionary_words.dart';
import 'shared_dictionary_state.dart';

class SharedDictionaryNotifier extends StateNotifier<SharedDictionaryState> {
  final GetSharedDictionaryWords getWords;
  static const _pageSize = 20;
  Timer? _searchDebounce;

  SharedDictionaryNotifier(this.getWords)
    : super(const SharedDictionaryLoading());

  Future<void> load({int page = 1}) async {
    final current = state;
    final data = current is SharedDictionaryData ? current : null;
    if (data?.isUpdating == true) return;
    if (data != null) state = data.copyWith(isUpdating: true);

    try {
      final result = await getWords(
        level: 'A1',
        topic: data?.selectedTopic,
        search: data?.search,
        page: page,
        pageSize: _pageSize,
      );
      final topics = <String>{
        ...?data?.topics,
        ...result.words
            .map((word) => word.topic)
            .where((topic) => topic.isNotEmpty),
      }.toList()..sort();

      state = SharedDictionaryData(
        words: result.words,
        topics: topics,
        selectedTopic: data?.selectedTopic,
        search: data?.search ?? '',
        currentPage: page,
        hasMore: result.hasMore,
      );
    } catch (error) {
      state = SharedDictionaryError(error.toString());
    }
  }

  Future<void> selectTopic(String? topic) async {
    final current = state;
    if (current is! SharedDictionaryData) return;
    state = current.copyWith(selectedTopic: topic, clearTopic: topic == null);
    await load(page: 1);
  }

  void search(String query) {
    final current = state;
    if (current is! SharedDictionaryData) return;
    _searchDebounce?.cancel();
    state = current.copyWith(search: query.trim());
    _searchDebounce = Timer(
      const Duration(milliseconds: 350),
      () => load(page: 1),
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
