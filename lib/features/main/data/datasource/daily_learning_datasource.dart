import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/utils/app_config.dart';
import '../model/daily_learning_content.dart';

class DailyLearningDatasource {
  DailyLearningDatasource({http.Client? client})
    : _client = client ?? http.Client();

  static const _geminiModel = 'models/gemini-2.5-flash';
  static const _geminiUrl =
      'https://generativelanguage.googleapis.com/v1beta/$_geminiModel:generateContent';

  final http.Client _client;

  Future<DailyLearningContent> getDailyContent({
    required String localeCode,
    required String level,
    required DateTime date,
  }) async {
    final normalizedLocale = _normalizeLocale(localeCode);
    final normalizedLevel = _normalizeLevel(level);

    if (AppConfig.geminiApiKey.trim().isNotEmpty) {
      try {
        return await _generateWithGemini(
          localeCode: normalizedLocale,
          level: normalizedLevel,
          date: date,
        );
      } catch (_) {
        // Fall back to local curated content if Gemini is unavailable.
      }
    }

    return _fallbackContent(
      localeCode: normalizedLocale,
      level: normalizedLevel,
      date: date,
    );
  }

  Future<DailyLearningContent> _generateWithGemini({
    required String localeCode,
    required String level,
    required DateTime date,
  }) async {
    final requestBody = jsonEncode({
      'contents': [
        {
          'parts': [
            {
              'text': _buildPrompt(
                localeCode: localeCode,
                level: level,
                date: date,
              ),
            },
          ],
        },
      ],
      'generationConfig': {
        'temperature': 0.7,
        'topP': 0.9,
        'maxOutputTokens': 700,
        'responseMimeType': 'application/json',
      },
    });

    final response = await _client.post(
      Uri.parse('$_geminiUrl?key=${AppConfig.geminiApiKey}'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini API error: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = json['candidates'] as List<dynamic>;
    final content = candidates.first['content'] as Map<String, dynamic>;
    final parts = content['parts'] as List<dynamic>;
    final text = (parts.first['text'] as String).trim();
    final payload = jsonDecode(text) as Map<String, dynamic>;

    return DailyLearningContent(
      level: (payload['level'] as String? ?? level).toUpperCase(),
      word: payload['word'] as String? ?? '',
      wordTranslation: payload['word_translation'] as String? ?? '',
      wordHint: payload['word_hint'] as String? ?? '',
      sentence: payload['sentence'] as String? ?? '',
      sentenceTranslation: payload['sentence_translation'] as String? ?? '',
    );
  }

  String _buildPrompt({
    required String localeCode,
    required String level,
    required DateTime date,
  }) {
    final audienceLanguage = switch (localeCode) {
      'ru' => 'Russian',
      'ky' => 'Kyrgyz',
      'tr' => 'Turkish',
      _ => 'English',
    };

    final isoDate = date.toIso8601String().split('T').first;

    return '''
You create Turkish-learning micro content for a mobile app.

Generate content for date $isoDate and CEFR level $level.
The learner studies Turkish. Explanations and translations must be in $audienceLanguage.

Requirements:
- Pick exactly 1 Turkish word appropriate for level $level
- Pick exactly 1 short Turkish sentence appropriate for level $level
- The sentence should feel natural and useful in daily life
- Keep the sentence length suitable for the level
- Return valid JSON only
- No markdown

Use this exact JSON shape:
{
  "level": "$level",
  "word": "Turkish word",
  "word_translation": "$audienceLanguage translation",
  "word_hint": "Short hint in $audienceLanguage",
  "sentence": "Turkish sentence",
  "sentence_translation": "$audienceLanguage translation"
}
''';
  }

  DailyLearningContent _fallbackContent({
    required String localeCode,
    required String level,
    required DateTime date,
  }) {
    final items = _fallbackByLevel[level] ?? _fallbackByLevel['A1']!;
    final index = _dayOfYear(date) % items.length;
    final item = items[index];

    return DailyLearningContent(
      level: level,
      word: item.word,
      wordTranslation: item.translation(localeCode),
      wordHint: item.hint(localeCode),
      sentence: item.sentence,
      sentenceTranslation: item.sentenceTranslation(localeCode),
    );
  }

  int _dayOfYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    return date.difference(start).inDays + 1;
  }

  String _normalizeLocale(String localeCode) {
    const supported = {'ru', 'ky', 'tr', 'en'};
    return supported.contains(localeCode) ? localeCode : 'en';
  }

  String _normalizeLevel(String level) {
    final normalized = level.trim().toUpperCase();
    const supported = {'A1', 'A2', 'B1', 'B2', 'C1', 'C2'};
    return supported.contains(normalized) ? normalized : 'A1';
  }
}

class _FallbackLearningItem {
  final String word;
  final Map<String, String> translations;
  final Map<String, String> hints;
  final String sentence;
  final Map<String, String> sentenceTranslations;

