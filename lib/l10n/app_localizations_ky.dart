// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kirghiz Kyrgyz (`ky`).
class AppLocalizationsKy extends AppLocalizations {
  AppLocalizationsKy([String locale = 'ky']) : super(locale);

  @override
  String get appTitle => 'Бишкек Түркия Түрк Тили Окутуу Борбору';

  @override
  String get register => 'Аккаунт түзүү';

  @override
  String get signUpTitle => 'Аккаунт түзүү';

  @override
  String get nickname => 'Ник';

  @override
  String get enterNickname => 'Ник жазыңыз';

  @override
  String get email => 'Почта';

  @override
  String get enterEmail => 'Почтаны жазыңыз';

  @override
  String get password => 'Сыр сөз';

  @override
  String get acceptTerms => 'Колдонуу шарттарын жана купуялык саясатын кабыл алам.';

  @override
  String get alreadyHaveAccount => 'Аккаунтуңуз барбы?';

  @override
  String get login => 'Кирүү';

  @override
  String get createAccount => 'Аккаунт түзүү';

  @override
  String get forgotPassword => 'Сыр сөздү унуттуңузбу?';

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
  String get forgotPasswordDesc => 'Сураныч, аккаунтуңузга байланышкан электрондук почтаны киргизиңиз.';

  @override
  String get sendCode => 'Код жөнөтүү';

  @override
  String get rememberPassword => 'Сырсөздү эстедиңизби?';

  @override
  String get verifyEmailTitle => 'Почтаңызды текшериңиз';

  @override
  String verifyEmailDesc(Object email) {
    return 'Биз кодду бул почтага жөнөттүк: $email';
  }

  @override
  String get resetPasswordTitle => 'Сырсөздү калыбына келтирүү';

  @override
  String get enterNewPassword => 'Жаңы сырсөздү киргизиңиз';

  @override
  String get newPassword => 'Жаңы сырсөз';

  @override
  String get repeatPassword => 'Жаңы сырсөздү кайра киргизиңиз';

  @override
  String get resetPassword => 'Сырсөздү өзгөртүү';

  @override
  String get emptyDictionaryTitle => 'Словарь пуст';

  @override
  String get emptyDictionarySubtitle => 'Добавьте первые слова, чтобы начать обучение';

  @override
  String get searchHint => 'Поиск слов';

  @override
  String get tabHome => 'Башкы бет';

  @override
  String get tabDictionary => 'Сөздүк';

  @override
  String get tabDocs => 'Документтер';

  @override
  String get firstName => 'Атыңыз';

  @override
  String get lastName => 'Фамилияңыз';

  @override
  String get enterName => 'Атыңызды жазыңыз';

  @override
  String get enterLastName => 'Фамилияңызды жазыңыз';
}
