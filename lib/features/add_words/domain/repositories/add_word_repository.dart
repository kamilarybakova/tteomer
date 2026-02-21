import '../../../dictionary/domain/entities/word.dart';

abstract class AddWordRepository {
  Future<List<String>> addWords(String rawText);
}
