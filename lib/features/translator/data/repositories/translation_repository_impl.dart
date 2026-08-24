import '../../domain/entities/translation_entity.dart';
import '../../domain/repositories/translation_repository.dart';
import '../datasources/google_translate_datasource.dart';
import '../datasources/libre_translate_datasource.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  final GoogleTranslateDatasource _googleDatasource;
  final LibreTranslateDatasource _libreDatasource;

  TranslationRepositoryImpl(this._googleDatasource, this._libreDatasource);

  @override
  Future<TranslationEntity> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    if (!_googleDatasource.isConfigured) {
      return _libreDatasource.translate(
        text: text,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
    }

    try {
      return await _googleDatasource.translate(
        text: text,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
    } on GoogleTranslateApiException catch (error) {
      if (!error.isQuotaExceeded) {
        rethrow;
      }

      return _libreDatasource.translate(
        text: text,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
    }
  }
}
