import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_dictionary.dart';
import 'dictionary_state.dart';

class WordsVM extends StateNotifier<DictionaryState> {
  final GetWords getWords;

  WordsVM(this.getWords) : super(DictionaryInitialLoading());

  /// INITIAL LOAD
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

  /// FILTER BY TOPIC
  Future<void> loadByTopic(String topic) async {
    final current = state;

    if (current is DictionaryData) {
      // показать линейный прогресс
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

  /// SEARCH
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
