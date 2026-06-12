// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kirghiz Kyrgyz (`ky`).
class AppLocalizationsKy extends AppLocalizations {
  AppLocalizationsKy([String locale = 'ky']) : super(locale);

  @override
  String get appName => 'Manas Hotel';

  @override
  String get navHome => 'Башкы бет';

  @override
  String get navServices => 'Кызматтар';

  @override
  String get navProfile => 'Кабинет';

  @override
  String get navLogin => 'Кирүү';

  @override
  String get navTasks => 'Тапшырмалар';

  @override
  String get navAdmin => 'Админ';

  @override
  String errorGeneric(String error) {
    return 'Ката: $error';
  }

  @override
  String get errorLoading => 'Жүктөө катасы';

  @override
  String errorLoadingData(String error) {
    return 'Маалыматты жүктөөдө ката: $error';
  }

  @override
  String get errorAuth => 'Авторизация катасы';

  @override
  String get errorRole => 'Роль катасы';

  @override
  String get loading => 'Жүктөлүүдө...';

  @override
  String get loginTitle => 'Системага кирүү';

  @override
  String get loginButton => 'Кирүү';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Сырсөз';

  @override
  String get loginFillFields => 'Бардык талааларды толтуруңуз';

  @override
  String get loginSignInToAccount => 'Аккаунтка кирүү';

  @override
  String get loginUserNotFound => 'Колдонуучу табылган жок';

  @override
  String get loginWrongPassword => 'Сырсөз туура эмес';

  @override
  String get loginEmailInUse => 'Бул email катталып калган';

  @override
  String get loginWeakPassword => 'Сырсөз өтө жөнөкөй';

  @override
  String get registerTitle => 'Катталуу';

  @override
  String get registerName => 'Атыңыз';

  @override
  String get registerButton => 'Катталуу';

  @override
  String get profileTitle => 'Кабинет';

  @override
  String get profileUser => 'Колдонуучу';

  @override
  String get profileMyActions => 'Менин аракеттерим';

  @override
  String get profileBookings => 'Брондоолор';

  @override
  String get profileMyReviews => 'Менин пикирлерим';

  @override
  String get profileFaq => 'Жардам жана FAQ';

  @override
  String get profileSettings => 'Профиль жөндөөлөрү';

  @override
  String get profileNotifications => 'Билдирмелер';

  @override
  String get profileSignOut => 'Чыгуу';

  @override
  String get profileSignOutConfirmTitle => 'Чыгуу';

  @override
  String get profileSignOutConfirmBody => 'Аккаунттан чыгууну каалайсызбы?';

  @override
  String get profileRoleAdmin => 'Администратор';

  @override
  String get profileRoleEmployee => 'Кызматкер';

  @override
  String get profileRoleClient => 'Кардар';

  @override
  String get profileSettingsTitle => 'Профиль жөндөөлөрү';

  @override
  String get profileSettingsChooseAvatar => 'Аватар тандаңыз';

  @override
  String get profileSettingsYourName => 'Атыңыз';

  @override
  String get profileSettingsSave => 'Өзгөртүүлөрдү сактоо';

  @override
  String get profileSettingsNameEmpty => 'Ат бош болушу мүмкүн эмес';

  @override
  String get profileSettingsUpdated => 'Профиль ийгиликтүү жаңыланды!';

  @override
  String profileSettingsCooldown(int hours) {
    return 'Маалыматты өзгөртүү $hours саат. соң жеткиликтүү';
  }

  @override
  String get profileSettingsSecurity => 'Коопсуздук';

  @override
  String get profileSettingsChangePassword => 'Сырсөздү өзгөртүү';

  @override
  String get profileSettingsPasswordEmailSent =>
      'Сырсөздү алмаштыруу шилтемеси emailга жиберилди';

  @override
  String get myBookingsTitle => 'Менин брондоолорум';

  @override
  String get myBookingsEmpty => 'Азырынча брондоолоруңуз жок';

  @override
  String get myBookingsLoginRequired => 'Системага кириңиз';

