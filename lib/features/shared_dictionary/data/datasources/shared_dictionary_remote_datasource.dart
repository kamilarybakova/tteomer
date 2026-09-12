import 'package:dio/dio.dart';

import '../models/shared_dictionary_word_model.dart';

class SharedDictionaryRemoteDatasource {
  final Dio dio;

  const SharedDictionaryRemoteDatasource(this.dio);

  Future<({List<SharedDictionaryWordModel> words, bool hasMore})> getWords({
    String? level,
    String? topic,
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await dio.get<dynamic>(
      '/api/v1/dictionary/shared/',
      queryParameters: {
        if (level != null && level.isNotEmpty) 'level': level,
        if (topic != null && topic.isNotEmpty) 'topic': topic,
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
        'page_size': pageSize,
      },
    );

    final responseBody = response.data;
    if (responseBody is! Map) {
      throw const FormatException('Invalid shared dictionary response');
    }

    final payload = responseBody['data'] is Map
        ? responseBody['data'] as Map
        : responseBody;
    final rawResults = payload['results'];
    if (rawResults is! List) {
      throw const FormatException('Shared dictionary results are missing');
    }

    return (
      words: rawResults
          .whereType<Map>()
          .map(
            (json) => SharedDictionaryWordModel.fromJson(
              Map<String, dynamic>.from(json),
            ),
          )
          .toList(),
      hasMore: payload['next'] != null,
    );
  }
}
