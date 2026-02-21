import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_dictionary.dart';
import 'dictionary_state.dart';

class WordsVM extends StateNotifier<DictionaryState> {
  final GetWords getWords;

  WordsVM(this.getWords)
      : super(DictionaryInitialLoading());

  /// initial load
  Future<void> loadWords() async {
    try {
      final words = await getWords();
      state = DictionaryData(words: words);
    } catch (e) {
      state = DictionaryError(e.toString());
    }
  }

  /// filter by topic (NO full loading)
  Future<void> loadByTopic(String topic) async {
    final current = state;

    if (current is DictionaryData) {
      state = DictionaryData(
        words: current.words,
        isUpdating: true,
      );
    }

    try {
      final words = await getWords(topic: topic);
      state = DictionaryData(words: words);
    } catch (e) {
      state = DictionaryError(e.toString());
    }
  }

  /// search (NO full loading)
  Future<void> searchWords(String query) async {
    final current = state;

    if (current is DictionaryData) {
      state = DictionaryData(
        words: current.words,
        isUpdating: true,
      );
    }

    try {
      final words = await getWords(search: query);
      state = DictionaryData(words: words);
    } catch (e) {
      state = DictionaryError(e.toString());
    }
  }
}