  @override
  String get myBookingsErrorRooms => 'Бөлмө маалыматын жүктөөдө ката';

  @override
  String get myBookingsRoomDeleted => 'Бөлмө өчүрүлгөн';

  @override
  String myBookingsRoomLabel(String name) {
    return 'Бөлмө: $name';
  }

  @override
  String myBookingsGuestName(String name) {
    return 'Аты: $name';
  }

  @override
  String get myBookingsExpressCheckout => 'Тез чыгуу';

  @override
  String get myBookingsCheckoutDialogTitle => 'Бөлмөдөн чыгуу';

  @override
  String myBookingsCheckoutDialogBody(String name) {
    return '$name бөлмөсүндөгү жашоону аяктагыңыз келеби?';
  }

  @override
  String get myBookingsConfirmCheckout => 'Чыгууну ырастоо';

  @override
  String get homeSearchDates => 'Жашоо күндөрүн тандаңыз';

  @override
  String get homeRoomType => 'Бөлмө түрү';

  @override
  String get homeAllTypes => 'Бардык түрлөр';

  @override
  String get homeNoRooms => 'Кечиресиз, бул күндөргө\nбош бөлмөлөр жок';

  @override
  String get homeOrderServices => 'Бөлмөгө кызмат заказ кылуу';

  @override
  String get homeErrorTypes => 'Түрлөрдү жүктөөдө ката';

  @override
  String get homeProfile => 'Профиль';

  @override
  String get homeNew => 'Жаңы';

  @override
  String get roomDetailsPerNight => 'түн үчүн';

  @override
  String get roomDetailsDescription => 'Сүрөттөмө';

  @override
  String get roomDetailsDescriptionText =>
      'Ыңгайлуу жашоо үчүн бардык шарттары бар уютный бөлмө. Биз жогорку сапаттуу тейлөөнү жана тазалыкты кепилдейбиз.';

  @override
  String get roomDetailsAmenities => 'Шарттар';

  @override
  String get roomDetailsAc => 'Кондиционер';

  @override
  String get roomDetailsCoffeeMaker => 'Кофемашина';

  @override
  String get roomDetailsBook => 'Бөлмөнү броньдоо';

  @override
  String get roomDetailsSelectDates => 'Жашоо күндөрүн тандаңыз';

  @override
  String get roomDetailsGuestName => 'Атыңыз';

  @override
  String get roomDetailsGuestEmail => 'Email';

  @override
  String get roomDetailsEnterName => 'Атыңызды киргизиңиз';

  @override
  String get roomDetailsEnterEmail => 'Email киргизиңиз';

  @override
  String roomDetailsTotalNights(int nights) {
    return '$nights түн үчүн жалпы:';
  }

  @override
  String get roomDetailsBookButton => 'БРОНЬДОО';

  @override
  String get roomDetailsReviews => 'Коноктордун пикирлери';

  @override
  String get roomDetailsNoReviews => 'Азырынча пикир жок. Биринчи болуңуз!';

  @override
  String roomDetailsErrorReviews(String error) {
    return 'Пикирлерди жүктөөдө ката: $error';
  }

  @override
  String get roomDetailsDatesOccupied =>
      'Тандалган мезгилде ээлик кылынган күндөр бар';

  @override
  String get roomDetailsFillFields =>
      'Күндөрдү тандаңыз жана талааларды толтуруңуз';

  @override
  String get roomDetailsDatesUnavailable => 'Ката: күндөр ээлик кылынган';

  @override
  String get roomDetailsBookingSuccess =>
      'Броньдоо өтүнүчү жиберилди! Ырастоону күтүңүз.';

  @override
  String roomDetailsBookingError(String error) {
    return 'Броньдоодо ката: $error';
  }

  @override
  String get roomDetailsErrorCalendar => 'Жылнаманы жүктөөдө ката';

  @override
  String get servicesTitle => 'Кызматтарды заказ кылуу';

  @override
  String get servicesEmpty => 'Азырынча жеткиликтүү кызматтар жок';

  @override
  String servicesErrorLoading(String error) {
    return 'Кызматтарды жүктөөдө ката: $error';
  }

