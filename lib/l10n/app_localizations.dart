import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ky'),
    Locale('ru'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Bişkek Türkiye Türkçesi Öğretim Merkezi'**
  String get appTitle;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Создать аккаунт'**
  String get register;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Создать аккаунт'**
  String get signUpTitle;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Ник'**
  String get nickname;

  /// No description provided for @enterNickname.
  ///
  /// In en, this message translates to:
  /// **'Введите ник'**
  String get enterNickname;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Почта'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Введите почту'**
  String get enterEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Пароль'**
  String get password;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'Я принимаю условия использования\nи политику конфиденциальности.'**
  String get acceptTerms;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Уже есть аккаунт?'**
  String get alreadyHaveAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Войти'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Создать аккаунт'**
  String get createAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Забыли пароль?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Нет аккаунта?'**
  String get noAccount;

  /// No description provided for @enterGroupCode.
  ///
  /// In en, this message translates to:
  /// **'Введите код группы'**
  String get enterGroupCode;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Отправить'**
  String get send;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Отправить код снова'**
  String get resendCode;

  /// No description provided for @resendWithTimer.
  ///
  /// In en, this message translates to:
  /// **'Отправить код снова {time}'**
  String resendWithTimer(Object time);

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Забыли пароль?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Пожалуйста, введите адрес электронной почты, связанный с вашей учетной записью.'**
  String get forgotPasswordDesc;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Отправить код'**
  String get sendCode;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Вспомнили пароль?'**
  String get rememberPassword;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Проверьте вашу почту'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'Мы отправили код на почту {email}'**
  String verifyEmailDesc(Object email);

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Сбросить пароль'**
  String get resetPasswordTitle;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Введите новый пароль'**
  String get enterNewPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'Новый пароль'**
  String get newPassword;

  /// No description provided for @repeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Повторите ввод нового пароля'**
  String get repeatPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Сбросить пароль'**
  String get resetPassword;

  /// No description provided for @emptyDictionaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Словарь пуст'**
  String get emptyDictionaryTitle;

  /// No description provided for @emptyDictionarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Добавьте первые слова, чтобы начать обучение'**
  String get emptyDictionarySubtitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Поиск слов'**
  String get searchHint;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Главная'**
  String get tabHome;

  /// No description provided for @tabDictionary.
  ///
  /// In en, this message translates to:
  /// **'Словарь'**
  String get tabDictionary;

  /// No description provided for @tabDocs.
  ///
  /// In en, this message translates to:
  /// **'Документы'**
  String get tabDocs;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'Имя'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Фамилия'**
  String get lastName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Введите ваше имя'**
  String get enterName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Введите вашу фамилию'**
  String get enterLastName;

  /// No description provided for @scanFromPhoto.
  ///
  /// In en, this message translates to:
  /// **'Сканировать с фото'**
  String get scanFromPhoto;

  /// No description provided for @addManually.
  ///
  /// In en, this message translates to:
  /// **'Добавить вручную'**
  String get addManually;

  /// No description provided for @pasteText.
  ///
  /// In en, this message translates to:
  /// **'Вставить текст'**
  String get pasteText;

  /// No description provided for @manualInputHint.
  ///
  /// In en, this message translates to:
  /// **'Введите одно или несколько слов\n(каждое с новой строки)'**
  String get manualInputHint;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Проверить'**
  String get check;

  /// No description provided for @detectedWords.
  ///
  /// In en, this message translates to:
  /// **'Найденные слова'**
  String get detectedWords;

  /// No description provided for @scanText.
  ///
  /// In en, this message translates to:
  /// **'Сканировать'**
  String get scanText;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Отсканируйте текст'**
  String get scan;

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Ошибка сканирования'**
  String get scanError;

  /// No description provided for @reviewWordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Проверьте слова ({count})'**
  String reviewWordsTitle(int count);

  /// No description provided for @addWordsButton.
  ///
  /// In en, this message translates to:
  /// **'Добавить {count} слов'**
  String addWordsButton(int count);

  /// No description provided for @addWords.
  ///
  /// In en, this message translates to:
  /// **'Добавить слова'**
  String get addWords;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ky', 'ru', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ky': return AppLocalizationsKy();
    case 'ru': return AppLocalizationsRu();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
