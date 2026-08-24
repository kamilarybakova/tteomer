import '../../domain/entities/translation_entity.dart';

class TranslationModel extends TranslationEntity {
  const TranslationModel({
    required super.originalText,
    required super.translatedText,
    required super.sourceLanguage,
    required super.targetLanguage,
    required super.createdAt,
  });

  factory TranslationModel.fromTranslationResponse({
    required String originalText,
    required String translatedText,
    required String sourceLanguage,
    required String targetLanguage,
  }) {
    return TranslationModel(
      originalText: originalText,
      translatedText: translatedText,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      createdAt: DateTime.now(),
    );
  }
}