  @override
  String get servicesOrder => 'Заказ кылуу';

  @override
  String get servicesConfirmTitle => 'Заказды ырастоо';

  @override
  String servicesConfirmBody(String name, String price) {
    return '\"$name\" кызматын \$$price суммага бөлмөңүздүн эсебинен заказ кылгыңыз келеби?';
  }

  @override
  String get servicesCancel => 'Жокко чыгаруу';

  @override
  String get servicesConfirm => 'Ырастоо';

  @override
  String get servicesOrdered =>
      'Кызмат заказ кылынды! Кызматкер жакында сиз менен байланышат.';

  @override
  String get activeStayTitle => 'Менин бөлмөм';

  @override
  String get activeStayLoginRequired => 'Системага кириңиз';

  @override
  String get activeStayNoActive => 'Сизде активдүү жашоо жок';

  @override
  String get activeStayNoActiveDesc =>
      'Бөлмөнү башкаруу жана кызматтарды заказ кылуу үчүн мейманканага орношуңуз.';

  @override
  String get activeStayRoomServices => 'Бөлмөгө кызматтар';

  @override
  String get activeStayNoServices => 'Жеткиликтүү кызматтар жок.';

  @override
  String get activeStayCheckout => 'Чыгуу:';

  @override
  String activeStayOrderTitle(String name) {
    return 'Заказ: $name';
  }

  @override
  String activeStayOrderDesc(String room) {
    return '№$room бөлмөсүнөн заказ берилди';
  }

  @override
  String get activeStayOrderAccepted => 'Заказ кабыл алынды!';

  @override
  String activeStayOrderDelivery(String name) {
    return '\"$name\" 15 мүнөт ичинде бөлмөңүзгө жеткирилет.';
  }

  @override
  String get activeStayOrderOk => 'ЖАКШЫ';

  @override
  String activeStayOrderError(String error) {
    return 'Заказ берүүдө ката: $error';
  }

  @override
  String get activeStayErrorRooms => 'Бөлмө катасы';

  @override
  String get activeStayRoomNotFound => 'Бөлмө табылган жок';

  @override
  String activeStayRoomLabel(String name) {
    return 'Бөлмө $name';
  }

  @override
  String get faqTitle => 'Көп берилген суроолор';

  @override
  String get faqEmpty => 'Азырынча суроолорго жоопор жок.';

  @override
  String get faqAnswerSoon => 'Жооп жакында пайда болот...';

  @override
  String get faqAskQuestion => 'Суроо берүү';

  @override
  String get faqAskDialogTitle => 'Суроо берүү';

  @override
  String get faqAskHint => 'Суроонузду жазыңыз...';

  @override
  String get faqCancel => 'Жокко чыгаруу';

  @override
  String get faqSend => 'Жөнөтүү';

  @override
  String get faqGuest => 'Конок';

  @override
  String get faqSent => 'Суроо жиберилди! Жакында жооп беребиз.';

  @override
  String faqErrorLoading(String error) {
    return 'Жүктөөдө ката: $error';
  }

  @override
  String get notificationsTitle => 'Билдирмелер';

  @override
  String get notificationsEmpty => 'Сизде жаңы билдирмелер жок';

  @override
  String get notificationsClose => 'Жабуу';

  @override
  String get notificationBookingConfirmed => 'Броньдоо ырасталды';

  @override
  String get notificationBookingConfirmedBody =>
      '№302 бөлмөсүнүн брондоосу ырасталды. Сизди күтөбүз!';

  @override
  String get notificationWelcome => 'Кош келиңиз!';

  @override
  String get notificationWelcomeBody =>
      'Manas Hotelди тандаганыңыз үчүн рахмат. Жакшы эс алыңыз!';

  @override
  String get notificationCleaningDone => 'Тазалоо аяктады';

  @override
  String get notificationCleaningDoneBody =>
      'Бөлмөңүз толугу менен тазаланды жана дезинфекцияланды.';

  @override
  String get newsTitle => 'Акыркы жаңылыктар';

