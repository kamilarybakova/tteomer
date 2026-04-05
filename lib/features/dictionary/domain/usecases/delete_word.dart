import '../entities/word.dart';
import '../repositories/dictionary_repository.dart';

class DeleteWord {
  final DictionaryRepository repository;

  DeleteWord(this.repository);

  Future<void> call(
      int id,
    ) {
    return repository.deleteWord(id);
  }
}
