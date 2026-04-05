class LanguageEntity {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const LanguageEntity({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });

  static const List<LanguageEntity> supportedLanguages = [
    LanguageEntity(
      code: 'ru',
      name: 'Russian',
      nativeName: 'Русский',
      flag: '🇷🇺',
    ),
    LanguageEntity(
      code: 'ky',
      name: 'Kyrgyz',
      nativeName: 'Кыргызча',
      flag: '🇰🇬',
    ),
    LanguageEntity(
      code: 'tr',
      name: 'Turkish',
      nativeName: 'Türkçe',
      flag: '🇹🇷',
    ),
    LanguageEntity(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇬🇧',
    ),
  ];
}