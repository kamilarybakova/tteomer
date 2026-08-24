// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bişkek Türkiye Türkçesi Öğretim Merkezi';

  @override
  String get register => 'Create account';

  @override
  String get signUpTitle => 'Create account';

  @override
  String get nickname => 'Nickname';

  @override
  String get enterNickname => 'Enter nickname';

  @override
  String get email => 'Email';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get password => 'Password';

  @override
  String get acceptTerms => 'I accept the terms of use\nand the privacy policy.';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get login => 'Log in';

  @override
  String get createAccount => 'Create account';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccount => 'Don’t have an account?';

  @override
  String get enterGroupCode => 'Enter group code';

  @override
  String get send => 'Send';

  @override
  String get resendCode => 'Send code again';

  @override
  String resendWithTimer(Object time) {
    return 'Send code again $time';
  }

  @override
  String get forgotPasswordTitle => 'Forgot password?';

  @override
  String get forgotPasswordDesc => 'Please enter the email address associated with your account.';

  @override
  String get sendCode => 'Send code';

  @override
  String get rememberPassword => 'Remembered your password?';

  @override
  String get verifyEmailTitle => 'Check your email';

  @override
  String verifyEmailDesc(Object email) {
    return 'We sent a code to $email';
  }

  @override
  String get resetPasswordTitle => 'Reset password';

  @override
  String get enterNewPassword => 'Enter a new password';

  @override
  String get newPassword => 'New password';

  @override
  String get repeatPassword => 'Repeat new password';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get emptyDictionaryTitle => 'Dictionary is empty';

  @override
  String get emptyDictionarySubtitle => 'Add your first words to start learning';

  @override
  String get searchHint => 'Search words';

  @override
  String get tabHome => 'Home';

  @override
  String get tabDictionary => 'Dictionary';

  @override
  String get tabDocs => 'Documents';

  @override
  String get tabTranslator => 'Translator';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get enterName => 'Enter your first name';

  @override
  String get enterLastName => 'Enter your last name';

  @override
  String get scanFromPhoto => 'Scan from photo';

  @override
  String get addManually => 'Add manually';

  @override
  String get pasteText => 'Paste text';

  @override
  String get manualInputHint => 'Enter one or more words\n(each on a new line)';

  @override
  String get check => 'Check';

  @override
  String get detectedWords => 'Detected words';

  @override
  String get scanText => 'Scan';

  @override
  String get scan => 'Scan the text';

  @override
  String get scanError => 'Scanning error';

  @override
  String reviewWordsTitle(int count) {
    return 'Review words ($count)';
  }

  @override
  String addWordsButton(int count) {
    return 'Add $count words';
  }

  @override
  String get addWords => 'Add words';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get change_password => 'Change password';

  @override
  String get logout => 'Log out';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get langRussian => 'Russian';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get langKyrgyz => 'Kyrgyz';

  @override
  String get welcomeTitle => 'Welcome 👋';

  @override
  String get sectionNews => 'News and announcements';

  @override
  String get welcomeSubtitle => 'to Tteomer';

  @override
  String get sectionContacts => 'Contacts';

  @override
  String get dailyPracticeTitle => 'Daily practice';

  @override
  String get wordOfTheDay => 'Word of the day';

  @override
  String get sentenceOfTheDay => 'Sentence of the day';

  @override
  String get sentencePracticeHint => 'Say the phrase aloud and try using it in your own dialogue.';

  @override
  String get dailyPracticePreparing => 'Preparing today’s practice';

  @override
  String get dailyPracticePreparingSubtitle => 'We’re selecting a word and sentence for your level.';

  @override
  String get dailyPracticeUnavailable => 'Today’s practice is temporarily unavailable';

  @override
  String get dailyPracticeUnavailableSubtitle => 'Please try opening this screen again a bit later.';

  @override
  String levelBadge(Object level) {
    return 'Level $level';
  }

  @override
  String get forceUpdateTitle => 'App update required';

  @override
  String get optionalUpdateTitle => 'Update available';

  @override
  String updateMessage(Object currentVersion, Object latestVersion) {
    return 'Current version: $currentVersion. Version $latestVersion is available. Install the update to continue with the latest build.';
  }

  @override
  String get updateNow => 'Update now';

  @override
  String get later => 'Later';

  @override
  String get registerButton => 'Register for the course';

  @override
  String get contactSite => 'Website';

  @override
  String get contactInstagram => 'Instagram';

  @override
  String get contactFacebook => 'Facebook';

  @override
  String get contactYoutube => 'YouTube';

  @override
  String get save => 'Save';

  @override
  String get translator_title => 'Translator';

  @override
  String get instant_translation => 'Instant translation';

  @override
  String get ai_translator => 'AI Translator';

  @override
  String get enter_text_hint => 'Enter text to translate...';

  @override
  String symbols_count(Object count) {
    return '$count characters';
  }

  @override
  String get clear => 'Clear';

  @override
  String get translation_error => 'Translation error. Check the API key or connection.';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied to clipboard';

  @override
  String added_to_dictionary(Object word) {
    return '\"$word\" added to dictionary';
  }

  @override
  String add_to_dictionary(Object word) {
    return 'Add \"$word\" to dictionary';
  }

  @override
  String added(Object word) {
    return '\"$word\" added!';
  }

  @override
  String get deleteWord => 'Delete word?';

  @override
  String deleteWordContent(String word) {
    return '\"$word\" will be removed from your dictionary.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get deleteSwipeLabel => 'Delete';

  @override
  String get dictionaryEmpty => 'Dictionary is empty';

  @override
  String get dictionaryEmptySubtitle => 'Add words through the translator';

  @override
  String get categoryAll => 'All';

  @override
  String get clearDictionary => 'Clear dictionary?';

  @override
  String get clearDictionaryContent => 'All words will be permanently deleted.';

  @override
  String get clearDictionaryConfirm => 'Delete all';

  @override
  String get clearDictionaryTooltip => 'Clear dictionary';

  @override
  String get passwordResetSuccess => 'Password has been reset';

  @override
  String get passwordChangeSuccess => 'Password changed successfully';

  @override
  String get rememberMe => 'Remember me';

  @override
  String codeSentToEmail(Object email) {
    return 'Code was sent to $email';
  }
}
