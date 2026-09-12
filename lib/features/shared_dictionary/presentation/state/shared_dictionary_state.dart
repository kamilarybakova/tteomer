import '../../domain/entities/shared_dictionary_word.dart';

sealed class SharedDictionaryState {
  const SharedDictionaryState();
}

class SharedDictionaryLoading extends SharedDictionaryState {
  const SharedDictionaryLoading();
}

class SharedDictionaryError extends SharedDictionaryState {
  final String message;

  const SharedDictionaryError(this.message);
}

class SharedDictionaryData extends SharedDictionaryState {
  final List<SharedDictionaryWord> words;
  final List<String> topics;
  final String? selectedTopic;
  final String search;
  final int currentPage;
  final bool hasMore;
  final bool isUpdating;

  const SharedDictionaryData({
    required this.words,
    required this.topics,
    this.selectedTopic,
    this.search = '',
    this.currentPage = 1,
    this.hasMore = false,
    this.isUpdating = false,
  });

  SharedDictionaryData copyWith({
    List<SharedDictionaryWord>? words,
    List<String>? topics,
    String? selectedTopic,
    bool clearTopic = false,
    String? search,
    int? currentPage,
    bool? hasMore,
    bool? isUpdating,
  }) {
    return SharedDictionaryData(
      words: words ?? this.words,
      topics: topics ?? this.topics,
      selectedTopic: clearTopic ? null : selectedTopic ?? this.selectedTopic,
      search: search ?? this.search,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}
