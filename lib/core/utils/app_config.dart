class AppConfig {
  // static const apiBaseUrl = 'https://tteomer.dev';
  static const apiBaseUrl = 'https://dev.tteomer.dev';
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
  static const iosAppStoreUrl = String.fromEnvironment(
    'IOS_APP_STORE_URL',
    defaultValue: 'https://apps.apple.com/us/app/tteomer/id6764529479',
  );
}
