import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/features/dictionary/domain/usecases/delete_all_words.dart';
import 'package:tteomer/features/dictionary/domain/usecases/delete_word.dart';
import '../../domain/entities/word.dart';
import '../../domain/usecases/get_dictionary.dart';
import 'dictionary_state.dart';

class WordsVM extends StateNotifier<DictionaryState> {
  final GetWords getWords;
  final DeleteAllWords deleteAllWords;
  final DeleteWord deleteWordUseCase;

  static const _pageSize = 10;
  String? _activeTopic;
  String? _activeSearch;

  WordsVM(this.getWords, this.deleteAllWords, this.deleteWordUseCase)
    : super(DictionaryInitialLoading());

  Future<void> loadWords({bool reset = true}) async {
    final current = state;
    final page = reset
        ? 1
        : (current is DictionaryData ? current.currentPage + 1 : 1);

    if (reset) {
      _activeTopic = null;
      _activeSearch = null;
    }

    if (!reset && current is DictionaryData && !current.hasMore) return;
    if (!reset && current is DictionaryData) {
      state = current.copyWith(isUpdating: true);
    }

    try {
      final result = await getWords(
        topic: _activeTopic,
        search: _activeSearch,
        page: page,
        pageSize: _pageSize,
      );
      final existingWords = (!reset && current is DictionaryData)
          ? current.words
          : <Word>[];
      final allWords = [...existingWords, ...result.words];
      final topics = allWords.map((e) => e.topic).toSet().toList();

      state = DictionaryData(
        words: allWords,
        topics: topics,
        isUpdating: false,
        hasMore: result.hasMore,
        currentPage: page,
      );
    } catch (e) {
      state = DictionaryError(e.toString());
    }
  }

  Future<void> loadByTopic(String topic) async {
    final current = state;
    if (current is! DictionaryData) return;
    _activeTopic = topic;
    _activeSearch = null;
    state = current.copyWith(isUpdating: true);

    try {
      final result = await getWords(topic: topic, page: 1, pageSize: _pageSize);
      state = current.copyWith(
        words: result.words,
        isUpdating: false,
        hasMore: result.hasMore,
        currentPage: 1,
      );
    } catch (e) {
      state = DictionaryError(e.toString());
    }
  }

  Future<void> loadMoreByTopic(String topic) async {
    final current = state;
    if (current is! DictionaryData || !current.hasMore) return;
    state = current.copyWith(isUpdating: true);

    try {
      final result = await getWords(
        topic: topic,
        page: current.currentPage + 1,
        pageSize: _pageSize,
      );
      state = current.copyWith(
        words: [...current.words, ...result.words],
        isUpdating: false,
        hasMore: result.hasMore,
        currentPage: current.currentPage + 1,
      );
    } catch (e) {
      state = DictionaryError(e.toString());
    }
  }

  Future<void> searchWords(String query) async {
    final current = state;
    if (current is! DictionaryData) return;
    _activeTopic = null;
    _activeSearch = query.isEmpty ? null : query;
    state = current.copyWith(isUpdating: true);

    try {
      final result = await getWords(
        search: _activeSearch,
        page: 1,
        pageSize: _pageSize,
      );
      state = current.copyWith(
        words: result.words,
        isUpdating: false,
        hasMore: result.hasMore,
        currentPage: 1,
      );
    } catch (e) {
      state = DictionaryError(e.toString());
    }
  }

  Future<void> refreshWords() async {
    final current = state;

    try {
      final result = await getWords(
        topic: _activeTopic,
        search: _activeSearch,
        page: 1,
        pageSize: _pageSize,
      );
      final topics = result.words.map((word) => word.topic).toSet().toList();

      state = DictionaryData(
        words: result.words,
        topics:
            current is DictionaryData &&
                (_activeTopic != null || _activeSearch != null)
            ? current.topics
            : topics,
        isUpdating: false,
        hasMore: result.hasMore,
        currentPage: 1,
      );
    } catch (e) {
      state = DictionaryError(e.toString());
    }
  }

  Future<void> deleteWord(int id) async {
    final current = state;
    if (current is! DictionaryData) return;

    final updatedWords = current.words.where((w) => w.wordId != id).toList();
    final updatedTopics = updatedWords.map((e) => e.topic).toSet().toList();
    state = current.copyWith(
      words: updatedWords,
      topics: updatedTopics,
      isUpdating: true,
    );

    try {
      await deleteWordUseCase(id);
      state = (state as DictionaryData).copyWith(isUpdating: false);
    } catch (e) {
      state = current;
      state = DictionaryError(e.toString());
    }
  }

  Future<void> clearDictionary() async {
    final current = state;
    if (current is DictionaryData) state = current.copyWith(isUpdating: true);

    try {
      await deleteAllWords();
      state = DictionaryData(words: [], topics: [], isUpdating: false);
    } catch (e) {
      state = current;
      state = DictionaryError(e.toString());
    }
  }
}
