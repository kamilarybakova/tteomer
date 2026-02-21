import '../../domain/entities/word.dart';

sealed class DictionaryState {}

class DictionaryInitialLoading extends DictionaryState {}

class DictionaryData extends DictionaryState {
  final List<Word> words;
  final bool isUpdating;

  DictionaryData({
    required this.words,
    this.isUpdating = false,
  });
}

class DictionaryError extends DictionaryState {
  final String message;
  DictionaryError(this.message);
}
