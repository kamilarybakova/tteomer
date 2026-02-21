import '../entities/word.dart';

abstract class DictionaryRepository {
  Future<List<Word>> getWords({
    String? status,
    String? topic,
    String? search,
  });
}
