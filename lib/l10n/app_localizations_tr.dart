// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Bișkek Türkiye Türkçesi Öğretim Merkezi';

  @override
  String get register => 'Hesap oluştur';

  @override
  String get signUpTitle => 'Hesap oluştur';

  @override
  String get nickname => 'Takma ad';

  @override
  String get enterNickname => 'Takma ad girin';

  @override
  String get email => 'E-posta';

  @override
  String get enterEmail => 'E-posta girin';

  @override
  String get password => 'Şifre';

  @override
  String get acceptTerms => 'Kullanım şartlarını ve gizlilik politikasını kabul ediyorum.';

  @override
  String get alreadyHaveAccount => 'Zaten hesabın var mı?';

  @override
  String get login => 'Giriş yap';

  @override
  String get createAccount => 'Hesap oluştur';

  @override
  String get forgotPassword => 'Şifreni mi unuttun?';

  @override
  String get noAccount => 'Hesabın yok mu?';

  @override
  String get enterGroupCode => 'Grup kodunu girin';

  @override
  String get send => 'Gönder';

  @override
  String get resendCode => 'Kodu tekrar gönder';

  @override
  String resendWithTimer(Object time) {
    return 'Kodu tekrar gönder $time';
  }

  @override
  String get forgotPasswordTitle => 'Şifrenizi mi unuttunuz?';

  @override
  String get forgotPasswordDesc => 'Lütfen hesabınızla ilişkili e-posta adresini girin.';

  @override
  String get sendCode => 'Kodu gönder';

  @override
  String get rememberPassword => 'Şifrenizi hatırladınız mı?';

  @override
  String get verifyEmailTitle => 'E-postanızı kontrol edin';

  @override
  String verifyEmailDesc(Object email) {
    return 'Kodu şu e-postaya gönderdik: $email';
  }

  @override
  String get resetPasswordTitle => 'Şifreyi sıfırla';

  @override
  String get enterNewPassword => 'Yeni şifre girin';

  @override
  String get newPassword => 'Yeni şifre';

  @override
  String get repeatPassword => 'Yeni şifreyi tekrar girin';

  @override
  String get resetPassword => 'Şifreyi sıfırla';

  @override
  String get emptyDictionaryTitle => 'Словарь пуст';

  @override
  String get emptyDictionarySubtitle => 'Добавьте первые слова, чтобы начать обучение';

  @override
  String get searchHint => 'Поиск слов';

  @override
  String get tabHome => 'Ana sayfa';

  @override
  String get tabDictionary => 'Sözlük';

  @override
  String get tabDocs => 'Belgeler';

  @override
  String get firstName => 'Ad';

  @override
  String get lastName => 'Soyad';

  @override
  String get enterName => 'Adınızı girin';

  @override
  String get enterLastName => 'Soyadınızı girin';

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
