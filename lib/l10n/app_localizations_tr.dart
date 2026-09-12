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
  String get tabGroups => 'Gruplar';

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
  String get studentHomeworkBannerTitle => 'Ödev';

  @override
  String studentHomeworkDueDate(Object date) {
    return 'Teslim $date';
  }

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
  String get sharedDictionaryTitle => 'Kurs sözlüğü';

  @override
  String get sharedDictionaryHomeSubtitle => 'Seviyeniz için resmi kelimeler';

  @override
  String get sharedDictionaryEmpty => 'Kelime bulunamadı';

  @override
  String get sharedDictionaryEmptySubtitle => 'Aramayı veya filtreleri değiştirmeyi deneyin.';

  @override
  String get sharedDictionaryError => 'Sözlük yüklenemedi';

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
  String get loadingLabel => 'Yükleniyor...';

  @override
  String get checkAgain => 'Tekrar kontrol et';

  @override
  String get pendingApprovalTitle => 'Lütfen onayı bekleyin';

  @override
  String get pendingApprovalSubtitle => 'Başvurunuz başarıyla gönderildi. Öğretmen grup erişiminizi onayladığında öğrenme materyalleri burada görünecek.';

  @override
  String get rejectedAccessTitle => 'Erişim henüz onaylanmadı';

  @override
  String get rejectedAccessSubtitle => 'Öğretmen bu başvuruyu reddetti. Lütfen okul ile iletişime geçin veya daha sonra başka bir aktif grupla tekrar deneyin.';

  @override
  String get noGroupTitle => 'Henüz bir grup bağlı değil';

  @override
  String get noGroupSubtitle => 'Hesabınızda henüz aktif bir grup yok. Yeni bir katılım kodu almak için okul yöneticisiyle iletişime geçin.';

  @override
  String get cohortEndedTitle => 'Bu kurs sona erdi';

  @override
  String get cohortEndedSubtitle => 'Önceki grubunuz artık aktif değil. Yeni bir kursa katılmak için okul ile iletişime geçin.';

  @override
  String get noActiveCohortTitle => 'Grup şu anda kullanılamıyor';

  @override
  String get noActiveCohortSubtitle => 'Bir grup bulundu ancak şu anda aktif bir dönem yok. Lütfen daha sonra tekrar kontrol edin.';

  @override
  String get accessStatusErrorTitle => 'Erişim kontrol edilemedi';

  @override
  String get accessStatusErrorSubtitle => 'Mevcut öğrenim durumunuz doğrulanamadı. Lütfen biraz sonra tekrar deneyin.';

  @override
  String get groupInfoTitle => 'Grup bilgileri';

  @override
  String get groupNameLabel => 'Grup';

  @override
  String get groupLevelLabel => 'Seviye';

  @override
  String get groupTeacherLabel => 'Öğretmen';

  @override
  String get groupLessonTimeLabel => 'Ders saati';

  @override
  String get groupNoteLabel => 'Not';

  @override
  String get groupTimeUnknown => 'Saat belirtilmedi';

  @override
  String groupStudentsCount(int current, int max) {
    return '$current/$max öğrenci';
  }

  @override
  String get openPendingStudents => 'Aç';

  @override
  String get noTeacherGroupsTitle => 'Henüz atanmış grup yok';

  @override
  String get noTeacherGroupsSubtitle => 'Öğretmene ait gruplar sistemde atandığında burada görünecek.';

  @override
  String get teacherGroupsErrorTitle => 'Gruplar yüklenemedi';

  @override
  String get teacherDocumentsErrorTitle => 'Materyaller yüklenemedi';

  @override
  String get noTeacherDocumentsTitle => 'Henüz materyal yok';

  @override
  String get noTeacherDocumentsSubtitle => 'Grubunuz için ilk belgeyi yükleyin, burada görünecektir.';

  @override
  String get teacherFoldersTitle => 'Klasörler';

  @override
  String get addedMaterialsTitle => 'Eklenen materyaller';

  @override
  String get addMaterialButton => 'Materyal ekle';

  @override
  String get editMaterialButton => 'Materyali düzenle';

  @override
  String get uploadMaterialButton => 'Materyali yükle';

  @override
  String get materialUploadedSuccess => 'Materyal yüklendi';

  @override
  String get materialUpdatedSuccess => 'Materyal başarıyla güncellendi';

  @override
  String get materialDeletedSuccess => 'Materyal başarıyla silindi';

  @override
  String get materialTitleLabel => 'Başlık';

  @override
  String get materialTitleValidation => 'Bir başlık girin';

  @override
  String get materialDescriptionLabel => 'Açıklama';

  @override
  String get materialFileLabel => 'Dosya';

  @override
  String get currentFileLabel => 'Mevcut dosya';

  @override
  String get selectFileButton => 'Dosya seç';

  @override
  String get replaceFileButton => 'Dosyayı değiştir';

  @override
  String get selectFileValidation => 'Bir dosya seçin';

  @override
  String get selectGroupLabel => 'Grup';

  @override
  String get selectGroupValidation => 'Bir grup seçin';

  @override
  String get visibleToStudentsLabel => 'Öğrencilere görünür';

  @override
  String get hiddenFromStudentsLabel => 'Gizli';

  @override
  String get visibleToStudentsHint => 'Seçilen grubun öğrencileri bu belgeyi görebilir.';

  @override
  String get pendingStudentsTitle => 'Onay bekleyen öğrenciler';

  @override
  String get groupStudentsSectionTitle => 'Gruptaki öğrenciler';

  @override
  String get groupHomeworkTitle => 'Ödevler';

  @override
  String get groupMaterialsTitle => 'Materyaller';

  @override
  String get addHomeworkButton => 'Ödev ekle';

  @override
  String get createHomeworkButton => 'Ödev ata';

  @override
  String get homeworkCreatedSuccess => 'Ödev başarıyla atandı';

  @override
  String get editHomeworkButton => 'Ödevi düzenle';

  @override
  String get homeworkUpdatedSuccess => 'Ödev başarıyla güncellendi';

  @override
  String get homeworkDeletedSuccess => 'Ödev başarıyla silindi';

  @override
  String get homeworkDueDateLabel => 'Teslim tarihi';

  @override
  String get homeworkFileOptionalHint => 'Dosya isteğe bağlı';

  @override
  String get homeworkTargetGroupOption => 'Tüm gruba';

  @override
  String get homeworkTargetIndividualOption => 'Bireysel öğrencilere';

  @override
  String get homeworkAssignedStudentsLabel => 'Öğrenciler';

  @override
  String get homeworkAssignedStudentsHint => 'Bu ödevi alacak öğrencileri seçin.';

  @override
  String get homeworkStudentsValidation => 'En az bir öğrenci seçin';

  @override
  String get homeworkActiveLabel => 'Aktif ödev';

  @override
  String get homeworkActiveHint => 'Yalnızca aktif ödevler öğrencilere görünür.';

  @override
  String get homeworkForGroupLabel => 'Tüm grup için';

  @override
  String homeworkForStudentsLabel(int count) {
    return '$count öğrenci için';
  }

  @override
  String get noGroupHomeworkTitle => 'Bu grupta henüz ödev yok';

  @override
  String get noGroupHomeworkSubtitle => 'İlk ödevi atayın, burada görünecektir.';

  @override
  String get deleteHomeworkTitle => 'Ödev silinsin mi?';

  @override
  String get deleteHomeworkMessage => 'Bu ödev kalıcı olarak silinecek.';

  @override
  String get noPendingStudentsTitle => 'Bekleyen istek yok';

  @override
  String get noPendingStudentsSubtitle => 'Bu grup için yeni öğrenci istekleri burada görünecek.';

  @override
  String get noGroupStudentsTitle => 'Grupta henüz öğrenci yok';

  @override
  String get noGroupStudentsSubtitle => 'Bu grubun onaylanan öğrencileri burada görünecek.';

  @override
  String get noGroupMaterialsTitle => 'Bu grupta henüz materyal yok';

  @override
  String get noGroupMaterialsSubtitle => 'Bu grup için ilk materyali yükleyin, burada görünecektir.';

  @override
  String get deleteMaterialTitle => 'Materyal silinsin mi?';

  @override
  String get deleteMaterialMessage => 'Bu materyal kalıcı olarak silinecek.';

  @override
  String get requestedAtLabel => 'Talep zamanı';

  @override
  String get approveStudent => 'Onayla';

  @override
  String get rejectStudent => 'Reddet';

  @override
  String get studentApproved => 'Öğrenci onaylandı';

  @override
  String get studentRejected => 'Öğrenci reddedildi';

  @override
  String codeSentToEmail(Object email) {
    return 'Kod $email adresine gönderildi';
  }
}
