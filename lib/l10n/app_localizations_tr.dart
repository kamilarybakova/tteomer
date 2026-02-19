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
}