  const _FallbackLearningItem({
    required this.word,
    required this.translations,
    required this.hints,
    required this.sentence,
    required this.sentenceTranslations,
  });

  String translation(String localeCode) =>
      translations[localeCode] ?? translations['en'] ?? '';

  String hint(String localeCode) => hints[localeCode] ?? hints['en'] ?? '';

  String sentenceTranslation(String localeCode) =>
      sentenceTranslations[localeCode] ?? sentenceTranslations['en'] ?? '';
}

const Map<String, List<_FallbackLearningItem>> _fallbackByLevel = {
  'A1': [
    _FallbackLearningItem(
      word: 'merhaba',
      translations: {
        'ru': 'привет',
        'ky': 'салам',
        'tr': 'merhaba',
        'en': 'hello',
      },
      hints: {
        'ru': 'Базовое приветствие на каждый день.',
        'ky': 'Күн сайын колдонулуучу жөнөкөй саламдашуу.',
        'tr': 'Günlük hayatta kullanabileceğin temel bir selamlaşma.',
        'en': 'A basic everyday greeting.',
      },
      sentence: 'Merhaba, nasılsın?',
      sentenceTranslations: {
        'ru': 'Привет, как дела?',
        'ky': 'Салам, кандайсың?',
        'tr': 'Merhaba, nasılsın?',
        'en': 'Hello, how are you?',
      },
    ),
    _FallbackLearningItem(
      word: 'su',
      translations: {'ru': 'вода', 'ky': 'суу', 'tr': 'water', 'en': 'water'},
      hints: {
        'ru': 'Одно из самых первых бытовых слов.',
        'ky': 'Күнүмдүк жашоодогу эң негизги сөздөрдүн бири.',
        'tr': 'Günlük hayatta en temel kelimelerden biri.',
        'en': 'One of the first everyday words to learn.',
      },
      sentence: 'Bir bardak su alabilir miyim?',
      sentenceTranslations: {
        'ru': 'Можно мне стакан воды?',
        'ky': 'Мага бир стакан суу бересизби?',
        'tr': 'Bir bardak su alabilir miyim?',
        'en': 'May I have a glass of water?',
      },
    ),
  ],
  'A2': [
    _FallbackLearningItem(
      word: 'otobüs',
      translations: {
        'ru': 'автобус',
        'ky': 'автобус',
        'tr': 'bus',
        'en': 'bus',
      },
      hints: {
        'ru': 'Полезное слово для транспорта и города.',
        'ky': 'Шаар ичинде жүрүүдө керек болгон сөз.',
        'tr': 'Şehir içi ulaşımda kullanılan temel bir kelime.',
        'en': 'A useful word for transport and city life.',
      },
      sentence: 'Otobüs saat sekizde geliyor.',
      sentenceTranslations: {
        'ru': 'Автобус приходит в восемь часов.',
        'ky': 'Автобус саат сегизде келет.',
        'tr': 'Otobüs saat sekizde geliyor.',
        'en': 'The bus arrives at eight o’clock.',
      },
    ),
    _FallbackLearningItem(
      word: 'kahvaltı',
      translations: {
        'ru': 'завтрак',
        'ky': 'эртең мененки тамак',
        'tr': 'breakfast',
        'en': 'breakfast',
      },
      hints: {
        'ru': 'Часто встречается в бытовых диалогах.',
        'ky': 'Күнүмдүк сүйлөшүүдө көп колдонулат.',
        'tr': 'Günlük konuşmalarda sık kullanılır.',
        'en': 'Common in everyday conversations.',
      },
      sentence: 'Bugün kahvaltıda peynir ve zeytin var.',
      sentenceTranslations: {
        'ru': 'Сегодня на завтрак есть сыр и оливки.',
        'ky': 'Бүгүн эртең мененки тамакта сыр жана зайтун бар.',
        'tr': 'Bugün kahvaltıda peynir ve zeytin var.',
        'en': 'Today there is cheese and olives for breakfast.',
      },
    ),
  ],
  'B1': [
    _FallbackLearningItem(
      word: 'alışveriş',
      translations: {
        'ru': 'покупки',
        'ky': 'соода',
        'tr': 'shopping',
        'en': 'shopping',
      },
      hints: {
        'ru': 'Подходит для бытовых и городских тем.',
        'ky': 'Күнүмдүк жана шаар темаларына ылайыктуу сөз.',
        'tr': 'Günlük hayat ve şehir konuları için uygun.',
        'en': 'Fits everyday and city-related topics.',
      },
      sentence: 'Hafta sonu alışveriş merkezine gitmeyi planlıyorum.',
      sentenceTranslations: {
        'ru': 'На выходных я планирую пойти в торговый центр.',
        'ky': 'Дем алышта соода борборуна барууну пландап жатам.',
        'tr': 'Hafta sonu alışveriş merkezine gitmeyi planlıyorum.',
        'en': 'I am planning to go to the shopping mall this weekend.',
      },
    ),
    _FallbackLearningItem(
      word: 'deneyim',
      translations: {
        'ru': 'опыт',
        'ky': 'тажрыйба',
        'tr': 'experience',
        'en': 'experience',
      },
      hints: {
        'ru': 'Полезно для разговоров об учёбе и работе.',
        'ky': 'Окуу жана жумуш тууралуу сүйлөшүүдө пайдалуу.',
        'tr': 'Eğitim ve iş konularında işe yarar.',
        'en': 'Useful when talking about study and work.',
      },
      sentence: 'Bu kurs benim için çok faydalı bir deneyim oldu.',
      sentenceTranslations: {
        'ru': 'Этот курс стал для меня очень полезным опытом.',
        'ky': 'Бул курс мен үчүн абдан пайдалуу тажрыйба болду.',
        'tr': 'Bu kurs benim için çok faydalı bir deneyim oldu.',
        'en': 'This course became a very useful experience for me.',
      },
    ),
  ],
  'B2': [
    _FallbackLearningItem(
      word: 'geliştirmek',
      translations: {
        'ru': 'развивать',
        'ky': 'өнүктүрүү',
        'tr': 'to improve',
        'en': 'to improve',
      },
      hints: {
        'ru': 'Часто используется в академической и учебной речи.',
        'ky': 'Окуу жана академиялык сүйлөөдө көп колдонулат.',
        'tr': 'Akademik ve eğitsel dilde sık görülür.',
        'en': 'Frequently used in academic and educational speech.',
      },
      sentence: 'Türkçe konuşma becerimi her gün geliştirmeye çalışıyorum.',
      sentenceTranslations: {
        'ru': 'Я стараюсь каждый день развивать навык разговорного турецкого.',
        'ky':
            'Мен күн сайын түркчө сүйлөө жөндөмүмдү өнүктүрүүгө аракет кылам.',
        'tr': 'Türkçe konuşma becerimi her gün geliştirmeye çalışıyorum.',
        'en': 'I try to improve my Turkish speaking skill every day.',
      },
    ),
    _FallbackLearningItem(
      word: 'sorumluluk',
      translations: {
        'ru': 'ответственность',
        'ky': 'жоопкерчилик',
        'tr': 'responsibility',
        'en': 'responsibility',
      },
      hints: {
        'ru': 'Хорошее слово для тем про работу и учёбу.',
        'ky': 'Жумуш жана окуу темалары үчүн жакшы сөз.',
        'tr': 'İş ve eğitim konuları için yararlı bir kelime.',
        'en': 'A good word for work and study topics.',
      },
      sentence: 'Yeni projede daha fazla sorumluluk almam gerekecek.',
      sentenceTranslations: {
        'ru':
            'В новом проекте мне придётся взять на себя больше ответственности.',
        'ky': 'Жаңы долбоордо көбүрөөк жоопкерчилик алышым керек болот.',
        'tr': 'Yeni projede daha fazla sorumluluk almam gerekecek.',
        'en': 'I will need to take more responsibility in the new project.',
      },
    ),
  ],
  'C1': [
    _FallbackLearningItem(
      word: 'yaklaşım',
      translations: {
        'ru': 'подход',
        'ky': 'ыкма',
        'tr': 'approach',
        'en': 'approach',
      },
      hints: {
        'ru': 'Подходит для более абстрактных обсуждений.',
        'ky': 'Абстрактуу темаларды талкуулоого ылайыктуу.',
        'tr': 'Daha soyut tartışmalar için uygun bir kelime.',
        'en': 'Suitable for more abstract discussions.',
      },
      sentence: 'Bu konuya daha sistemli bir yaklaşımla bakmak gerekiyor.',
      sentenceTranslations: {
        'ru': 'На эту тему нужно смотреть более системным подходом.',
        'ky': 'Бул маселеге кыйла системалуу ыкма менен кароо керек.',
        'tr': 'Bu konuya daha sistemli bir yaklaşımla bakmak gerekiyor.',
        'en': 'This topic needs to be approached more systematically.',
      },
    ),
    _FallbackLearningItem(
      word: 'değerlendirmek',
      translations: {
        'ru': 'оценивать',
        'ky': 'баалоо',
        'tr': 'to evaluate',
        'en': 'to evaluate',
      },
      hints: {
        'ru': 'Часто встречается в формальной и аналитической речи.',
        'ky': 'Расмий жана талдоочу сүйлөөдө көп жолугат.',
        'tr': 'Resmî ve analitik dilde sık kullanılır.',
        'en': 'Common in formal and analytical language.',
      },
      sentence:
          'Karar vermeden önce tüm seçenekleri dikkatlice değerlendirmeliyiz.',
      sentenceTranslations: {
        'ru':
            'Перед принятием решения нам нужно внимательно оценить все варианты.',
        'ky':
            'Чечим кабыл алардан мурда бардык варианттарды кылдат баалашыбыз керек.',
        'tr':
            'Karar vermeden önce tüm seçenekleri dikkatlice değerlendirmeliyiz.',
        'en':
            'Before making a decision, we should evaluate all options carefully.',
      },
    ),
  ],
  'C2': [
    _FallbackLearningItem(
      word: 'nitelik',
      translations: {
        'ru': 'качество / характеристика',
        'ky': 'сапат / касиет',
        'tr': 'quality / attribute',
        'en': 'quality / attribute',
      },
      hints: {
        'ru': 'Слово для точных и продвинутых формулировок.',
        'ky': 'Так жана өнүккөн ой жүгүртүү үчүн пайдалуу сөз.',
        'tr': 'İnce ve ileri düzey anlatımlar için uygundur.',
        'en': 'Useful for precise, advanced expression.',
      },
      sentence: 'Bu eserin en dikkat çekici niteliği dilinin akıcılığıdır.',
      sentenceTranslations: {
        'ru':
            'Самое примечательное качество этого произведения — плавность его языка.',
        'ky':
            'Бул чыгарманын эң көңүл бурдурган сапаты анын тилинин жатыктыгы.',
        'tr': 'Bu eserin en dikkat çekici niteliği dilinin akıcılığıdır.',
        'en':
            'The most striking quality of this work is the fluency of its language.',
      },
    ),
    _FallbackLearningItem(
      word: 'özgün',
      translations: {
        'ru': 'самобытный / оригинальный',
        'ky': 'өзгөчө / оригиналдуу',
        'tr': 'original / distinctive',
        'en': 'original / distinctive',
      },
      hints: {
        'ru': 'Подходит для описания идей, стиля и творчества.',
        'ky': 'Идеяны, стилди жана чыгармачылыкты сүрөттөөгө ылайыктуу.',
        'tr': 'Fikirleri, üslubu ve yaratıcılığı anlatmak için uygundur.',
        'en': 'Useful for describing ideas, style, and creativity.',
      },
      sentence: 'Yazarın özgün anlatım tarzı eseri unutulmaz kılıyor.',
      sentenceTranslations: {
        'ru': 'Самобытный стиль автора делает произведение незабываемым.',
        'ky': 'Автордун өзгөчө баяндоо стили чыгарманы унутулгус кылат.',
        'tr': 'Yazarın özgün anlatım tarzı eseri unutulmaz kılıyor.',
        'en':
            'The author’s distinctive narrative style makes the work unforgettable.',
      },
    ),
  ],
};
