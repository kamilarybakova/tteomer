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

  WordsVM(this.getWords, this.deleteAllWords, this.deleteWordUseCase)
      : super(DictionaryInitialLoading());

  Future<void> loadWords({bool reset = true}) async {
    final current = state;
    final page = reset ? 1 : (current is DictionaryData ? current.currentPage + 1 : 1);

    if (!reset && current is DictionaryData && !current.hasMore) return;
    if (!reset && current is DictionaryData) {
      state = current.copyWith(isUpdating: true);
    }

    try {
      final result = await getWords(page: page, pageSize: _pageSize);
      final existingWords = (!reset && current is DictionaryData) ? current.words : <Word>[];
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
    state = current.copyWith(isUpdating: true);

    try {
      final result = await getWords(search: query, page: 1, pageSize: _pageSize);
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

  Future<void> deleteWord(int id) async {
    final current = state;
    if (current is! DictionaryData) return;

    final updatedWords = current.words.where((w) => w.wordId != id).toList();
    final updatedTopics = updatedWords.map((e) => e.topic).toSet().toList();
    state = current.copyWith(words: updatedWords, topics: updatedTopics, isUpdating: true);

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