import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/features/dictionary/domain/usecases/delete_all_words.dart';
import 'package:tteomer/features/dictionary/domain/usecases/delete_word.dart';
import '../../domain/usecases/get_dictionary.dart';
import 'dictionary_state.dart';

class WordsVM extends StateNotifier<DictionaryState> {
  final GetWords getWords;
  final DeleteAllWords deleteAllWords;
  final DeleteWord deleteWordUseCase;

  WordsVM(this.getWords, this.deleteAllWords, this.deleteWordUseCase)
      : super(DictionaryInitialLoading());

  Future<void> loadWords() async {
    try {
      final words = await getWords();
      final topics = words.map((e) => e.topic).toSet().toList();
      state = DictionaryData(
        words: words,
        topics: topics,
        isUpdating: false,
      );
    } catch (e) {
      state = DictionaryError(e.toString());
    }
  }

  Future<void> deleteWord(int id) async {
    final current = state;

    if (current is DictionaryData) {
      final updatedWords = current.words.where((w) => w.wordId != id).toList();
      final updatedTopics = updatedWords.map((e) => e.topic).toSet().toList();
      state = current.copyWith(
        words: updatedWords,
        topics: updatedTopics,
        isUpdating: true,
      );
    }

    try {
      await deleteWordUseCase(id);

      final words = await getWords();
      final topics = words.map((e) => e.topic).toSet().toList();

      if (current is DictionaryData) {
        state = (state as DictionaryData).copyWith(
          words: words,
          topics: topics,
          isUpdating: false,
        );
      }
    } catch (e) {
      state = current;
      state = DictionaryError(e.toString());
    }
  }

  Future<void> clearDictionary() async {
    final current = state;

    if (current is DictionaryData) {
      state = current.copyWith(isUpdating: true);
    }

    try {
      await deleteAllWords();
      state = DictionaryData(
        words: const [],
        topics: const [],
        isUpdating: false,
      );
    } catch (e) {
      state = current;
      state = DictionaryError(e.toString());
    }
  }

  Future<void> loadByTopic(String topic) async {
    final current = state;

    if (current is DictionaryData) {
      state = current.copyWith(isUpdating: true);

      try {
        final words = await getWords(topic: topic);
        state = current.copyWith(
          words: words,
          isUpdating: false,
        );
      } catch (e) {
        state = DictionaryError(e.toString());
      }
    }
  }

  Future<void> searchWords(String query) async {
    final current = state;

    if (current is DictionaryData) {
      state = current.copyWith(isUpdating: true);

      try {
        final words = await getWords(search: query);
        state = current.copyWith(
          words: words,
          isUpdating: false,
        );
      } catch (e) {
        state = DictionaryError(e.toString());
      }
    }
  }
}