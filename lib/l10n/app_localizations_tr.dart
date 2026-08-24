// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Bişkek Türkiye Türkçesi Öğretim Merkezi';

  @override
  String get register => 'Hesap oluştur';

  @override
  String get signUpTitle => 'Hesap oluştur';

  @override
  String get nickname => 'Kullanıcı adı';

  @override
  String get enterNickname => 'Kullanıcı adı girin';

  @override
  String get email => 'E-posta';

  @override
  String get enterEmail => 'E-posta girin';

  @override
  String get password => 'Şifre';

  @override
  String get acceptTerms => 'Kullanım koşullarını\nve gizlilik politikasını kabul ediyorum.';

  @override
  String get alreadyHaveAccount => 'Zaten hesabınız var mı?';

  @override
  String get login => 'Giriş yap';

  @override
  String get createAccount => 'Hesap oluştur';

  @override
  String get forgotPassword => 'Şifremi unuttum?';

  @override
  String get noAccount => 'Hesabınız yok mu?';

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
  String get forgotPasswordTitle => 'Şifremi unuttum?';

  @override
  String get forgotPasswordDesc => 'Lütfen hesabınızla ilişkili e-posta adresini girin.';

  @override
  String get sendCode => 'Kod gönder';

  @override
  String get rememberPassword => 'Şifrenizi hatırladınız mı?';

  @override
  String get verifyEmailTitle => 'E-postanızı kontrol edin';

  @override
  String verifyEmailDesc(Object email) {
    return 'Kodu $email adresine gönderdik';
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
  String get emptyDictionaryTitle => 'Sözlük boş';

  @override
  String get emptyDictionarySubtitle => 'Öğrenmeye başlamak için ilk kelimeleri ekleyin';

  @override
  String get searchHint => 'Kelime ara';

  @override
  String get tabHome => 'Ana sayfa';

  @override
  String get tabDictionary => 'Sözlük';

  @override
  String get tabDocs => 'Belgeler';

  @override
  String get tabTranslator => 'Çevirmen';

  @override
  String get firstName => 'Ad';

  @override
  String get lastName => 'Soyad';

  @override
  String get enterName => 'Adınızı girin';

  @override
  String get enterLastName => 'Soyadınızı girin';

  @override
  String get scanFromPhoto => 'Fotoğraftan tara';

  @override
  String get addManually => 'Manuel ekle';

  @override
  String get pasteText => 'Metin yapıştır';

  @override
  String get manualInputHint => 'Bir veya birden fazla kelime girin\n(her biri yeni satırdan)';

  @override
  String get check => 'Kontrol et';

  @override
  String get detectedWords => 'Bulunan kelimeler';

  @override
  String get scanText => 'Tara';

  @override
  String get scan => 'Metni tarayın';

  @override
  String get scanError => 'Tarama hatası';

  @override
  String reviewWordsTitle(int count) {
    return 'Kelimeleri kontrol edin ($count)';
  }

  @override
  String addWordsButton(int count) {
    return '$count kelime ekle';
  }

  @override
  String get addWords => 'Kelime ekle';

  @override
  String get settings => 'Ayarlar';

  @override
  String get language => 'Dil';

  @override
  String get change_password => 'Şifreyi değiştir';

  @override
  String get logout => 'Çıkış yap';

  @override
  String get selectLanguage => 'Dil seçin';

  @override
  String get langRussian => 'Rusça';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get langKyrgyz => 'Kırgızca';

  @override
  String get welcomeTitle => 'Hoş geldiniz 👋';

  @override
  String get sectionNews => 'Haberler ve Duyurular';

  @override
  String get welcomeSubtitle => 'Tteomer\'e';

  @override
  String get sectionContacts => 'İletişim';

  @override
  String get dailyPracticeTitle => 'Bugunun calismasi';

  @override
  String get wordOfTheDay => 'Gunun kelimesi';

  @override
  String get sentenceOfTheDay => 'Gunun cumlesi';

  @override
  String get sentencePracticeHint => 'Cumleyi sesli tekrar edin ve kendi diyalogunuzda kullanmayi deneyin.';

  @override
  String get dailyPracticePreparing => 'Bugunun calismasi hazirlaniyor';

  @override
  String get dailyPracticePreparingSubtitle => 'Seviyenize uygun kelime ve cumle seciyoruz.';

  @override
  String get dailyPracticeUnavailable => 'Bugunun calismasi gecici olarak kullanilamiyor';

  @override
  String get dailyPracticeUnavailableSubtitle => 'Lutfen bu ekrani biraz sonra tekrar acin.';

  @override
  String levelBadge(Object level) {
    return 'Seviye $level';
  }

  @override
  String get forceUpdateTitle => 'Uygulamanin guncellenmesi gerekiyor';

  @override
  String get optionalUpdateTitle => 'Guncelleme mevcut';

  @override
  String updateMessage(Object currentVersion, Object latestVersion) {
    return 'Mevcut surum: $currentVersion. $latestVersion surumu kullanima hazir. Devam etmek icin uygulamayi guncelleyin.';
  }

  @override
  String get updateNow => 'Simdi guncelle';

  @override
  String get later => 'Daha sonra';

  @override
  String get registerButton => 'Kursa kayıt ol';

  @override
  String get contactSite => 'Site';

  @override
  String get contactInstagram => 'Instagram';

  @override
  String get contactFacebook => 'Facebook';

  @override
  String get contactYoutube => 'YouTube';

  @override
  String get save => 'Kaydet';

  @override
  String get translator_title => 'Çevirmen';

  @override
  String get instant_translation => 'Anında çeviri';

  @override
  String get ai_translator => 'AI Çevirmen';

  @override
  String get enter_text_hint => 'Çevirmek için metin girin...';

  @override
  String symbols_count(Object count) {
    return '$count karakter';
  }

  @override
  String get clear => 'Temizle';

  @override
  String get translation_error => 'Çeviri hatası. API anahtarını veya bağlantıyı kontrol edin.';

  @override
  String get copy => 'Kopyala';

  @override
  String get copied => 'Panoya kopyalandı';

  @override
  String added_to_dictionary(Object word) {
    return '«$word» sözlüğe eklendi';
  }

  @override
  String add_to_dictionary(Object word) {
    return '«$word» sözlüğe ekle';
  }

  @override
  String added(Object word) {
    return '«$word» eklendi!';
  }

  @override
  String get deleteWord => 'Kelimeyi sil?';

  @override
  String deleteWordContent(String word) {
    return '«$word» sözlüğünüzden silinecek.';
  }

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get deleteSwipeLabel => 'Sil';

  @override
  String get dictionaryEmpty => 'Sözlük boş';

  @override
  String get dictionaryEmptySubtitle => 'Çevirici aracılığıyla kelime ekleyin';

  @override
  String get categoryAll => 'Tümü';

  @override
  String get clearDictionary => 'Sözlüğü temizle?';

  @override
  String get clearDictionaryContent => 'Tüm kelimeler kalıcı olarak silinecek.';

  @override
  String get clearDictionaryConfirm => 'Tümünü sil';

  @override
  String get clearDictionaryTooltip => 'Sözlüğü temizle';

  @override
  String get passwordResetSuccess => 'Şifre sıfırlandı';

  @override
  String get passwordChangeSuccess => 'Şifre başarıyla değiştirildi';

  @override
  String get rememberMe => 'Beni hatırla';

  @override
  String codeSentToEmail(Object email) {
    return 'Kod $email adresine gönderildi';
  }
}
