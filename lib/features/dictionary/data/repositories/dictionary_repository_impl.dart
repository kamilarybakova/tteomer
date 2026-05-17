import '../../domain/entities/word.dart';
import '../../domain/repositories/dictionary_repository.dart';
import '../datasources/dictionary_remote_datasource.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryRemoteDatasource remoteDatasource;

  DictionaryRepositoryImpl({
    required this.remoteDatasource,
  });

  @override
  Future<({List<Word> words, bool hasMore})> getWords({
    String? status,
    String? topic,
    String? search,
    int page = 1,
    int pageSize = 5,
  }) {
    return remoteDatasource.getWords(
      topic: topic,
      search: search,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<void> clearDictionary() {
    return remoteDatasource.clearDictionary();
  }

  @override
  Future<void> deleteWord(int id) {
    return remoteDatasource.deleteWord(id);
  }
}
