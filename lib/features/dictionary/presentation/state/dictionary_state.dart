import '../../domain/entities/word.dart';

sealed class DictionaryState {}

class DictionaryInitialLoading extends DictionaryState {}

class DictionaryData extends DictionaryState {
  final List<Word> words;
  final List<String?> topics;
  final bool isUpdating;
  final bool hasMore;
  final int currentPage;

  DictionaryData({
    required this.words,
    required this.topics,
    required this.isUpdating,
    this.hasMore = false,
    this.currentPage = 1,
  });

  DictionaryData copyWith({
    List<Word>? words,
    List<String?>? topics,
    bool? isUpdating,
    bool? hasMore,
    int? currentPage,
  }) {
    return DictionaryData(
      words: words ?? this.words,
      topics: topics ?? this.topics,
      isUpdating: isUpdating ?? this.isUpdating,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class DictionaryError extends DictionaryState {
  final String message;
  DictionaryError(this.message);
}
