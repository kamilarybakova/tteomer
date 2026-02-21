import '../../../dictionary/domain/entities/word.dart';
import '../../domain/repositories/add_word_repository.dart';
import '../datasource/add_word_remote_datasource.dart';

class AddWordRepositoryImpl implements AddWordRepository {
  final AddWordRemoteDatasource remote;

  AddWordRepositoryImpl(this.remote);

  @override
  Future<List<String>> addWords(String rawText) {
    return remote.addWords(rawText);
  }
}
