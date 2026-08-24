// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kirghiz Kyrgyz (`ky`).
class AppLocalizationsKy extends AppLocalizations {
  AppLocalizationsKy([String locale = 'ky']) : super(locale);

  @override
  String get appTitle => 'Бишкек Түркия Түркчөсүн Үйрөтүү Борбору';

  @override
  String get register => 'Аккаунт түзүү';

  @override
  String get signUpTitle => 'Аккаунт түзүү';

  @override
  String get nickname => 'Никнейм';

  @override
  String get enterNickname => 'Никнейм киргизиңиз';

  @override
  String get email => 'Почта';

  @override
  String get enterEmail => 'Почтаңызды киргизиңиз';

  @override
  String get password => 'Сырсөз';

  @override
  String get acceptTerms => 'Мен колдонуу шарттарын\nжана купуялык саясатын кабыл алам.';

  @override
  String get alreadyHaveAccount => 'Аккаунтуңуз барбы?';

  @override
  String get login => 'Кирүү';

  @override
  String get createAccount => 'Аккаунт түзүү';

  @override
  String get forgotPassword => 'Сырсөздү унуттуңузбу?';

  @override
  String get noAccount => 'Аккаунтуңуз жокпу?';

  @override
  String get enterGroupCode => 'Топтун кодун киргизиңиз';

  @override
  String get send => 'Жөнөтүү';

  @override
  String get resendCode => 'Кодду кайра жөнөтүү';

  @override
  String resendWithTimer(Object time) {
    return 'Кодду кайра жөнөтүү $time';
  }

  @override
  String get forgotPasswordTitle => 'Сырсөздү унуттуңузбу?';

  @override
  String get forgotPasswordDesc => 'Аккаунтуңузга байланышкан электрондук почта дарегин киргизиңиз.';

  @override
  String get sendCode => 'Код жөнөтүү';

  @override
  String get rememberPassword => 'Сырсөзүңүздү эстедиңизби?';

  @override
  String get verifyEmailTitle => 'Почтаңызды текшериңиз';

  @override
  String verifyEmailDesc(Object email) {
    return 'Биз кодду $email дарегине жөнөттүк';
  }

  @override
  String get resetPasswordTitle => 'Сырсөздү баштапкы абалга келтирүү';

  @override
  String get enterNewPassword => 'Жаңы сырсөз киргизиңиз';

  @override
  String get newPassword => 'Жаңы сырсөз';

  @override
  String get repeatPassword => 'Жаңы сырсөздү кайра киргизиңиз';

  @override
  String get resetPassword => 'Сырсөздү баштапкы абалга келтирүү';

  @override
  String get emptyDictionaryTitle => 'Сөздүк бош';

  @override
  String get emptyDictionarySubtitle => 'Окууну баштоо үчүн биринчи сөздөрдү кошуңуз';

  @override
  String get searchHint => 'Сөз издөө';

  @override
  String get tabHome => 'Башкы бет';

  @override
  String get tabDictionary => 'Сөздүк';

  @override
  String get tabDocs => 'Документтер';

  @override
  String get tabTranslator => 'Которуу';

  @override
  String get firstName => 'Аты';

  @override
  String get lastName => 'Фамилия';

  @override
  String get enterName => 'Атыңызды киргизиңиз';

  @override
  String get enterLastName => 'Фамилияңызды киргизиңиз';

  @override
  String get scanFromPhoto => 'Сүрөттөн сканерлөө';

  @override
  String get addManually => 'Кол менен кошуу';

  @override
  String get pasteText => 'Текст чаптоо';

  @override
  String get manualInputHint => 'Бир же бирнече сөз киргизиңиз\n(ар бири жаңы сапта)';

  @override
  String get check => 'Текшерүү';

  @override
  String get detectedWords => 'Табылган сөздөр';

  @override
  String get scanText => 'Сканерлөө';

  @override
  String get scan => 'Текстти сканерлеңиз';

  @override
  String get scanError => 'Сканерлөө катасы';

  @override
  String reviewWordsTitle(int count) {
    return 'Сөздөрдү текшериңиз ($count)';
  }

  @override
  String addWordsButton(int count) {
    return '$count сөз кошуу';
  }

  @override
  String get addWords => 'Сөздөр кошуу';

  @override
  String get settings => 'Жөндөөлөр';

  @override
  String get language => 'Тил';

  @override
  String get change_password => 'Сырсөздү өзгөртүү';

  @override
  String get logout => 'Чыгуу';

  @override
  String get selectLanguage => 'Тил тандаңыз';

