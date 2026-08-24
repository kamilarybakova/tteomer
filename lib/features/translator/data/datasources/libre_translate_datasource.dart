import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import '../../../../core/utils/app_config.dart';
import '../models/translation_model.dart';

class LibreTranslateDatasource {
  final String baseUrl;
  final String? apiKey;
  final http.Client _client;

  LibreTranslateDatasource({String? baseUrl, this.apiKey, http.Client? client})
    : baseUrl = (baseUrl ?? AppConfig.libreTranslateBaseUrl).replaceAll(
        RegExp(r'/$'),
        '',
      ),
      _client = client ?? http.Client();

  Future<TranslationModel> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    debugPrint(
      '▶ translate() called | $sourceLanguage → $targetLanguage | text: "$text"',
    );

    final requestBody = <String, dynamic>{
      'q': text,
      'source': sourceLanguage,
      'target': targetLanguage,
      'format': 'text',
    };

    final normalizedApiKey = apiKey?.trim();
    if (normalizedApiKey != null && normalizedApiKey.isNotEmpty) {
      requestBody['api_key'] = normalizedApiKey;
    }

    debugPrint('📤 POST $baseUrl/translate\nBody: ${jsonEncode(requestBody)}');

    final stopwatch = Stopwatch()..start();

    late http.Response response;
    try {
      response = await _client.post(
        Uri.parse('$baseUrl/translate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
    } catch (e) {
      debugPrint(
        '🔴 Network error after ${stopwatch.elapsedMilliseconds}ms: $e',
      );
      rethrow;
    }

    stopwatch.stop();

    debugPrint(
      '📥 Response | status: ${response.statusCode} | ${stopwatch.elapsedMilliseconds}ms\nBody: ${response.body}',
    );

    if (response.statusCode != 200) {
      debugPrint('🔴 API error ${response.statusCode}: ${response.body}');
      throw Exception(
        'LibreTranslate API error: ${response.statusCode} - ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final translatedText = _extractTranslation(json);

    debugPrint('✅ Translation success | result: "$translatedText"');

    return TranslationModel.fromTranslationResponse(
      originalText: text,
      translatedText: translatedText,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }

  String _extractTranslation(Map<String, dynamic> json) {
    try {
      final result = (json['translatedText'] as String).trim();
      return result;
    } catch (e) {
      debugPrint('🔴 Failed to parse LibreTranslate response: $e\nJSON: $json');
      throw Exception('Failed to parse LibreTranslate response: $e');
    }
  }
}
