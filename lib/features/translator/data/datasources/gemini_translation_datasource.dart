import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import '../models/translation_model.dart';

class GeminiTranslationDatasource {
  final String apiKey;
  final http.Client _client;

  static const String _model = 'models/gemini-2.5-flash';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/$_model:generateContent';

  GeminiTranslationDatasource({
    required this.apiKey,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<TranslationModel> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    debugPrint(
      '▶ translate() called | $sourceLanguage → $targetLanguage | text: "$text"',
    );

    final prompt = _buildPrompt(
      text: text,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );

    final requestBody = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.1,
        'maxOutputTokens': 1024,
      },
    });

    debugPrint(
      '📤 POST $_baseUrl\nBody: $requestBody',
    );

    final stopwatch = Stopwatch()..start();

    late http.Response response;
    try {
      response = await _client.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );
    } catch (e, stack) {
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
      debugPrint(
        '🔴 API error ${response.statusCode}: ${response.body}',
      );
      throw Exception(
          'Gemini API error: ${response.statusCode} - ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final translatedText = _extractTranslation(json);

    debugPrint(
      '✅ Translation success | result: "$translatedText"',
    );

    return TranslationModel.fromGeminiResponse(
      originalText: text,
      translatedText: translatedText,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }

  String _buildPrompt({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) {
    return '''You are a professional translator. Translate the following text from $sourceLanguage to $targetLanguage.

Rules:
- Return ONLY the translated text, nothing else
- No explanations, no notes, no quotation marks around the result
- Preserve the original formatting (line breaks, punctuation)
- Be natural and accurate

Text to translate:
$text''';
  }

  String _extractTranslation(Map<String, dynamic> json) {
    try {
      final candidates = json['candidates'] as List<dynamic>;
      final content = candidates[0]['content'] as Map<String, dynamic>;
      final parts = content['parts'] as List<dynamic>;
      final result = (parts[0]['text'] as String).trim();
      return result;
    } catch (e, stack) {
      debugPrint(
        '🔴 Failed to parse Gemini response: $e\nJSON: $json',
      );
      throw Exception('Failed to parse Gemini response: $e');
    }
  }
}