  @override
  String get newsErrorLoading => 'Жаңылыктарды жүктөөдө ката';

  @override
  String get newsDialogTitle => 'Жаңылык';

  @override
  String get adminDashboardTitle => 'Администратор';

  @override
  String get adminOverview => 'Мейманкана жыйынтыгы';

  @override
  String get adminBookings => 'Броньдоолор';

  @override
  String get adminCalendar => 'Календарь';

  @override
  String get adminNewRequests => 'Жаңы өтүнүчтөр';

  @override
  String get adminCreateBooking => 'Броньдоо түзүү';

  @override
  String get adminBookingHistory => 'Броньдоолор тарыхы';

  @override
  String get adminNews => 'Жаңылыктар';

  @override
  String get adminCreateNews => 'Жарыялоо';

  @override
  String get adminActiveNews => 'Активдүү жарыялар';

  @override
  String get adminArchiveNews => 'Архив';

  @override
  String get adminRooms => 'Бөлмөлөр';

  @override
  String get adminServices => 'Кызматтар';

  @override
  String get adminEmployees => 'Кызматкерлер';

  @override
  String get adminFaq => 'FAQ';

  @override
  String get adminStatsNewRequests => 'Жаңы өтүнүчтөр';

  @override
  String get adminStatsMonthlyRevenue => 'Айлык киреше';

  @override
  String get adminStatsUpcomingCheckIns => 'Алдыдагы кирүүлөр';

  @override
  String get adminStatsTotalBookings => 'Жалпы броньдоолор';

  @override
  String get adminStatsPending => 'Күтүүдө';

  @override
  String get adminStatsAvailable => 'Жеткиликтүү';

  @override
  String get adminStatsRevenue => 'Киреше';

  @override
  String get adminCalendarTitle => 'Календарь (Live)';

  @override
  String get adminCalendarRoomDates => 'Бөлмөлөр \\ Күндөр';

  @override
  String get adminCalendarSelectBooking =>
      'Деталдарды көрүү үчүн\nкалендарда броньдоону тандаңыз';

  @override
  String get adminCalendarBooking => 'Броньдоо';

  @override
  String get adminCalendarConfirmed => 'Ырасталды';

  @override
  String get adminCalendarPending => 'Күтүүдө';

  @override
  String adminCalendarGuest(String name) {
    return 'Конок: $name';
  }

  @override
  String get adminCalendarCheckIn => 'Кириш';

  @override
  String get adminCalendarCheckOut => 'Чыгуу';

  @override
  String get adminCalendarTotal => 'Сумма';

  @override
  String get adminCalendarConfirmButton => 'Ырастоо';

  @override
  String get adminCalendarCancelButton => 'Жокко чыгаруу';

  @override
  String get adminCalendarCheckOutButton => 'Чыгууну тариздөө';

  @override
  String get adminCalendarEditButton => 'Өзгөртүү';

  @override
  String get adminCalendarInvoice => 'Эсеп';

  @override
  String adminCalendarCleaningTitle(String name) {
    return 'Чыгуудан кийинки тазалоо: № $name';
  }

  @override
  String get adminCalendarCleaningDesc =>
      'Конок чыкты. Бөлмөнү толук тазалоо, жууркан-төшөк алмаштыруу жана мини-барды текшерүү талап кылынат.';

  @override
  String get adminCalendarCheckoutDone =>
      'Чыгуу тариздолду. Тазалоо тапшырмасы жиберилди.';

  @override
  String adminCalendarCheckoutError(String error) {
    return 'Чыгууну тариздөөдө ката: $error';
  }

  @override
  String get adminCalendarBookingConfirmed => 'Броньдоо ырасталды!';

  @override
  String get adminCalendarBookingCancelled => 'Броньдоо жокко чыгарылды.';

  @override
  String adminCalendarUpdateError(String error) {
    return 'Жаңыртуу катасы: $error';
  }

  @override
  String adminCalendarGuestShort(String id) {
    return 'Конок $id';
  }

