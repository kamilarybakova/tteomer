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
  String get tabGroups => 'Groups';

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
  String get studentHomeworkBannerTitle => 'Homework';

  @override
  String studentHomeworkDueDate(Object date) {
    return 'Due $date';
  }

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
  String get loadingLabel => 'Loading...';

  @override
  String get checkAgain => 'Check again';

  @override
  String get pendingApprovalTitle => 'Please wait for approval';

  @override
  String get pendingApprovalSubtitle => 'Your request has been sent successfully. As soon as the teacher confirms your group access, learning materials will appear here.';

  @override
  String get rejectedAccessTitle => 'Access was not approved';

  @override
  String get rejectedAccessSubtitle => 'The teacher rejected this request. Please contact the school or try again later with another active group.';

  @override
  String get noGroupTitle => 'No group linked yet';

  @override
  String get noGroupSubtitle => 'Your account does not have an active group yet. Please contact the school administrator for a new join code.';

  @override
  String get cohortEndedTitle => 'This course has ended';

  @override
  String get cohortEndedSubtitle => 'Your previous group is no longer active. Contact the school to join a new course.';

  @override
  String get noActiveCohortTitle => 'Group is unavailable right now';

  @override
  String get noActiveCohortSubtitle => 'A group was found, but there is no active cohort available at the moment. Please check again later.';

  @override
  String get accessStatusErrorTitle => 'Could not check access';

  @override
  String get accessStatusErrorSubtitle => 'We couldn\'t verify your current learning status. Please try again in a moment.';

  @override
  String get groupInfoTitle => 'Group details';

  @override
  String get groupNameLabel => 'Group';

  @override
  String get groupLevelLabel => 'Level';

  @override
  String get groupTeacherLabel => 'Teacher';

  @override
  String get groupLessonTimeLabel => 'Lesson time';

  @override
  String get groupNoteLabel => 'Note';

  @override
  String get groupTimeUnknown => 'Time not set';

  @override
  String groupStudentsCount(int current, int max) {
    return '$current/$max students';
  }

  @override
  String get openPendingStudents => 'Open';

  @override
  String get noTeacherGroupsTitle => 'No groups assigned yet';

  @override
  String get noTeacherGroupsSubtitle => 'Teacher groups will appear here as soon as they are assigned in the system.';

  @override
  String get teacherGroupsErrorTitle => 'Could not load groups';

  @override
  String get teacherDocumentsErrorTitle => 'Could not load materials';

  @override
  String get noTeacherDocumentsTitle => 'No materials yet';

  @override
  String get noTeacherDocumentsSubtitle => 'Upload the first document for your group and it will appear here.';

  @override
  String get teacherFoldersTitle => 'Folders';

  @override
  String get addedMaterialsTitle => 'Added materials';

  @override
  String get addMaterialButton => 'Add material';

  @override
  String get editMaterialButton => 'Edit material';

  @override
  String get uploadMaterialButton => 'Upload material';

  @override
  String get materialUploadedSuccess => 'Material uploaded';

  @override
  String get materialUpdatedSuccess => 'Material updated successfully';

  @override
  String get materialDeletedSuccess => 'Material deleted successfully';

  @override
  String get materialTitleLabel => 'Title';

  @override
  String get materialTitleValidation => 'Enter a title';

  @override
  String get materialDescriptionLabel => 'Description';

  @override
  String get materialFileLabel => 'File';

  @override
  String get currentFileLabel => 'Current file';

  @override
  String get selectFileButton => 'Select file';

  @override
  String get replaceFileButton => 'Replace file';

  @override
  String get selectFileValidation => 'Select a file';

  @override
  String get selectGroupLabel => 'Group';

  @override
  String get selectGroupValidation => 'Select a group';

  @override
  String get visibleToStudentsLabel => 'Visible to students';

  @override
  String get hiddenFromStudentsLabel => 'Hidden';

  @override
  String get visibleToStudentsHint => 'Students in the selected group will be able to see this document.';

  @override
  String get pendingStudentsTitle => 'Pending students';

  @override
  String get groupStudentsSectionTitle => 'Students in the group';

  @override
  String get groupHomeworkTitle => 'Homework';

  @override
  String get groupMaterialsTitle => 'Materials';

  @override
  String get addHomeworkButton => 'Add homework';

  @override
  String get createHomeworkButton => 'Assign homework';

  @override
  String get homeworkCreatedSuccess => 'Homework assigned successfully';

  @override
  String get editHomeworkButton => 'Edit homework';

  @override
  String get homeworkUpdatedSuccess => 'Homework updated successfully';

  @override
  String get homeworkDeletedSuccess => 'Homework deleted successfully';

  @override
  String get homeworkDueDateLabel => 'Due date';

  @override
  String get homeworkFileOptionalHint => 'Optional file';

  @override
  String get homeworkTargetGroupOption => 'Whole group';

  @override
  String get homeworkTargetIndividualOption => 'Individual students';

  @override
  String get homeworkAssignedStudentsLabel => 'Students';

  @override
  String get homeworkAssignedStudentsHint => 'Select the students who should receive this homework.';

  @override
  String get homeworkStudentsValidation => 'Select at least one student';

  @override
  String get homeworkActiveLabel => 'Active homework';

  @override
  String get homeworkActiveHint => 'Only active homework is visible to students.';

  @override
  String get homeworkForGroupLabel => 'For the whole group';

  @override
  String homeworkForStudentsLabel(int count) {
    return 'For $count students';
  }

  @override
  String get noGroupHomeworkTitle => 'No homework in this group yet';

  @override
  String get noGroupHomeworkSubtitle => 'Assign the first homework and it will appear here.';

  @override
  String get deleteHomeworkTitle => 'Delete homework?';

  @override
  String get deleteHomeworkMessage => 'This homework will be permanently removed.';

  @override
  String get noPendingStudentsTitle => 'No pending requests';

  @override
  String get noPendingStudentsSubtitle => 'New student requests for this group will appear here.';

  @override
  String get noGroupStudentsTitle => 'No students in the group yet';

  @override
  String get noGroupStudentsSubtitle => 'Approved students for this group will appear here.';

  @override
  String get noGroupMaterialsTitle => 'No materials in this group yet';

  @override
  String get noGroupMaterialsSubtitle => 'Upload the first material for this group and it will appear here.';

  @override
  String get deleteMaterialTitle => 'Delete material?';

  @override
  String get deleteMaterialMessage => 'This material will be permanently removed.';

  @override
  String get requestedAtLabel => 'Requested';

  @override
  String get approveStudent => 'Approve';

  @override
  String get rejectStudent => 'Reject';

  @override
  String get studentApproved => 'Student approved';

  @override
  String get studentRejected => 'Student rejected';

  @override
  String codeSentToEmail(Object email) {
    return 'Code was sent to $email';
  }
}
