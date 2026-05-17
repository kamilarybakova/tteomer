import '../../domain/entities/language_entity.dart';
import '../../domain/entities/translation_entity.dart';

enum TranslatorStatus { idle, loading, success, error }

class TranslatorState {
  final String inputText;
  final TranslationEntity? translation;
  final LanguageEntity sourceLanguage;
  final LanguageEntity targetLanguage;
  final TranslatorStatus status;
  final String? errorMessage;

  const TranslatorState({
    this.inputText = '',
    this.translation,
    required this.sourceLanguage,
    required this.targetLanguage,
    this.status = TranslatorStatus.idle,
    this.errorMessage,
  });

  factory TranslatorState.initial() => const TranslatorState(
    sourceLanguage: LanguageEntity(
      code: 'ru',
      name: 'Russian',
      nativeName: 'Русский',
      flag: '🇷🇺',
    ),
    targetLanguage: LanguageEntity(
      code: 'tr',
      name: 'Turkish',
      nativeName: 'Türkçe',
      flag: '🇹🇷',
    ),
  );

  bool get isLoading => status == TranslatorStatus.loading;
  bool get hasError => status == TranslatorStatus.error;
  bool get hasResult => status == TranslatorStatus.success && translation != null;

  TranslatorState copyWith({
    String? inputText,
    TranslationEntity? translation,
    LanguageEntity? sourceLanguage,
    LanguageEntity? targetLanguage,
    TranslatorStatus? status,
    String? errorMessage,
    bool clearTranslation = false,
    bool clearError = false,
  }) {
    return TranslatorState(
      inputText: inputText ?? this.inputText,
      translation: clearTranslation ? null : (translation ?? this.translation),
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
