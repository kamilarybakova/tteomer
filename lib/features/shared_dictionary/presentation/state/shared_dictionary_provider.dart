import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/shared_dictionary_remote_datasource.dart';
import '../../data/repositories/shared_dictionary_repository_impl.dart';
import '../../domain/repositories/shared_dictionary_repository.dart';
import '../../domain/usecases/get_shared_dictionary_words.dart';
import 'shared_dictionary_notifier.dart';
import 'shared_dictionary_state.dart';

final sharedDictionaryDatasourceProvider = Provider(
  (ref) => SharedDictionaryRemoteDatasource(ref.read(dioProvider)),
);

final sharedDictionaryRepositoryProvider = Provider<SharedDictionaryRepository>(
  (ref) => SharedDictionaryRepositoryImpl(
    ref.read(sharedDictionaryDatasourceProvider),
  ),
);

final getSharedDictionaryWordsProvider = Provider(
  (ref) =>
      GetSharedDictionaryWords(ref.read(sharedDictionaryRepositoryProvider)),
);

final sharedDictionaryProvider =
    StateNotifierProvider.autoDispose<
      SharedDictionaryNotifier,
      SharedDictionaryState
    >(
      (ref) =>
          SharedDictionaryNotifier(ref.read(getSharedDictionaryWordsProvider)),
    );
