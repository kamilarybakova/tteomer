import 'package:dio/dio.dart';

class AddWordRemoteDatasource {
  final Dio dio;

  AddWordRemoteDatasource(this.dio);

  Future<List<String>> addWords(String rawText) async {
    final response = await dio.post(
      '/api/v1/dictionary/submit/',
      data: {'text': rawText},
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final addedWords = data['added_words'];

    // API can return either:
    // - added_words: ["word1", "word2"]
    // - added_words: 1
    if (addedWords is List) {
      return List<String>.from(addedWords);
    }

    return <String>[];
  }
}
