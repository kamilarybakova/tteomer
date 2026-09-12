import '../entities/shared_dictionary_word.dart';
import '../repositories/shared_dictionary_repository.dart';

class GetSharedDictionaryWords {
  final SharedDictionaryRepository repository;

  const GetSharedDictionaryWords(this.repository);

  Future<({List<SharedDictionaryWord> words, bool hasMore})> call({
    String? level,
    String? topic,
    String? search,
    int page = 1,
    int pageSize = 20,
  }) {
    return repository.getWords(
      level: level,
      topic: topic,
      search: search,
      page: page,
      pageSize: pageSize,
    );
  }
}
