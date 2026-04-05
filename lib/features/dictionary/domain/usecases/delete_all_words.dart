import '../entities/word.dart';
import '../repositories/dictionary_repository.dart';

class DeleteAllWords {
  final DictionaryRepository repository;

  DeleteAllWords(this.repository);

  Future<void> call() {
    return repository.clearDictionary();
  }
}