  @override
  String get langRussian => 'Орусча';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get langKyrgyz => 'Кыргызча';

  @override
  String get welcomeTitle => 'Кош келиңиздер 👋';

  @override
  String get sectionNews => 'Жаңылыктар жана Жарыялар';

  @override
  String get welcomeSubtitle => 'Tteomer\'ге';

  @override
  String get sectionContacts => 'Байланыштар';

  @override
  String get dailyPracticeTitle => 'Бүгүнкү машыгуу';

  @override
  String get wordOfTheDay => 'Күндүн сөзү';

  @override
  String get sentenceOfTheDay => 'Күндүн сүйлөмү';

  @override
  String get sentencePracticeHint => 'Сүйлөмдү үн чыгарып кайталап, өзүңүздүн диалогуңузда колдонуп көрүңүз.';

  @override
  String get dailyPracticePreparing => 'Бүгүнкү материал даярдалып жатат';

  @override
  String get dailyPracticePreparingSubtitle => 'Деңгээлиңизге жараша сөз жана сүйлөм тандап жатабыз.';

  @override
  String get dailyPracticeUnavailable => 'Бүгүнкү машыгуу убактылуу жеткиликсиз';

  @override
  String get dailyPracticeUnavailableSubtitle => 'Бир аздан кийин бул экранды кайра ачып көрүңүз.';

  @override
  String levelBadge(Object level) {
    return '$level деңгээли';
  }

  @override
  String get forceUpdateTitle => 'Колдонмону жаңыртуу керек';

  @override
  String get optionalUpdateTitle => 'Жаңы жаңыртуу жеткиликтүү';

  @override
  String updateMessage(Object currentVersion, Object latestVersion) {
    return 'Учурдагы версия: $currentVersion. $latestVersion версиясы жеткиликтүү. Улантуу үчүн колдонмону жаңыртыңыз.';
  }

  @override
  String get updateNow => 'Азыр жаңыртуу';

  @override
  String get later => 'Кийинчерээк';

  @override
  String get registerButton => 'Курска катталуу';

  @override
  String get contactSite => 'Сайт';

  @override
  String get contactInstagram => 'Instagram';

  @override
  String get contactFacebook => 'Facebook';

  @override
  String get contactYoutube => 'YouTube';

  @override
  String get save => 'Cактоо';

  @override
  String get translator_title => 'Котормочу';

  @override
  String get instant_translation => 'Ыкчам котормо';

  @override
  String get ai_translator => 'AI котормочу';

  @override
  String get enter_text_hint => 'Которуу үчүн текстти жазыңыз...';

  @override
  String symbols_count(Object count) {
    return '$count белги';
  }

  @override
  String get clear => 'Тазалоо';

  @override
  String get translation_error => 'Которуу катасы. API-ачкычты же байланышты текшериңиз.';

  @override
  String get copy => 'Көчүрүү';

  @override
  String get copied => 'Алмашуу буферине көчүрүлдү';

  @override
  String added_to_dictionary(Object word) {
    return '«$word» сөздүккө кошулду';
  }

  @override
  String add_to_dictionary(Object word) {
    return '«$word» сөздүккө кошуу';
  }

  @override
  String added(Object word) {
    return '«$word» кошулду!';
  }

  @override
  String get deleteWord => 'Сөздү өчүрүү?';

  @override
  String deleteWordContent(String word) {
    return '«$word» сөздүгүңүздөн өчүрүлөт.';
  }

  @override
  String get cancel => 'Жок';

  @override
  String get delete => 'Өчүрүү';

  @override
  String get deleteSwipeLabel => 'Өчүрүү';

  @override
  String get dictionaryEmpty => 'Сөздүк бош';

  @override
  String get dictionaryEmptySubtitle => 'Котормочу аркылуу сөз кошуңуз';

  @override
  String get categoryAll => 'Баары';

  @override
  String get clearDictionary => 'Сөздүктү тазалоо?';

  @override
  String get clearDictionaryContent => 'Бардык сөздөр биротола өчүрүлөт.';

  @override
  String get clearDictionaryConfirm => 'Баарын өчүрүү';

  @override
  String get clearDictionaryTooltip => 'Сөздүктү тазалоо';

  @override
  String get passwordResetSuccess => 'Сырсөз калыбына келтирилди';

  @override
  String get passwordChangeSuccess => 'Сырсөз ийгиликтүү өзгөртүлдү';

  @override
  String get rememberMe => 'Мени эстеп кал';

  @override
  String codeSentToEmail(Object email) {
    return 'Код $email дарегине жөнөтүлдү';
  }
}
