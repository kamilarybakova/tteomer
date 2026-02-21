import '../entities/word.dart';
import '../repositories/dictionary_repository.dart';

class GetWords {
  final DictionaryRepository repository;

  GetWords(this.repository);

  Future<List<Word>> call({
    String? status,
    String? topic,
    String? search,
  }) {
    return repository.getWords(
      status: status,
      topic: topic,
      search: search,
    );
  }
}
