import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/gemini_translation_datasource.dart';
import '../../data/repositories/translation_repository_impl.dart';
import '../../domain/entities/language_entity.dart';
import '../../domain/usecases/translate_usecase.dart';
import 'translator_state.dart';

// ── Providers ──────────────────────────────────────────────────────────────

final geminiDatasourceProvider = Provider<GeminiTranslationDatasource>((ref) {
  return GeminiTranslationDatasource(
    apiKey: 'AIzaSyBa1M7_FckP_1cBzAuRi1hYh59qsKksX4U',
  );
});

final translationRepositoryProvider =
Provider<TranslationRepositoryImpl>((ref) {
  return TranslationRepositoryImpl(ref.watch(geminiDatasourceProvider));
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
      : super(TranslatorState.initial());

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

    state = state.copyWith(
      status: TranslatorStatus.loading,
      clearError: true,
    );

    try {
      final result = await _translateUseCase(
        text: state.inputText,
        sourceLanguage: state.sourceLanguage.name,
        targetLanguage: state.targetLanguage.name,
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