import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/core/storage/shared_prefs_service.dart';
import '../../../../core/utils/app_config.dart';
import '../../data/datasources/google_translate_datasource.dart';
import '../../data/datasources/libre_translate_datasource.dart';
import '../../data/repositories/translation_repository_impl.dart';
import '../../domain/entities/language_entity.dart';
import '../../domain/usecases/translate_usecase.dart';
import 'translator_state.dart';

// ── Providers ──────────────────────────────────────────────────────────────

final googleTranslateDatasourceProvider = Provider<GoogleTranslateDatasource>((
  ref,
) {
  return GoogleTranslateDatasource(apiKey: AppConfig.googleTranslateApiKey);
});

final libreTranslateDatasourceProvider = Provider<LibreTranslateDatasource>((
  ref,
) {
  return LibreTranslateDatasource(
    baseUrl: AppConfig.libreTranslateBaseUrl,
    apiKey: AppConfig.libreTranslateApiKey,
  );
});

final translationRepositoryProvider = Provider<TranslationRepositoryImpl>((
  ref,
) {
  return TranslationRepositoryImpl(
    ref.watch(googleTranslateDatasourceProvider),
    ref.watch(libreTranslateDatasourceProvider),
  );
});

final translateUseCaseProvider = Provider<TranslateUseCase>((ref) {
  return TranslateUseCase(ref.watch(translationRepositoryProvider));
});

final translatorNotifierProvider =
    StateNotifierProvider<TranslatorNotifier, TranslatorState>(
      (ref) => TranslatorNotifier(ref.watch(translateUseCaseProvider)),
    );

// ── Notifier ───────────────────────────────────────────────────────────────

class TranslatorNotifier extends StateNotifier<TranslatorState> {
  final TranslateUseCase _translateUseCase;
  Timer? _debounceTimer;

  TranslatorNotifier(this._translateUseCase)
    : super(TranslatorState.initial()) {
    _loadSavedLanguages();
  }

  Future<void> _loadSavedLanguages() async {
    final prefs = await SharedPrefsService.getInstance();
    final savedSourceCode = prefs.getTranslatorSourceLanguage();
    final savedTargetCode = prefs.getTranslatorTargetLanguage();

    final sourceLanguage = LanguageEntity.findByCode(savedSourceCode ?? '');
    final targetLanguage = LanguageEntity.findByCode(savedTargetCode ?? '');

    if (sourceLanguage == null || targetLanguage == null) {
      return;
    }

    if (sourceLanguage.code == targetLanguage.code) {
      return;
    }

    state = state.copyWith(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }

  Future<void> _persistLanguages() async {
    final prefs = await SharedPrefsService.getInstance();
    await prefs.saveTranslatorLanguages(
      sourceLanguageCode: state.sourceLanguage.code,
      targetLanguageCode: state.targetLanguage.code,
    );
  }

  void onTextChanged(String text) {
    state = state.copyWith(
      inputText: text,
      status: TranslatorStatus.idle,
      clearTranslation: text.isEmpty,
      clearError: true,
    );

    _debounceTimer?.cancel();

    if (text.trim().isEmpty) return;

    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      translate();
    });
  }

  Future<void> translate() async {
    if (state.inputText.trim().isEmpty) return;

    state = state.copyWith(status: TranslatorStatus.loading, clearError: true);

    try {
      final result = await _translateUseCase(
        text: state.inputText,
        sourceLanguage: state.sourceLanguage.code,
        targetLanguage: state.targetLanguage.code,
      );

      state = state.copyWith(
        translation: result,
        status: TranslatorStatus.success,
      );
    } catch (e) {
      state = state.copyWith(
        status: TranslatorStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void swapLanguages() {
    final previousSource = state.sourceLanguage;
    final previousTarget = state.targetLanguage;
    final previousTranslation = state.translation;

    state = state.copyWith(
      sourceLanguage: previousTarget,
      targetLanguage: previousSource,
      inputText: previousTranslation?.translatedText ?? state.inputText,
      clearTranslation: true,
      status: TranslatorStatus.idle,
    );
    unawaited(_persistLanguages());

    if (state.inputText.trim().isNotEmpty) {
      translate();
    }
  }

  void setSourceLanguage(LanguageEntity language) {
    if (language.code == state.targetLanguage.code) {
      swapLanguages();
      return;
    }
    state = state.copyWith(
      sourceLanguage: language,
      clearTranslation: true,
      status: TranslatorStatus.idle,
    );
    unawaited(_persistLanguages());
    if (state.inputText.trim().isNotEmpty) translate();
  }

  void setTargetLanguage(LanguageEntity language) {
    if (language.code == state.sourceLanguage.code) {
      swapLanguages();
      return;
    }
    state = state.copyWith(
      targetLanguage: language,
      clearTranslation: true,
      status: TranslatorStatus.idle,
    );
    unawaited(_persistLanguages());
    if (state.inputText.trim().isNotEmpty) translate();
  }

  void clearInput() {
    _debounceTimer?.cancel();
    state = TranslatorState.initial();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
