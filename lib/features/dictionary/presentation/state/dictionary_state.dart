import '../../domain/entities/word.dart';

sealed class DictionaryState {}

class DictionaryInitialLoading extends DictionaryState {}

class DictionaryData extends DictionaryState {
  final List<Word> words;
  final List<String> topics;
  final bool isUpdating;

  DictionaryData({
    required this.words,
    required this.topics,
    this.isUpdating = false,
  });

  DictionaryData copyWith({
    List<Word>? words,
    List<String>? topics,
    bool? isUpdating,
  }) {
    return DictionaryData(
      words: words ?? this.words,
      topics: topics ?? this.topics,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

class DictionaryError extends DictionaryState {
  final String message;
  DictionaryError(this.message);
}
