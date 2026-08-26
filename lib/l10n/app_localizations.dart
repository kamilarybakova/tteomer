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
  /// **'Create account'**
  String get register;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signUpTitle;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @enterNickname.
  ///
  /// In en, this message translates to:
  /// **'Enter nickname'**
  String get enterNickname;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the terms of use\nand the privacy policy.'**
  String get acceptTerms;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get noAccount;

  /// No description provided for @enterGroupCode.
  ///
  /// In en, this message translates to:
  /// **'Enter group code'**
  String get enterGroupCode;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code again'**
  String get resendCode;

  /// No description provided for @resendWithTimer.
  ///
  /// In en, this message translates to:
  /// **'Send code again {time}'**
  String resendWithTimer(Object time);

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Please enter the email address associated with your account.'**
  String get forgotPasswordDesc;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remembered your password?'**
  String get rememberPassword;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'We sent a code to {email}'**
  String verifyEmailDesc(Object email);

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordTitle;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password'**
  String get enterNewPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @repeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat new password'**
  String get repeatPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @emptyDictionaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Dictionary is empty'**
  String get emptyDictionaryTitle;

  /// No description provided for @emptyDictionarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first words to start learning'**
  String get emptyDictionarySubtitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search words'**
  String get searchHint;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabDictionary.
  ///
  /// In en, this message translates to:
  /// **'Dictionary'**
  String get tabDictionary;

  /// No description provided for @tabGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get tabGroups;

  /// No description provided for @tabDocs.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get tabDocs;

  /// No description provided for @tabTranslator.
  ///
  /// In en, this message translates to:
  /// **'Translator'**
  String get tabTranslator;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enterName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enterLastName;

  /// No description provided for @scanFromPhoto.
  ///
  /// In en, this message translates to:
  /// **'Scan from photo'**
  String get scanFromPhoto;

  /// No description provided for @addManually.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get addManually;

  /// No description provided for @pasteText.
  ///
  /// In en, this message translates to:
  /// **'Paste text'**
  String get pasteText;

  /// No description provided for @manualInputHint.
  ///
  /// In en, this message translates to:
  /// **'Enter one or more words\n(each on a new line)'**
  String get manualInputHint;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @detectedWords.
  ///
  /// In en, this message translates to:
  /// **'Detected words'**
  String get detectedWords;

  /// No description provided for @scanText.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanText;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan the text'**
  String get scan;

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Scanning error'**
  String get scanError;

  /// No description provided for @reviewWordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Review words ({count})'**
  String reviewWordsTitle(int count);

  /// No description provided for @addWordsButton.
  ///
  /// In en, this message translates to:
  /// **'Add {count} words'**
  String addWordsButton(int count);

  /// No description provided for @addWords.
  ///
  /// In en, this message translates to:
  /// **'Add words'**
  String get addWords;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_password;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @langRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get langRussian;

  /// No description provided for @langTurkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get langTurkish;

  /// No description provided for @langKyrgyz.
  ///
  /// In en, this message translates to:
  /// **'Kyrgyz'**
  String get langKyrgyz;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome 👋'**
  String get welcomeTitle;

  /// No description provided for @sectionNews.
  ///
  /// In en, this message translates to:
  /// **'News and announcements'**
  String get sectionNews;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'to Tteomer'**
  String get welcomeSubtitle;

  /// No description provided for @sectionContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get sectionContacts;

  /// No description provided for @dailyPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily practice'**
  String get dailyPracticeTitle;

  /// No description provided for @wordOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Word of the day'**
  String get wordOfTheDay;

  /// No description provided for @sentenceOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Sentence of the day'**
  String get sentenceOfTheDay;

  /// No description provided for @sentencePracticeHint.
  ///
  /// In en, this message translates to:
  /// **'Say the phrase aloud and try using it in your own dialogue.'**
  String get sentencePracticeHint;

  /// No description provided for @dailyPracticePreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing today’s practice'**
  String get dailyPracticePreparing;

  /// No description provided for @dailyPracticePreparingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We’re selecting a word and sentence for your level.'**
  String get dailyPracticePreparingSubtitle;

  /// No description provided for @dailyPracticeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Today’s practice is temporarily unavailable'**
  String get dailyPracticeUnavailable;

  /// No description provided for @dailyPracticeUnavailableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please try opening this screen again a bit later.'**
  String get dailyPracticeUnavailableSubtitle;

  /// No description provided for @levelBadge.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelBadge(Object level);

  /// No description provided for @forceUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'App update required'**
  String get forceUpdateTitle;

  /// No description provided for @optionalUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get optionalUpdateTitle;

  /// No description provided for @updateMessage.
  ///
  /// In en, this message translates to:
  /// **'Current version: {currentVersion}. Version {latestVersion} is available. Install the update to continue with the latest build.'**
  String updateMessage(Object currentVersion, Object latestVersion);

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get updateNow;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register for the course'**
  String get registerButton;

  /// No description provided for @contactSite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get contactSite;

  /// No description provided for @contactInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get contactInstagram;

  /// No description provided for @contactFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get contactFacebook;

  /// No description provided for @contactYoutube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get contactYoutube;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @translator_title.
  ///
  /// In en, this message translates to:
  /// **'Translator'**
  String get translator_title;

  /// No description provided for @instant_translation.
  ///
  /// In en, this message translates to:
  /// **'Instant translation'**
  String get instant_translation;

  /// No description provided for @ai_translator.
  ///
  /// In en, this message translates to:
  /// **'AI Translator'**
  String get ai_translator;

  /// No description provided for @enter_text_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter text to translate...'**
  String get enter_text_hint;

  /// No description provided for @symbols_count.
  ///
  /// In en, this message translates to:
  /// **'{count} characters'**
  String symbols_count(Object count);

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @translation_error.
  ///
  /// In en, this message translates to:
  /// **'Translation error. Check the API key or connection.'**
  String get translation_error;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copied;

  /// No description provided for @added_to_dictionary.
  ///
  /// In en, this message translates to:
  /// **'\"{word}\" added to dictionary'**
  String added_to_dictionary(Object word);

  /// No description provided for @add_to_dictionary.
  ///
  /// In en, this message translates to:
  /// **'Add \"{word}\" to dictionary'**
  String add_to_dictionary(Object word);

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'\"{word}\" added!'**
  String added(Object word);

  /// No description provided for @deleteWord.
  ///
  /// In en, this message translates to:
  /// **'Delete word?'**
  String get deleteWord;

  /// No description provided for @deleteWordContent.
  ///
  /// In en, this message translates to:
  /// **'\"{word}\" will be removed from your dictionary.'**
  String deleteWordContent(String word);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteSwipeLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteSwipeLabel;

  /// No description provided for @dictionaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Dictionary is empty'**
  String get dictionaryEmpty;

  /// No description provided for @dictionaryEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add words through the translator'**
  String get dictionaryEmptySubtitle;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @clearDictionary.
  ///
  /// In en, this message translates to:
  /// **'Clear dictionary?'**
  String get clearDictionary;

  /// No description provided for @clearDictionaryContent.
  ///
  /// In en, this message translates to:
  /// **'All words will be permanently deleted.'**
  String get clearDictionaryContent;

  /// No description provided for @clearDictionaryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get clearDictionaryConfirm;

  /// No description provided for @clearDictionaryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear dictionary'**
  String get clearDictionaryTooltip;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password has been reset'**
  String get passwordResetSuccess;

  /// No description provided for @passwordChangeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangeSuccess;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @loadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingLabel;

  /// No description provided for @checkAgain.
  ///
  /// In en, this message translates to:
  /// **'Check again'**
  String get checkAgain;

  /// No description provided for @pendingApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Please wait for approval'**
  String get pendingApprovalTitle;

  /// No description provided for @pendingApprovalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your request has been sent successfully. As soon as the teacher confirms your group access, learning materials will appear here.'**
  String get pendingApprovalSubtitle;

  /// No description provided for @rejectedAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Access was not approved'**
  String get rejectedAccessTitle;

  /// No description provided for @rejectedAccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The teacher rejected this request. Please contact the school or try again later with another active group.'**
  String get rejectedAccessSubtitle;

  /// No description provided for @noGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'No group linked yet'**
  String get noGroupTitle;

  /// No description provided for @noGroupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your account does not have an active group yet. Please contact the school administrator for a new join code.'**
  String get noGroupSubtitle;

  /// No description provided for @cohortEndedTitle.
  ///
  /// In en, this message translates to:
  /// **'This course has ended'**
  String get cohortEndedTitle;

  /// No description provided for @cohortEndedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your previous group is no longer active. Contact the school to join a new course.'**
  String get cohortEndedSubtitle;

  /// No description provided for @noActiveCohortTitle.
  ///
  /// In en, this message translates to:
  /// **'Group is unavailable right now'**
  String get noActiveCohortTitle;

  /// No description provided for @noActiveCohortSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A group was found, but there is no active cohort available at the moment. Please check again later.'**
  String get noActiveCohortSubtitle;

  /// No description provided for @accessStatusErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not check access'**
  String get accessStatusErrorTitle;

  /// No description provided for @accessStatusErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t verify your current learning status. Please try again in a moment.'**
  String get accessStatusErrorSubtitle;

  /// No description provided for @groupInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Group details'**
  String get groupInfoTitle;

  /// No description provided for @groupNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get groupNameLabel;

  /// No description provided for @groupLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get groupLevelLabel;

  /// No description provided for @groupTeacherLabel.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get groupTeacherLabel;

  /// No description provided for @groupLessonTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Lesson time'**
  String get groupLessonTimeLabel;

  /// No description provided for @groupNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get groupNoteLabel;

  /// No description provided for @groupTimeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Time not set'**
  String get groupTimeUnknown;

  /// No description provided for @groupStudentsCount.
  ///
  /// In en, this message translates to:
  /// **'{current}/{max} students'**
  String groupStudentsCount(int current, int max);

  /// No description provided for @openPendingStudents.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openPendingStudents;

  /// No description provided for @noTeacherGroupsTitle.
  ///
  /// In en, this message translates to:
  /// **'No groups assigned yet'**
  String get noTeacherGroupsTitle;

  /// No description provided for @noTeacherGroupsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher groups will appear here as soon as they are assigned in the system.'**
  String get noTeacherGroupsSubtitle;

  /// No description provided for @teacherGroupsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load groups'**
  String get teacherGroupsErrorTitle;

  /// No description provided for @pendingStudentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending students'**
  String get pendingStudentsTitle;

  /// No description provided for @groupStudentsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Students in the group'**
  String get groupStudentsSectionTitle;

  /// No description provided for @noPendingStudentsTitle.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get noPendingStudentsTitle;

  /// No description provided for @noPendingStudentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New student requests for this group will appear here.'**
  String get noPendingStudentsSubtitle;

  /// No description provided for @noGroupStudentsTitle.
  ///
  /// In en, this message translates to:
  /// **'No students in the group yet'**
  String get noGroupStudentsTitle;

  /// No description provided for @noGroupStudentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Approved students for this group will appear here.'**
  String get noGroupStudentsSubtitle;

  /// No description provided for @requestedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get requestedAtLabel;

  /// No description provided for @approveStudent.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approveStudent;

  /// No description provided for @rejectStudent.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get rejectStudent;

  /// No description provided for @studentApproved.
  ///
  /// In en, this message translates to:
  /// **'Student approved'**
  String get studentApproved;

  /// No description provided for @studentRejected.
  ///
  /// In en, this message translates to:
  /// **'Student rejected'**
  String get studentRejected;

  /// No description provided for @codeSentToEmail.
  ///
  /// In en, this message translates to:
  /// **'Code was sent to {email}'**
  String codeSentToEmail(Object email);
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
