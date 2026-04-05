import '../entities/translation_entity.dart';

abstract class TranslationRepository {
  Future<TranslationEntity> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  });
}