  @override
  String adminCalendarErrorRooms(String error) {
    return 'Бөлмөлөрдү жүктөөдө ката: $error';
  }

  @override
  String adminCalendarErrorBookings(String error) {
    return 'Броньдоолорду жүктөөдө ката: $error';
  }

  @override
  String get adminRequestsTitle => 'Жаңы өтүнүчтөр';

  @override
  String get adminRequestsEmpty => 'Жаңы өтүнүчтөр жок';

  @override
  String get adminRequestsErrorLoading => 'Өтүнүчтөрдү жүктөөдө ката';

  @override
  String adminRequestsErrorRooms(String error) {
    return 'Бөлмөлөрдү жүктөөдө ката: $error';
  }

  @override
  String adminRequestsRoomLabel(String name, String type) {
    return 'Бөлмө: $name ($type)';
  }

  @override
  String get adminRequestsRejectTitle => 'Өтүнүчтү четке кагабызбы?';

  @override
  String get adminRequestsRejectBody =>
      'Өтүнүч жокко чыгарылат. Конокко билдирме жиберилет (эгер жөндөлгөн болсо).';

  @override
  String get adminRequestsRejectButton => 'Четке кагуу';

  @override
  String get adminRequestsRejected => 'Өтүнүч четке кагылды';

  @override
  String get adminRequestsConfirm => 'Ырастоо';

  @override
  String get adminRequestsBack => 'Артка';

  @override
  String adminRequestsError(String error) {
    return 'Ката: $error';
  }

  @override
  String get adminRequestsIndexHint =>
      'Firebase Console\'до составной индекс түзүш керек болушу мүмкүн:\n\"bookings\" коллекциясы → талаалар: status (Өсүш боюнча) + createdAt (Кемүү боюнча)';

  @override
  String adminRequestsDetails(String error) {
    return 'Деталдар: $error';
  }

  @override
  String get adminRoomsTitle => 'Бөлмөлөрдү башкаруу';

  @override
  String get adminRoomsAddDialog => 'Бөлмө кошуу';

  @override
  String get adminRoomsNameLabel => 'Аты/Номери';

  @override
  String get adminRoomsPriceLabel => 'Бир түн баасы';

  @override
  String get adminRoomsTypeLabel => 'Бөлмө түрү';

  @override
  String get adminRoomsSelectType => 'Түрдү тандаңыз';

  @override
  String get adminRoomsServices => 'Жеткиликтүү кызматтар:';

  @override
  String get adminRoomsEnterName => 'Атын киргизиңиз';

  @override
  String get adminRoomsEnterPrice => 'Баасын киргизиңиз';

  @override
  String get adminRoomsSelectTypeHint => 'Бөлмө түрүн тандаңыз';

  @override
  String get adminRoomsErrorTypes => 'Түрлөрдү жүктөөдө ката';

  @override
  String get adminRoomsCreate => 'Түзүү';

  @override
  String get adminRoomsCancel => 'Жокко чыгаруу';

  @override
  String get adminServicesTitle => 'Мейманкана кызматтары';

  @override
  String get adminServicesAddDialog => 'Кызмат кошуу';

  @override
  String get adminServicesCancel => 'Жокко чыгаруу';

  @override
  String get adminServicesSave => 'Сактоо';

  @override
  String get adminEmployeesTitle => 'Кызматкерлерди башкаруу';

  @override
  String get adminEmployeesEmpty => 'Азырынча кызматкерлер жок';

  @override
  String get adminEmployeesErrorLoading => 'Жүктөөдө ката';

  @override
  String get adminEmployeesNoName => 'Аты жок';

  @override
  String get adminEmployeesAddDialog => 'Кызматкер кошуу';

  @override
  String get adminEmployeesName => 'Аты';

  @override
  String get adminEmployeesEmail => 'Email';

  @override
  String get adminEmployeesNickname => 'Никнейм';

  @override
  String get adminEmployeesPassword => 'Сырсөз';

  @override
  String get adminEmployeesEnterName => 'Атын киргизиңиз';

  @override
  String get adminEmployeesEnterEmail => 'Email киргизиңиз';

