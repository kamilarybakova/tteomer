import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/features/dictionary/domain/usecases/delete_all_words.dart';
import 'package:tteomer/features/dictionary/domain/usecases/delete_word.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/dictionary_remote_datasource.dart';
import '../../data/repositories/dictionary_repository_impl.dart';
import '../../domain/repositories/dictionary_repository.dart';
import '../../domain/usecases/get_dictionary.dart';

import 'dictionary_state.dart';
import 'dictionary_notifier.dart';

final dictionaryRemoteDatasourceProvider = Provider(
      (ref) => DictionaryRemoteDatasource(
    ref.read(dioProvider),
  ),
);

final dictionaryRepositoryProvider =
Provider<DictionaryRepository>((ref) {
  return DictionaryRepositoryImpl(
    remoteDatasource: ref.read(dictionaryRemoteDatasourceProvider),
  );
});

final getWordsProvider = Provider<GetWords>((ref) {
  return GetWords(ref.read(dictionaryRepositoryProvider));
});

final deleteWordsProvider = Provider<DeleteAllWords>((ref) {
  return DeleteAllWords(ref.read(dictionaryRepositoryProvider));
});

final deleteWordProvider = Provider<DeleteWord>((ref) {
  return DeleteWord(ref.read(dictionaryRepositoryProvider));
});

final wordsVmProvider =
StateNotifierProvider<WordsVM, DictionaryState>((ref) {
  return WordsVM(ref.read(getWordsProvider), ref.read(deleteWordsProvider), ref.read(deleteWordProvider));
});
