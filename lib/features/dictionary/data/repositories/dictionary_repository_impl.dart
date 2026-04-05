import '../../domain/entities/word.dart';
import '../../domain/repositories/dictionary_repository.dart';
import '../datasources/dictionary_remote_datasource.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryRemoteDatasource remoteDatasource;

  DictionaryRepositoryImpl({
    required this.remoteDatasource,
  });

  @override
  Future<List<Word>> getWords({
    String? status,
    String? topic,
    String? search,
  }) {
    return remoteDatasource.getWords(
      topic: topic,
      search: search,
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
