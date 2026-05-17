import 'package:dio/dio.dart';

import '../models/word_model.dart';

class DictionaryRemoteDatasource {
  final Dio dio;

  DictionaryRemoteDatasource(this.dio);

  Future<({List<WordModel> words, bool hasMore})> getWords({
    String? topic,
    String? search,
    int page = 1,
    int pageSize = 5,
  }) async {
    final response = await dio.get(
      '/api/v1/dictionary/my/',
      queryParameters: {
        if (topic != null) 'topic': topic,
        if (search != null) 'search': search,
        'page': page,
        'page_size': pageSize,
      },
    );

    final data = response.data['data'];
    final results = data['results'] as List;
    final next = data['next'];

    return (
    words: results.map((e) => WordModel.fromJson(e)).toList(),
    hasMore: next != null,
    );
  }

  Future<void> deleteWord(int id) async {
    await dio.delete('/api/v1/dictionary/dictionary/$id/');
  }

  Future<void> clearDictionary() async {
    await dio.delete('/api/v1/dictionary/dictionary/clear/');
  }
}
