import '../entities/word.dart';
import '../repositories/dictionary_repository.dart';

class GetWords {
  final DictionaryRepository repository;
  GetWords(this.repository);

  Future<({List<Word> words, bool hasMore})> call({
    String? status,
    String? topic,
    String? search,
    int page = 1,
    int pageSize = 5,
  }) {
    return repository.getWords(
      status: status,
      topic: topic,
      search: search,
      page: page,
      pageSize: pageSize,
    );
  }
}