  @override
  String get adminEmployeesEnterNickname => 'Никнейм киргизиңиз';

  @override
  String get adminEmployeesInvalidEmail => 'Email туура эмес';

  @override
  String get adminEmployeesMinPassword => 'Минимум 6 символ';

  @override
  String get adminEmployeesWeakPassword => 'Сырсөз өтө жөнөкөй';

  @override
  String get adminEmployeesEmailInUse => 'Бул email колдонулуп жатат';

  @override
  String get adminEmployeesRegisterError => 'Ката болду';

  @override
  String get adminEmployeesRegistered => 'Кызматкер ийгиликтүү катталды';

  @override
  String adminEmployeesError(String error) {
    return 'Ката: $error';
  }

  @override
  String get adminEmployeesRegister => 'Каттоо';

  @override
  String get adminEmployeesCancel => 'Жокко чыгаруу';

  @override
  String get adminFaqTitle => 'FAQ башкаруу';

  @override
  String get adminFaqAllQuestions => 'Бардык суроолор';

  @override
  String get adminFaqUnanswered => 'Жоопсуз';

  @override
  String get adminFaqCreateTitle => 'FAQ түзүү';

  @override
  String adminFaqErrorLoading(String error) {
    return 'Ката: $error';
  }

  @override
  String get adminBookingDialogTitle => 'Жаңы броньдоо (Админ)';

  @override
  String get adminBookingSelectDates => 'Кириш жана чыгуу күндөрүн тандаңыз';

  @override
  String get adminBookingRoom => 'Бөлмө';

  @override
  String get adminBookingGuestName => 'Конокту аты';

  @override
  String get adminBookingRequired => 'Милдеттүү талаа';

  @override
  String adminBookingTotal(String price) {
    return 'Жалпы: \$$price';
  }

  @override
  String get adminBookingFillFields => 'Бардык талааларды толтуруңуз';

  @override
  String get adminBookingSave => 'Сактоо';

  @override
  String get adminBookingCancel => 'Жокко чыгаруу';

  @override
  String adminBookingError(String error) {
    return 'Ката: $error';
  }

  @override
  String get adminBookingNoName => 'Аты жок';

  @override
  String get bookingActionPending =>
      'Өтүнүч ырастоону күтүүдө. Ырастаңыз же четке кагыңыз.';

  @override
  String get bookingActionConfirmed =>
      'Броньдоо ырасталды. Конок келдиби? «Орноштуруу» дегенди басыңыз.';

  @override
  String get bookingActionCheckedIn =>
      'Конок жашап жатат. Бөлмөнү тазалоого жиберүү үчүн чыгууну тариздеңиз.';

  @override
  String get bookingActionCheckedOut => 'Конок чыкты. Аракеттер жеткиликсиз.';

  @override
  String get bookingActionCancelled => 'Броньдоо жокко чыгарылды.';

  @override
  String get bookingActionConfirmButton => 'Ырастоо';

  @override
  String get bookingActionRejectButton => 'Четке кагуу';

  @override
  String get bookingActionCheckinButton => 'Орноштуруу';

  @override
  String get bookingActionCheckoutButton => 'Чыгууну тариздөө';

  @override
  String get bookingActionClose => 'Жабуу';

  @override
  String bookingActionError(String error) {
    return 'Ката: $error';
  }

  @override
  String get bookingStatusCheckedIn => 'Конду';

  @override
  String get bookingStatusCheckedOut => 'Чыкты';

  @override
  String get bookingStatusCancelled => 'Жоктолду';

  @override
  String get tasksTitle => 'Тапшырмалар';

  @override
  String get tasksMyTasksTitle => 'Менин тапшырмаларым';

  @override
  String get tasksPending => 'Күтүүдө';

  @override
  String get tasksInProgress => 'Аткарылууда';

  @override
  String get tasksDone => 'Аяктады';

  @override
  String get tasksNew => 'Жаңы тапшырма';

  @override
  String get tasksName => 'Аты';

  @override
  String get tasksDescription => 'Сүрөттөмө';

