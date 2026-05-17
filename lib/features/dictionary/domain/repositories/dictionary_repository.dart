import '../entities/word.dart';

abstract class DictionaryRepository {
  Future<({List<Word> words, bool hasMore})> getWords({
    String? status,
    String? topic,
    String? search,
    int page = 1,
    int pageSize = 5,
  });
  Future<void> deleteWord(int id);
  Future<void> clearDictionary();
}
