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
  String get tabGroups => 'Группы';

  @override
  String get tabDocs => 'Документы';

  @override
  String get tabTranslator => 'Переводчик';

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

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get change_password => 'Изменить пароль';

  @override
  String get logout => 'Выйти';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get langRussian => 'Русский';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get langKyrgyz => 'Кыргызча';

  @override
  String get welcomeTitle => 'Добро пожаловать 👋';

  @override
  String get sectionNews => 'Новости и объявления';

  @override
  String get welcomeSubtitle => 'в Tteomer';

  @override
  String get sectionContacts => 'Контакты';

  @override
  String get dailyPracticeTitle => 'Практика на сегодня';

  @override
  String get wordOfTheDay => 'Слово дня';

  @override
  String get sentenceOfTheDay => 'Предложение дня';

  @override
  String get sentencePracticeHint => 'Повтори фразу вслух и попробуй использовать её в своём диалоге.';

  @override
  String get dailyPracticePreparing => 'Подбираем материал дня';

  @override
  String get dailyPracticePreparingSubtitle => 'Сейчас подготовим слово и предложение под ваш уровень.';

  @override
  String get dailyPracticeUnavailable => 'Сегодняшняя практика временно недоступна';

  @override
  String get dailyPracticeUnavailableSubtitle => 'Попробуйте открыть экран ещё раз чуть позже.';

  @override
  String levelBadge(Object level) {
    return 'Уровень $level';
  }

  @override
  String get forceUpdateTitle => 'Нужно обновить приложение';

  @override
  String get optionalUpdateTitle => 'Доступно обновление';

  @override
  String updateMessage(Object currentVersion, Object latestVersion) {
    return 'Чтобы продолжить работу, установите обновление.';
  }

  @override
  String get updateNow => 'Обновить сейчас';

  @override
  String get later => 'Позже';

  @override
  String get registerButton => 'Зарегистрироваться на курс';

  @override
  String get contactSite => 'Сайт';

  @override
  String get contactInstagram => 'Instagram';

  @override
  String get contactFacebook => 'Facebook';

  @override
  String get contactYoutube => 'YouTube';

  @override
  String get save => 'Сохранить';

  @override
  String get translator_title => 'Переводчик';

  @override
  String get instant_translation => 'Мгновенный перевод';

  @override
  String get ai_translator => 'AI Переводчик';

  @override
  String get enter_text_hint => 'Введите текст для перевода...';

  @override
  String symbols_count(Object count) {
    return '$count символов';
  }

  @override
  String get clear => 'Очистить';

  @override
  String get translation_error => 'Ошибка перевода. Проверьте API-ключ или подключение.';

  @override
  String get copy => 'Копировать';

  @override
  String get copied => 'Скопировано в буфер обмена';

  @override
  String added_to_dictionary(Object word) {
    return '«$word» добавлено в словарь';
  }

  @override
  String add_to_dictionary(Object word) {
    return 'Добавить «$word» в словарь';
  }

  @override
  String added(Object word) {
    return '«$word» добавлено!';
  }

  @override
  String get deleteWord => 'Удалить слово?';

  @override
  String deleteWordContent(String word) {
    return '«$word» будет удалено из вашего словаря.';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteSwipeLabel => 'Удалить';

  @override
  String get dictionaryEmpty => 'Словарь пуст';

  @override
  String get dictionaryEmptySubtitle => 'Добавьте слова через переводчик';

  @override
  String get categoryAll => 'Все';

  @override
  String get clearDictionary => 'Очистить словарь?';

  @override
  String get clearDictionaryContent => 'Все слова будут удалены безвозвратно.';

  @override
  String get clearDictionaryConfirm => 'Удалить всё';

  @override
  String get clearDictionaryTooltip => 'Очистить словарь';

  @override
  String get passwordResetSuccess => 'Пароль был сброшен';

  @override
  String get passwordChangeSuccess => 'Пароль успешно изменен';

  @override
  String get rememberMe => 'Запомнить меня';

  @override
  String get loadingLabel => 'Загрузка...';

  @override
  String get checkAgain => 'Проверить снова';

  @override
  String get pendingApprovalTitle => 'Ожидайте подтверждения';

  @override
  String get pendingApprovalSubtitle => 'Ваша заявка успешно отправлена. Как только преподаватель подтвердит доступ к группе, материалы для обучения появятся здесь.';

  @override
  String get rejectedAccessTitle => 'Доступ пока не одобрен';

  @override
  String get rejectedAccessSubtitle => 'Преподаватель отклонил эту заявку. Свяжитесь со школой или попробуйте позже с другой активной группой.';

  @override
  String get noGroupTitle => 'Группа пока не подключена';

  @override
  String get noGroupSubtitle => 'У вашего аккаунта пока нет активной группы. Обратитесь к администратору школы, чтобы получить новый код подключения.';

  @override
  String get cohortEndedTitle => 'Этот курс завершен';

  @override
  String get cohortEndedSubtitle => 'Ваша предыдущая группа больше не активна. Свяжитесь со школой, чтобы записаться на новый курс.';

  @override
  String get noActiveCohortTitle => 'Группа сейчас недоступна';

  @override
  String get noActiveCohortSubtitle => 'Группа найдена, но активный поток сейчас недоступен. Попробуйте проверить статус позже.';

  @override
  String get accessStatusErrorTitle => 'Не удалось проверить доступ';

  @override
  String get accessStatusErrorSubtitle => 'Сейчас не получилось проверить ваш статус обучения. Попробуйте еще раз через минуту.';

  @override
  String get groupInfoTitle => 'Информация о группе';

  @override
  String get groupNameLabel => 'Группа';

  @override
  String get groupLevelLabel => 'Уровень';

  @override
  String get groupTeacherLabel => 'Преподаватель';

  @override
  String get groupLessonTimeLabel => 'Время';

  @override
  String get groupNoteLabel => 'Примечание';

  @override
  String get groupTimeUnknown => 'Время не указано';

  @override
  String groupStudentsCount(int current, int max) {
    return '$current/$max студентов';
  }

  @override
  String get openPendingStudents => 'Открыть';

  @override
  String get noTeacherGroupsTitle => 'Пока нет назначенных групп';

  @override
  String get noTeacherGroupsSubtitle => 'Группы преподавателя появятся здесь, как только их назначат в системе.';

  @override
  String get teacherGroupsErrorTitle => 'Не удалось загрузить группы';

  @override
  String get pendingStudentsTitle => 'Студенты на подтверждение';

  @override
  String get groupStudentsSectionTitle => 'Студенты в группе';

  @override
  String get noPendingStudentsTitle => 'Нет ожидающих заявок';

  @override
  String get noPendingStudentsSubtitle => 'Новые заявки студентов для этой группы появятся здесь.';

  @override
  String get noGroupStudentsTitle => 'В группе пока нет студентов';

  @override
  String get noGroupStudentsSubtitle => 'Подтвержденные студенты этой группы будут отображаться здесь.';

  @override
  String get requestedAtLabel => 'Отправлено';

  @override
  String get approveStudent => 'Подтвердить';

  @override
  String get rejectStudent => 'Отклонить';

  @override
  String get studentApproved => 'Студент подтвержден';

  @override
  String get studentRejected => 'Заявка отклонена';

  @override
  String codeSentToEmail(Object email) {
    return 'Код был отправлен на почту $email';
  }
}