  @override
  String get tasksNameHint => 'Мисалы: Бөлмөнү тазалоо';

  @override
  String get tasksDescHint => 'Эмнени аткаруу керек?';

  @override
  String get tasksAssignEmployee => 'Кызматкерди дайындоо';

  @override
  String get tasksAttachRoom => 'Бөлмөгө байлоо';

  @override
  String get tasksUnattached => 'Байлоосуз';

  @override
  String get tasksUnassigned => 'Дайындалган жок';

  @override
  String get tasksCreate => 'Түзүү';

  @override
  String get tasksCancel => 'Жокко чыгаруу';

  @override
  String get tasksErrorRooms => 'Бөлмөлөрдү жүктөөдө ката';

  @override
  String get tasksErrorStaff => 'Персоналды жүктөөдө ката';

  @override
  String tasksError(String error) {
    return 'Ката: $error';
  }

  @override
  String get tasksTakeButton => 'АТКАРУУГА АЛУУ';

  @override
  String get tasksCompleteButton => 'АЯКТОО';

  @override
  String get tasksNoTasksToday => 'Бүгүн тапшырмалар жок!';

  @override
  String get tasksWellDone => 'Сиз жакшы иштедиңиз.';

  @override
  String get tasksLoginRequired => 'Системага кириңиз';

  @override
  String get tasksCommonArea => 'Жалпы аймак';

  @override
  String tasksRoomLabel(String name) {
    return 'Бөлмө № $name';
  }

  @override
  String get newsCreateTitle => 'Жаңылык түзүү';

  @override
  String get newsCreateHeadline => 'Аталышы';

  @override
  String get newsCreateEnterHeadline => 'Аталышты киргизиңиз!';

  @override
  String get newsCreateAudience => 'Жаңылыкты ким көрөт:';

  @override
  String get newsCreateAudienceAll => 'Баарына';

  @override
  String get newsCreateAudienceGuests => 'Коноктор';

  @override
  String get newsCreateAudienceStaff => 'Персонал';

  @override
  String newsCreateSectionHint(int num) {
    return '$num бөлүмдүн тексти';
  }

  @override
  String get newsCreateAddImage => 'Сүрөт кошуу';

  @override
  String get newsCreateNoContent => 'Жок дегенде бир аз текст же сүрөт кошуңуз';

  @override
  String get newsCreateSuccess => 'Жаңылык ийгиликтүү жарыяланды! 🎉';

  @override
  String newsCreateError(String error) {
    return 'Ката: $error';
  }

  @override
  String get newsCreatePublish => 'Жарыялоо';

  @override
  String get newsCreateImageSizeError =>
      'ПК үчүн сүрөттүн өлчөмү 250 кБ дан ашпашы керек';

  @override
  String get newsManageTitle => 'Жаңылыктарды башкаруу';

  @override
  String get newsManageActive => 'Активдүү';

  @override
  String get newsManageArchive => 'Архив';

  @override
  String get newsManageActiveEmpty => 'Активдүү жаңылыктар жок';

  @override
  String get newsManageArchiveEmpty => 'Архив бош';

  @override
  String get newsManageCreate => 'Түзүү';

  @override
  String get newsManageDelete => 'Өчүрүү';

  @override
  String get newsManageDeleteTitle => 'Өчүрүү';

  @override
  String get newsManageDeleteConfirm =>
      'Бул жаңылыкты биротола өчүргүңүз келеби?';

  @override
  String get newsManageCancel => 'Жокко чыгаруу';

  @override
  String newsManageError(String error) {
    return 'Ката: $error';
  }

  @override
  String get newsManageCreateHint =>
      'Менюдагы же FAB \"Түзүү\" баскычын колдонуңуз';

  @override
  String get cancel => 'Жокко чыгаруу';

  @override
  String get confirm => 'Ырастоо';

  @override
  String get save => 'Сактоо';

  @override
  String get close => 'Жабуу';

  @override
  String get delete => 'Өчүрүү';

  @override
  String get error => 'Ката';

  @override
  String get ok => 'ОК';
}
