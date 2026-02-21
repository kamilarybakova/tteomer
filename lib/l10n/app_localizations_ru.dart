// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Bişkek Türkiye Türkçesi Öğretim Merkezi';

  @override
  String get register => 'Создать аккаунт';

  @override
  String get signUpTitle => 'Создать аккаунт';

  @override
  String get nickname => 'Ник';

  @override
  String get enterNickname => 'Введите ник';

  @override
  String get email => 'Почта';

  @override
  String get enterEmail => 'Введите почту';

  @override
  String get password => 'Пароль';

  @override
  String get acceptTerms => 'Я принимаю условия использования\nи политику конфиденциальности.';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get login => 'Войти';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get noAccount => 'Нет аккаунта?';

  @override
  String get enterGroupCode => 'Введите код группы';

  @override
  String get send => 'Отправить';

  @override
  String get resendCode => 'Отправить код снова';

  @override
  String resendWithTimer(Object time) {
    return 'Отправить код снова $time';
  }

  @override
  String get forgotPasswordTitle => 'Забыли пароль?';

  @override
  String get forgotPasswordDesc => 'Пожалуйста, введите адрес электронной почты, связанный с вашей учетной записью.';

  @override
  String get sendCode => 'Отправить код';

  @override
  String get rememberPassword => 'Вспомнили пароль?';

  @override
  String get verifyEmailTitle => 'Проверьте вашу почту';

  @override
  String verifyEmailDesc(Object email) {
    return 'Мы отправили код на почту $email';
  }

  @override
  String get resetPasswordTitle => 'Сбросить пароль';

  @override
  String get enterNewPassword => 'Введите новый пароль';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get repeatPassword => 'Повторите ввод нового пароля';

  @override
  String get resetPassword => 'Сбросить пароль';

  @override
  String get emptyDictionaryTitle => 'Словарь пуст';

  @override
  String get emptyDictionarySubtitle => 'Добавьте первые слова, чтобы начать обучение';

  @override
  String get searchHint => 'Поиск слов';

  @override
  String get tabHome => 'Главная';

  @override
  String get tabDictionary => 'Словарь';

  @override
  String get tabDocs => 'Документы';

  @override
  String get firstName => 'Имя';

  @override
  String get lastName => 'Фамилия';

  @override
  String get enterName => 'Введите ваше имя';

  @override
  String get enterLastName => 'Введите вашу фамилию';

  @override
  String get scanFromPhoto => 'Сканировать с фото';

  @override
  String get addManually => 'Добавить вручную';

  @override
  String get pasteText => 'Вставить текст';

  @override
  String get manualInputHint => 'Введите одно или несколько слов\n(каждое с новой строки)';

  @override
  String get check => 'Проверить';

  @override
  String get detectedWords => 'Найденные слова';

  @override
  String get scanText => 'Сканировать';

  @override
  String get scan => 'Отсканируйте текст';

  @override
  String get scanError => 'Ошибка сканирования';

  @override
  String reviewWordsTitle(int count) {
    return 'Проверьте слова ($count)';
  }

  @override
  String addWordsButton(int count) {
    return 'Добавить $count слов';
  }

  @override
  String get addWords => 'Добавить слова';
}
