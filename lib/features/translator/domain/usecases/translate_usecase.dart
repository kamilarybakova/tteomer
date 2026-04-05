import '../entities/translation_entity.dart';
import '../repositories/translation_repository.dart';

class TranslateUseCase {
  final TranslationRepository _repository;

  TranslateUseCase(this._repository);

  Future<TranslationEntity> call({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    if (text.trim().isEmpty) {
      throw ArgumentError('Text cannot be empty');
    }

    if (sourceLanguage == targetLanguage) {
      return TranslationEntity(
        originalText: text,
        translatedText: text,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        createdAt: DateTime.now(),
      );
    }

    return _repository.translate(
      text: text,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }
}