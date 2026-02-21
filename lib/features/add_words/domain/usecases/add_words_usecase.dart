import '../../../dictionary/domain/entities/word.dart';
import '../repositories/add_word_repository.dart';

class AddWords {
  final AddWordRepository repository;

  AddWords(this.repository);

  Future<List<String>> call(String rawText) {
    if (rawText.trim().isEmpty) {
      throw Exception('Text cannot be empty');
    }
    return repository.addWords(rawText);
  }
}
