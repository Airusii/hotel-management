// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Manas Hotel';

  @override
  String get navHome => 'Главная';

  @override
  String get navServices => 'Услуги';

  @override
  String get navProfile => 'Кабинет';

  @override
  String get navLogin => 'Войти';

  @override
  String get navTasks => 'Задачи';

  @override
  String get navAdmin => 'Админка';

  @override
  String errorGeneric(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get errorLoading => 'Ошибка загрузки';

  @override
  String errorLoadingData(String error) {
    return 'Ошибка загрузки данных: $error';
  }

  @override
  String get errorAuth => 'Ошибка авторизации';

  @override
  String get errorRole => 'Ошибка роли';

  @override
  String get loading => 'Загрузка...';

  @override
  String get loginTitle => 'Вход в систему';

  @override
  String get loginButton => 'Войти';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Пароль';

  @override
  String get loginFillFields => 'Пожалуйста, заполните все поля';

  @override
  String get loginSignInToAccount => 'Войти в аккаунт';

  @override
  String get loginUserNotFound => 'Пользователь не найден';

  @override
  String get loginWrongPassword => 'Неверный пароль';

  @override
  String get loginEmailInUse => 'Этот email уже зарегистрирован';

  @override
  String get loginWeakPassword => 'Пароль слишком простой';

  @override
  String get registerTitle => 'Регистрация';

  @override
  String get registerName => 'Ваше имя';

  @override
  String get registerButton => 'Зарегистрироваться';

  @override
  String get profileTitle => 'Кабинет';

  @override
  String get profileUser => 'Пользователь';

  @override
  String get profileMyActions => 'Мои действия';

  @override
  String get profileBookings => 'Бронирования';

  @override
  String get profileMyReviews => 'Мои отзывы';

  @override
  String get profileFaq => 'Помощь и FAQ';

  @override
  String get profileSettings => 'Настройки профиля';

  @override
  String get profileNotifications => 'Уведомления';

  @override
  String get profileSignOut => 'Выйти из аккаунта';

  @override
  String get profileSignOutConfirmTitle => 'Выход';

  @override
  String get profileSignOutConfirmBody =>
      'Вы уверены, что хотите выйти из аккаунта?';

  @override
  String get profileRoleAdmin => 'Администратор';

  @override
  String get profileRoleEmployee => 'Сотрудник';

  @override
  String get profileRoleClient => 'Клиент';

  @override
  String get profileSettingsTitle => 'Настройки профиля';

  @override
  String get profileSettingsChooseAvatar => 'Выберите аватар';

  @override
  String get profileSettingsYourName => 'Ваше имя';

  @override
  String get profileSettingsSave => 'Сохранить изменения';

  @override
  String get profileSettingsNameEmpty => 'Имя не может быть пустым';

  @override
  String get profileSettingsUpdated => 'Профиль успешно обновлен!';

  @override
  String profileSettingsCooldown(int hours) {
    return 'Изменение данных доступно через $hours ч.';
  }

  @override
  String get profileSettingsSecurity => 'Безопасность';

  @override
  String get profileSettingsChangePassword => 'Изменить пароль';

  @override
  String get profileSettingsPasswordEmailSent =>
      'Ссылка для смены пароля отправлена на почту';

  @override
  String get myBookingsTitle => 'Мои бронирования';

  @override
  String get myBookingsEmpty => 'У вас пока нет бронирований';

  @override
  String get myBookingsLoginRequired => 'Пожалуйста, войдите в систему';

  @override
  String get myBookingsErrorRooms => 'Ошибка загрузки данных о номерах';

  @override
  String get myBookingsRoomDeleted => 'Номер удален';

  @override
  String myBookingsRoomLabel(String name) {
    return 'Номер: $name';
  }

  @override
  String myBookingsGuestName(String name) {
    return 'На имя: $name';
  }

  @override
  String get myBookingsExpressCheckout => 'Экспресс-выезд';

  @override
  String get myBookingsCheckoutDialogTitle => 'Выезд из номера';

  @override
  String myBookingsCheckoutDialogBody(String name) {
    return 'Вы действительно хотите завершить проживание в номере $name?';
  }

  @override
  String get myBookingsConfirmCheckout => 'Подтвердить выезд';

  @override
  String get homeSearchDates => 'Выберите даты проживания';

  @override
  String get homeRoomType => 'Тип номера';

  @override
  String get homeAllTypes => 'Все типы';

  @override
  String get homeNoRooms => 'К сожалению, на эти даты\nсвободных номеров нет';

  @override
  String get homeOrderServices => 'Заказать услуги в номер';

  @override
  String get homeErrorTypes => 'Ошибка загрузки типов';

  @override
  String get homeProfile => 'Профиль';

  @override
  String get homeNew => 'Новый';

  @override
  String get roomDetailsPerNight => 'за ночь';

  @override
  String get roomDetailsDescription => 'Описание';

  @override
  String get roomDetailsDescriptionText =>
      'Уютный номер со всеми удобствами для вашего комфортного проживания. Мы гарантируем высокое качество обслуживания и чистоту.';

  @override
  String get roomDetailsAmenities => 'Удобства';

  @override
  String get roomDetailsAc => 'Кондиционер';

  @override
  String get roomDetailsCoffeeMaker => 'Кофемашина';

  @override
  String get roomDetailsBook => 'Забронировать номер';

  @override
  String get roomDetailsSelectDates => 'Выбрать даты проживания';

  @override
  String get roomDetailsGuestName => 'Ваше имя';

  @override
  String get roomDetailsGuestEmail => 'Email';

  @override
  String get roomDetailsEnterName => 'Введите имя';

  @override
  String get roomDetailsEnterEmail => 'Введите email';

  @override
  String roomDetailsTotalNights(int nights) {
    return 'Итого за $nights ночи:';
  }

  @override
  String get roomDetailsBookButton => 'ЗАБРОНИРОВАТЬ';

  @override
  String get roomDetailsReviews => 'Отзывы гостей';

  @override
  String get roomDetailsNoReviews => 'Отзывов пока нет. Будьте первым!';

  @override
  String roomDetailsErrorReviews(String error) {
    return 'Ошибка загрузки отзывов: $error';
  }

  @override
  String get roomDetailsDatesOccupied =>
      'Выбранный период содержит уже занятые даты';

  @override
  String get roomDetailsFillFields =>
      'Пожалуйста, выберите даты и заполните поля';

  @override
  String get roomDetailsDatesUnavailable => 'Ошибка: даты уже заняты';

  @override
  String get roomDetailsBookingSuccess =>
      'Заявка на бронирование отправлена! Ожидайте подтверждения.';

  @override
  String roomDetailsBookingError(String error) {
    return 'Ошибка при бронировании: $error';
  }

  @override
  String get roomDetailsErrorCalendar => 'Ошибка загрузки календаря';

  @override
  String get servicesTitle => 'Заказ услуг';

  @override
  String get servicesEmpty => 'Доступных услуг пока нет';

  @override
  String servicesErrorLoading(String error) {
    return 'Ошибка загрузки услуг: $error';
  }

  @override
  String get servicesOrder => 'Заказать';

  @override
  String get servicesConfirmTitle => 'Подтверждение заказа';

  @override
  String servicesConfirmBody(String name, String price) {
    return 'Вы хотите заказать \"$name\" за \$$price со счета вашего номера?';
  }

  @override
  String get servicesCancel => 'Отмена';

  @override
  String get servicesConfirm => 'Подтвердить';

  @override
  String get servicesOrdered =>
      'Услуга заказана! Сотрудник скоро свяжется с вами.';

  @override
  String get activeStayTitle => 'Мой номер';

  @override
  String get activeStayLoginRequired => 'Войдите в систему';

  @override
  String get activeStayNoActive => 'У вас нет активного проживания';

  @override
  String get activeStayNoActiveDesc =>
      'Заселитесь в отель, чтобы управлять номером и заказывать услуги.';

  @override
  String get activeStayRoomServices => 'Услуги в номер';

  @override
  String get activeStayNoServices => 'Нет доступных услуг.';

  @override
  String get activeStayCheckout => 'Выезд:';

  @override
  String activeStayOrderTitle(String name) {
    return 'Заказ: $name';
  }

  @override
  String activeStayOrderDesc(String room) {
    return 'Заказано из номера №$room';
  }

  @override
  String get activeStayOrderAccepted => 'Заказ принят!';

  @override
  String activeStayOrderDelivery(String name) {
    return 'Мы принесем \"$name\" в течение 15 минут прямо к вам в номер.';
  }

  @override
  String get activeStayOrderOk => 'ОТЛИЧНО';

  @override
  String activeStayOrderError(String error) {
    return 'Ошибка при заказе: $error';
  }

  @override
  String get activeStayErrorRooms => 'Ошибка комнат';

  @override
  String get activeStayRoomNotFound => 'Комната не найдена';

  @override
  String activeStayRoomLabel(String name) {
    return 'Номер $name';
  }

  @override
  String get faqTitle => 'Частые вопросы';

  @override
  String get faqEmpty => 'Здесь пока нет ответов на вопросы.';

  @override
  String get faqAnswerSoon => 'Ответ скоро появится...';

  @override
  String get faqAskQuestion => 'Задать вопрос';

  @override
  String get faqAskDialogTitle => 'Задать вопрос';

  @override
  String get faqAskHint => 'Введите ваш вопрос...';

  @override
  String get faqCancel => 'Отмена';

  @override
  String get faqSend => 'Отправить';

  @override
  String get faqGuest => 'Гость';

  @override
  String get faqSent => 'Вопрос отправлен! Мы ответим в ближайшее время.';

  @override
  String faqErrorLoading(String error) {
    return 'Ошибка загрузки: $error';
  }

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String get notificationsEmpty => 'У вас нет новых уведомлений';

  @override
  String get notificationsClose => 'Закрыть';

  @override
  String get notificationBookingConfirmed => 'Бронирование подтверждено';

  @override
  String get notificationBookingConfirmedBody =>
      'Ваша бронь номера №302 успешно подтверждена. Ждем вас!';

  @override
  String get notificationWelcome => 'Добро пожаловать!';

  @override
  String get notificationWelcomeBody =>
      'Спасибо, что выбрали Manas Hotel. Приятного отдыха!';

  @override
  String get notificationCleaningDone => 'Уборка завершена';

  @override
  String get notificationCleaningDoneBody =>
      'Ваш номер был полностью убран и продезинфицирован.';

  @override
  String get newsTitle => 'Свежие новости';

  @override
  String get newsErrorLoading => 'Ошибка загрузки новостей';

  @override
  String get newsDialogTitle => 'Новость';

  @override
  String get adminDashboardTitle => 'Админка';

  @override
  String get adminOverview => 'Обзор отеля';

  @override
  String get adminBookings => 'Брони';

  @override
  String get adminCalendar => 'Шахматка';

  @override
  String get adminNewRequests => 'Новые заявки';

  @override
  String get adminCreateBooking => 'Создать бронь';

  @override
  String get adminBookingHistory => 'История броней';

  @override
  String get adminNews => 'Новости';

  @override
  String get adminCreateNews => 'Сделать публикацию';

  @override
  String get adminActiveNews => 'Активные публикации';

  @override
  String get adminArchiveNews => 'Архив';

  @override
  String get adminRooms => 'Номера';

  @override
  String get adminServices => 'Услуги';

  @override
  String get adminEmployees => 'Сотрудники';

  @override
  String get adminFaq => 'FAQ';

  @override
  String get adminStatsNewRequests => 'Новые заявки';

  @override
  String get adminStatsMonthlyRevenue => 'Выручка за месяц';

  @override
  String get adminStatsUpcomingCheckIns => 'Предстоящие заезды';

  @override
  String get adminStatsTotalBookings => 'Всего броней';

  @override
  String get adminStatsPending => 'Ожидают';

  @override
  String get adminStatsAvailable => 'Доступно';

  @override
  String get adminStatsRevenue => 'Доход';

  @override
  String get adminCalendarTitle => 'Шахматка (Live)';

  @override
  String get adminCalendarRoomDates => 'Номера \\ Даты';

  @override
  String get adminCalendarSelectBooking =>
      'Выберите бронь на шахматке,\nчтобы увидеть подробности';

  @override
  String get adminCalendarBooking => 'Бронь';

  @override
  String get adminCalendarConfirmed => 'Подтверждено';

  @override
  String get adminCalendarPending => 'Ожидает';

  @override
  String adminCalendarGuest(String name) {
    return 'Гость: $name';
  }

  @override
  String get adminCalendarCheckIn => 'Заезд';

  @override
  String get adminCalendarCheckOut => 'Выезд';

  @override
  String get adminCalendarTotal => 'Сумма';

  @override
  String get adminCalendarConfirmButton => 'Подтвердить';

  @override
  String get adminCalendarCancelButton => 'Отменить';

  @override
  String get adminCalendarCheckOutButton => 'Оформить выезд';

  @override
  String get adminCalendarEditButton => 'Редактировать';

  @override
  String get adminCalendarInvoice => 'Счет';

  @override
  String adminCalendarCleaningTitle(String name) {
    return 'Уборка после выезда: № $name';
  }

  @override
  String get adminCalendarCleaningDesc =>
      'Гость выехал. Требуется полная уборка номера, замена белья и проверка мини-бара.';

  @override
  String get adminCalendarCheckoutDone =>
      'Выезд оформлен. Задача на уборку отправлена.';

  @override
  String adminCalendarCheckoutError(String error) {
    return 'Ошибка при оформлении выезда: $error';
  }

  @override
  String get adminCalendarBookingConfirmed => 'Бронь подтверждена!';

  @override
  String get adminCalendarBookingCancelled => 'Бронь отменена.';

  @override
  String adminCalendarUpdateError(String error) {
    return 'Ошибка обновления: $error';
  }

  @override
  String adminCalendarGuestShort(String id) {
    return 'Гость $id';
  }

  @override
  String adminCalendarErrorRooms(String error) {
    return 'Ошибка загрузки номеров: $error';
  }

  @override
  String adminCalendarErrorBookings(String error) {
    return 'Ошибка загрузки броней: $error';
  }

  @override
  String get adminRequestsTitle => 'Новые заявки';

  @override
  String get adminRequestsEmpty => 'Новых заявок нет';

  @override
  String get adminRequestsErrorLoading => 'Ошибка загрузки заявок';

  @override
  String adminRequestsErrorRooms(String error) {
    return 'Ошибка загрузки номеров: $error';
  }

  @override
  String adminRequestsRoomLabel(String name, String type) {
    return 'Номер: $name ($type)';
  }

  @override
  String get adminRequestsRejectTitle => 'Отклонить заявку?';

  @override
  String get adminRequestsRejectBody =>
      'Заявка будет отменена. Гость получит уведомление (если настроено).';

  @override
  String get adminRequestsRejectButton => 'Отклонить';

  @override
  String get adminRequestsRejected => 'Заявка отклонена';

  @override
  String get adminRequestsConfirm => 'Подтвердить';

  @override
  String get adminRequestsBack => 'Назад';

  @override
  String adminRequestsError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get adminRequestsIndexHint =>
      'Возможно, нужно создать составной индекс в Firebase Console:\nКоллекция \"bookings\" → поля: status (По возрастанию) + createdAt (По убыванию)';

  @override
  String adminRequestsDetails(String error) {
    return 'Детали: $error';
  }

  @override
  String get adminRoomsTitle => 'Управление номерами';

  @override
  String get adminRoomsAddDialog => 'Добавить номер';

  @override
  String get adminRoomsNameLabel => 'Название/Номер';

  @override
  String get adminRoomsPriceLabel => 'Цена за ночь';

  @override
  String get adminRoomsTypeLabel => 'Тип номера';

  @override
  String get adminRoomsSelectType => 'Выберите тип';

  @override
  String get adminRoomsServices => 'Доступные услуги:';

  @override
  String get adminRoomsEnterName => 'Введите название';

  @override
  String get adminRoomsEnterPrice => 'Введите цену';

  @override
  String get adminRoomsSelectTypeHint => 'Выберите тип номера';

  @override
  String get adminRoomsErrorTypes => 'Ошибка загрузки типов';

  @override
  String get adminRoomsCreate => 'Создать';

  @override
  String get adminRoomsCancel => 'Отмена';

  @override
  String get adminServicesTitle => 'Услуги отеля';

  @override
  String get adminServicesAddDialog => 'Добавить услугу';

  @override
  String get adminServicesCancel => 'Отмена';

  @override
  String get adminServicesSave => 'Сохранить';

  @override
  String get adminEmployeesTitle => 'Управление персоналом';

  @override
  String get adminEmployeesEmpty => 'Сотрудников пока нет';

  @override
  String get adminEmployeesErrorLoading => 'Ошибка загрузки';

  @override
  String get adminEmployeesNoName => 'Без имени';

  @override
  String get adminEmployeesAddDialog => 'Добавить сотрудника';

  @override
  String get adminEmployeesName => 'Имя';

  @override
  String get adminEmployeesEmail => 'Email';

  @override
  String get adminEmployeesNickname => 'Никнейм';

  @override
  String get adminEmployeesPassword => 'Пароль';

  @override
  String get adminEmployeesEnterName => 'Введите имя';

  @override
  String get adminEmployeesEnterEmail => 'Введите email';

  @override
  String get adminEmployeesEnterNickname => 'Введите никнейм';

  @override
  String get adminEmployeesInvalidEmail => 'Некорректный email';

  @override
  String get adminEmployeesMinPassword => 'Минимум 6 символов';

  @override
  String get adminEmployeesWeakPassword => 'Пароль слишком простой';

  @override
  String get adminEmployeesEmailInUse => 'Этот email уже используется';

  @override
  String get adminEmployeesRegisterError => 'Произошла ошибка';

  @override
  String get adminEmployeesRegistered => 'Сотрудник успешно зарегистрирован';

  @override
  String adminEmployeesError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get adminEmployeesRegister => 'Зарегистрировать';

  @override
  String get adminEmployeesCancel => 'Отмена';

  @override
  String get adminFaqTitle => 'Управление FAQ';

  @override
  String get adminFaqAllQuestions => 'Все вопросы';

  @override
  String get adminFaqUnanswered => 'Без ответа';

  @override
  String get adminFaqCreateTitle => 'Создать FAQ';

  @override
  String adminFaqErrorLoading(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get adminBookingDialogTitle => 'Новое бронирование (Админ)';

  @override
  String get adminBookingSelectDates => 'Выберите даты заезда и выезда';

  @override
  String get adminBookingRoom => 'Номер';

  @override
  String get adminBookingGuestName => 'Имя гостя';

  @override
  String get adminBookingRequired => 'Обязательное поле';

  @override
  String adminBookingTotal(String price) {
    return 'Итого: \$$price';
  }

  @override
  String get adminBookingFillFields => 'Заполните все поля';

  @override
  String get adminBookingSave => 'Сохранить';

  @override
  String get adminBookingCancel => 'Отмена';

  @override
  String adminBookingError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get adminBookingNoName => 'Без имени';

  @override
  String get bookingActionPending =>
      'Заявка ожидает подтверждения. Подтвердите или отклоните.';

  @override
  String get bookingActionConfirmed =>
      'Бронь подтверждена. Гость прибыл? Нажмите «Заселить».';

  @override
  String get bookingActionCheckedIn =>
      'Гость проживает. Оформите выезд, чтобы отправить номер на уборку.';

  @override
  String get bookingActionCheckedOut => 'Гость выехал. Действия недоступны.';

  @override
  String get bookingActionCancelled => 'Бронь отменена.';

  @override
  String get bookingActionConfirmButton => 'Подтвердить';

  @override
  String get bookingActionRejectButton => 'Отклонить';

  @override
  String get bookingActionCheckinButton => 'Заселить';

  @override
  String get bookingActionCheckoutButton => 'Оформить выезд';

  @override
  String get bookingActionClose => 'Закрыть';

  @override
  String bookingActionError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get bookingStatusCheckedIn => 'Заехал';

  @override
  String get bookingStatusCheckedOut => 'Выехал';

  @override
  String get bookingStatusCancelled => 'Отменено';

  @override
  String get tasksTitle => 'Задачи';

  @override
  String get tasksMyTasksTitle => 'Мои задачи';

  @override
  String get tasksPending => 'Ожидают';

  @override
  String get tasksInProgress => 'В работе';

  @override
  String get tasksDone => 'Готово';

  @override
  String get tasksNew => 'Новая задача';

  @override
  String get tasksName => 'Название';

  @override
  String get tasksDescription => 'Описание';

  @override
  String get tasksNameHint => 'Например: Уборка номера';

  @override
  String get tasksDescHint => 'Что именно нужно сделать?';

  @override
  String get tasksAssignEmployee => 'Назначить сотрудника';

  @override
  String get tasksAttachRoom => 'Привязать к номеру';

  @override
  String get tasksUnattached => 'Без привязки';

  @override
  String get tasksUnassigned => 'Не назначено';

  @override
  String get tasksCreate => 'Создать';

  @override
  String get tasksCancel => 'Отмена';

  @override
  String get tasksErrorRooms => 'Ошибка загрузки номеров';

  @override
  String get tasksErrorStaff => 'Ошибка загрузки персонала';

  @override
  String tasksError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get tasksTakeButton => 'ВЗЯТЬ В РАБОТУ';

  @override
  String get tasksCompleteButton => 'ЗАВЕРШИТЬ';

  @override
  String get tasksNoTasksToday => 'На сегодня задач нет!';

  @override
  String get tasksWellDone => 'Вы отлично поработали.';

  @override
  String get tasksLoginRequired => 'Пожалуйста, войдите в систему';

  @override
  String get tasksCommonArea => 'Общая территория';

  @override
  String tasksRoomLabel(String name) {
    return 'Номер № $name';
  }

  @override
  String get newsCreateTitle => 'Создать новость';

  @override
  String get newsCreateHeadline => 'Заголовок';

  @override
  String get newsCreateEnterHeadline => 'Введите заголовок!';

  @override
  String get newsCreateAudience => 'Кто увидит новость:';

  @override
  String get newsCreateAudienceAll => 'Всем';

  @override
  String get newsCreateAudienceGuests => 'Гостям';

  @override
  String get newsCreateAudienceStaff => 'Персоналу';

  @override
  String newsCreateSectionHint(int num) {
    return 'Текст секции $num';
  }

  @override
  String get newsCreateAddImage => 'Добавить картинку';

  @override
  String get newsCreateNoContent =>
      'Добавьте хотя бы немного текста или картинку';

  @override
  String get newsCreateSuccess => 'Новость успешно опубликована! 🎉';

  @override
  String newsCreateError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get newsCreatePublish => 'Опубликовать';

  @override
  String get newsCreateImageSizeError =>
      'Размер картинки для ПК не должен превышать 250 кБ';

  @override
  String get newsManageTitle => 'Управление новостями';

  @override
  String get newsManageActive => 'Активные';

  @override
  String get newsManageArchive => 'Архив';

  @override
  String get newsManageActiveEmpty => 'Активных новостей нет';

  @override
  String get newsManageArchiveEmpty => 'Архив пуст';

  @override
  String get newsManageCreate => 'Создать';

  @override
  String get newsManageDelete => 'Удалить';

  @override
  String get newsManageDeleteTitle => 'Удаление';

  @override
  String get newsManageDeleteConfirm =>
      'Вы уверены, что хотите удалить новость навсегда?';

  @override
  String get newsManageCancel => 'Отмена';

  @override
  String newsManageError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get newsManageCreateHint =>
      'Используйте кнопку \"Создать\" в меню или FAB';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get save => 'Сохранить';

  @override
  String get close => 'Закрыть';

  @override
  String get delete => 'Удалить';

  @override
  String get error => 'Ошибка';

  @override
  String get ok => 'ОК';
}
