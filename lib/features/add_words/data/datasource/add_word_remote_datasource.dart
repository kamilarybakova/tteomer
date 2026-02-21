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
    return List<String>.from(data['added_words'] as List);
  }
}
