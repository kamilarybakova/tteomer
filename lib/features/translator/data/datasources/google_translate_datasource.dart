import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/translation_model.dart';

class GoogleTranslateApiException implements Exception {
  final int statusCode;
  final String body;

  const GoogleTranslateApiException({
    required this.statusCode,
    required this.body,
  });

  bool get isQuotaExceeded {
    final normalizedBody = body.toLowerCase();
    return statusCode == 403 &&
            (normalizedBody.contains('daily limit exceeded') ||
                normalizedBody.contains('user rate limit exceeded') ||
                normalizedBody.contains('rate limit') ||
                normalizedBody.contains('quota')) ||
        statusCode == 429 ||
        normalizedBody.contains('resource_exhausted');
  }

  @override
  String toString() {
    return 'GoogleTranslateApiException(statusCode: $statusCode, body: $body)';
  }
}

class GoogleTranslateDatasource {
  GoogleTranslateDatasource({required this.apiKey, http.Client? client})
    : _client = client ?? http.Client();

  static const String _baseUrl =
      'https://translation.googleapis.com/language/translate/v2';

  final String apiKey;
  final http.Client _client;

  bool get isConfigured => apiKey.trim().isNotEmpty;

  Future<TranslationModel> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final requestBody = <String, dynamic>{
      'q': text,
      'source': sourceLanguage,
      'target': targetLanguage,
      'format': 'text',
    };

    debugPrint(
      '📤 POST $_baseUrl | $sourceLanguage → $targetLanguage\nBody: ${jsonEncode(requestBody)}',
    );

    final stopwatch = Stopwatch()..start();

    late http.Response response;
    try {
      response = await _client.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
    } catch (e) {
      debugPrint(
        '🔴 Google Translate network error after ${stopwatch.elapsedMilliseconds}ms: $e',
      );
      rethrow;
    }

    stopwatch.stop();

    debugPrint(
      '📥 Google Translate response | status: ${response.statusCode} | ${stopwatch.elapsedMilliseconds}ms\nBody: ${response.body}',
    );

    if (response.statusCode != 200) {
      throw GoogleTranslateApiException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final translatedText = _extractTranslation(json);

    return TranslationModel.fromTranslationResponse(
      originalText: text,
      translatedText: translatedText,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }

  String _extractTranslation(Map<String, dynamic> json) {
    try {
      final data = json['data'] as Map<String, dynamic>;
      final translations = data['translations'] as List<dynamic>;
      final translation = translations.first as Map<String, dynamic>;
      return (translation['translatedText'] as String).trim();
    } catch (e) {
      debugPrint('🔴 Failed to parse Google Translate response: $e\n$json');
      throw Exception('Failed to parse Google Translate response: $e');
    }
  }
}
