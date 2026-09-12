import '../../domain/entities/shared_dictionary_word.dart';
import '../../domain/repositories/shared_dictionary_repository.dart';
import '../datasources/shared_dictionary_remote_datasource.dart';

class SharedDictionaryRepositoryImpl implements SharedDictionaryRepository {
  final SharedDictionaryRemoteDatasource remoteDatasource;

  const SharedDictionaryRepositoryImpl(this.remoteDatasource);

  @override
  Future<({List<SharedDictionaryWord> words, bool hasMore})> getWords({
    String? level,
    String? topic,
    String? search,
    int page = 1,
    int pageSize = 20,
  }) {
    return remoteDatasource.getWords(
      level: level,
      topic: topic,
      search: search,
      page: page,
      pageSize: pageSize,
    );
  }
}
