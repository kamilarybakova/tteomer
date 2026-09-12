import '../entities/shared_dictionary_word.dart';

abstract class SharedDictionaryRepository {
  Future<({List<SharedDictionaryWord> words, bool hasMore})> getWords({
    String? level,
    String? topic,
    String? search,
    int page,
    int pageSize,
  });
}
