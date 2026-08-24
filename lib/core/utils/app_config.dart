class AppConfig {
  static const apiBaseUrl = 'https://tteomer.dev';
  static const googleTranslateApiKey =
      'AIzaSyAWCZzT2CHSqekjsRSanndUX236DYwvKKc';
  static const geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );
  static const libreTranslateBaseUrl = String.fromEnvironment(
    'LIBRETRANSLATE_URL',
    defaultValue: 'http://localhost:5000',
  );
  static const libreTranslateApiKey = String.fromEnvironment(
    'LIBRETRANSLATE_API_KEY',
    defaultValue: '',
  );
}
