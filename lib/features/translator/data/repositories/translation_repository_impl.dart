import '../../domain/entities/translation_entity.dart';
import '../../domain/repositories/translation_repository.dart';
import '../datasources/gemini_translation_datasource.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  final GeminiTranslationDatasource _datasource;

  TranslationRepositoryImpl(this._datasource);

  @override
  Future<TranslationEntity> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    return _datasource.translate(
      text: text,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }
}