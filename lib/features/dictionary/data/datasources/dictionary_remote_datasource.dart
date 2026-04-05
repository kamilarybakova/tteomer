import 'package:dio/dio.dart';

import '../models/word_model.dart';

class DictionaryRemoteDatasource {
  final Dio dio;

  DictionaryRemoteDatasource(this.dio);

  Future<List<WordModel>> getWords({
    String? topic,
    String? search,
  }) async {
    final response = await dio.get(
      '/api/v1/dictionary/my/',
      queryParameters: {
        if (topic != null) 'topic': topic,
        if (search != null) 'search': search,
      },
    );

    final results = response.data['data']['results'] as List;
    return results.map((e) => WordModel.fromJson(e)).toList();
  }

  Future<void> deleteWord(int id) async {
    await dio.delete('/api/v1/dictionary/dictionary/$id/');
  }

  Future<void> clearDictionary() async {
    await dio.delete('/api/v1/dictionary/dictionary/clear/');
  }
}
