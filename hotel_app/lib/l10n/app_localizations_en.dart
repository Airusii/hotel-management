// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Manas Hotel';

  @override
  String get navHome => 'Home';

  @override
  String get navServices => 'Services';

  @override
  String get navProfile => 'Profile';

  @override
  String get navLogin => 'Login';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navAdmin => 'Admin';

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get errorLoading => 'Loading error';

  @override
  String errorLoadingData(String error) {
    return 'Error loading data: $error';
  }

  @override
  String get errorAuth => 'Authorization error';

  @override
  String get errorRole => 'Role error';

  @override
  String get loading => 'Loading...';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginFillFields => 'Please fill in all fields';

  @override
  String get loginSignInToAccount => 'Sign in to your account';

  @override
  String get loginUserNotFound => 'User not found';

  @override
  String get loginWrongPassword => 'Wrong password';

  @override
  String get loginEmailInUse => 'This email is already registered';

  @override
  String get loginWeakPassword => 'Password is too weak';

  @override
  String get registerTitle => 'Registration';

  @override
  String get registerName => 'Your name';

  @override
  String get registerButton => 'Register';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileUser => 'User';

  @override
  String get profileMyActions => 'My Actions';

  @override
  String get profileBookings => 'Bookings';

  @override
  String get profileMyReviews => 'My Reviews';

  @override
  String get profileFaq => 'Help & FAQ';

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileSignOutConfirmTitle => 'Sign Out';

  @override
  String get profileSignOutConfirmBody => 'Are you sure you want to sign out?';

  @override
  String get profileRoleAdmin => 'Administrator';

  @override
  String get profileRoleEmployee => 'Employee';

  @override
  String get profileRoleClient => 'Client';

  @override
  String get profileSettingsTitle => 'Profile Settings';

  @override
  String get profileSettingsChooseAvatar => 'Choose Avatar';

  @override
  String get profileSettingsYourName => 'Your name';

  @override
  String get profileSettingsSave => 'Save changes';

  @override
  String get profileSettingsNameEmpty => 'Name cannot be empty';

  @override
  String get profileSettingsUpdated => 'Profile updated successfully!';

  @override
  String profileSettingsCooldown(int hours) {
    return 'Profile update available in $hours h.';
  }

  @override
  String get profileSettingsSecurity => 'Security';

  @override
  String get profileSettingsChangePassword => 'Change password';

  @override
  String get profileSettingsPasswordEmailSent =>
      'Password reset link sent to your email';

  @override
  String get myBookingsTitle => 'My Bookings';

  @override
  String get myBookingsEmpty => 'You have no bookings yet';

  @override
  String get myBookingsLoginRequired => 'Please log in';

  @override
  String get myBookingsErrorRooms => 'Error loading room data';

  @override
  String get myBookingsRoomDeleted => 'Room deleted';

  @override
  String myBookingsRoomLabel(String name) {
    return 'Room: $name';
  }

  @override
  String myBookingsGuestName(String name) {
    return 'Guest: $name';
  }

  @override
  String get myBookingsExpressCheckout => 'Express Checkout';

  @override
  String get myBookingsCheckoutDialogTitle => 'Check Out';

  @override
  String myBookingsCheckoutDialogBody(String name) {
    return 'Are you sure you want to end your stay in room $name?';
  }

  @override
  String get myBookingsConfirmCheckout => 'Confirm checkout';

  @override
  String get homeSearchDates => 'Select stay dates';

  @override
  String get homeRoomType => 'Room type';

  @override
  String get homeAllTypes => 'All types';

  @override
  String get homeNoRooms => 'Sorry, no available rooms for these dates';

  @override
  String get homeOrderServices => 'Order in-room services';

  @override
  String get homeErrorTypes => 'Error loading types';

  @override
  String get homeProfile => 'Profile';

  @override
  String get homeNew => 'New';

  @override
  String get roomDetailsPerNight => 'per night';

  @override
  String get roomDetailsDescription => 'Description';

  @override
  String get roomDetailsDescriptionText =>
      'Cozy room with all amenities for a comfortable stay. We guarantee high-quality service and cleanliness.';

  @override
  String get roomDetailsAmenities => 'Amenities';

  @override
  String get roomDetailsAc => 'Air Conditioning';

  @override
  String get roomDetailsCoffeeMaker => 'Coffee Maker';

  @override
  String get roomDetailsBook => 'Book Room';

  @override
  String get roomDetailsSelectDates => 'Select stay dates';

  @override
  String get roomDetailsGuestName => 'Your name';

  @override
  String get roomDetailsGuestEmail => 'Email';

  @override
  String get roomDetailsEnterName => 'Enter name';

  @override
  String get roomDetailsEnterEmail => 'Enter email';

  @override
  String roomDetailsTotalNights(int nights) {
    return 'Total for $nights nights:';
  }

  @override
  String get roomDetailsBookButton => 'BOOK NOW';

  @override
  String get roomDetailsReviews => 'Guest Reviews';

  @override
  String get roomDetailsNoReviews => 'No reviews yet. Be the first!';

  @override
  String roomDetailsErrorReviews(String error) {
    return 'Error loading reviews: $error';
  }

  @override
  String get roomDetailsDatesOccupied =>
      'Selected period contains already occupied dates';

  @override
  String get roomDetailsFillFields =>
      'Please select dates and fill in the fields';

  @override
  String get roomDetailsDatesUnavailable => 'Error: dates are already taken';

  @override
  String get roomDetailsBookingSuccess =>
      'Booking request sent! Awaiting confirmation.';

  @override
  String roomDetailsBookingError(String error) {
    return 'Booking error: $error';
  }

  @override
  String get roomDetailsErrorCalendar => 'Error loading calendar';

  @override
  String get servicesTitle => 'Order Services';

  @override
  String get servicesEmpty => 'No services available';

  @override
  String servicesErrorLoading(String error) {
    return 'Error loading services: $error';
  }

  @override
  String get servicesOrder => 'Order';

  @override
  String get servicesConfirmTitle => 'Confirm Order';

  @override
  String servicesConfirmBody(String name, String price) {
    return 'You want to order \"$name\" for \$$price charged to your room?';
  }

  @override
  String get servicesCancel => 'Cancel';

  @override
  String get servicesConfirm => 'Confirm';

  @override
  String get servicesOrdered =>
      'Service ordered! Staff will contact you shortly.';

  @override
  String get activeStayTitle => 'My Room';

  @override
  String get activeStayLoginRequired => 'Please log in';

  @override
  String get activeStayNoActive => 'You have no active stay';

  @override
  String get activeStayNoActiveDesc =>
      'Check in to the hotel to manage your room and order services.';

  @override
  String get activeStayRoomServices => 'In-room Services';

  @override
  String get activeStayNoServices => 'No services available.';

  @override
  String get activeStayCheckout => 'Check-out:';

  @override
  String get activeStayCheckin => 'Check-in:';

  @override
  String get activeStayTotal => 'Total Amount:';

  @override
  String get activeStayWifi => 'Wi-Fi Password:';

  @override
  String get activeStaySelectStay => 'Select stay to view';

  @override
  String get activeStayStatusActive => 'Active';

  @override
  String get activeStayStatusUpcoming => 'Upcoming';

  @override
  String activeStayOrderTitle(String name) {
    return 'Order: $name';
  }

  @override
  String activeStayOrderDesc(String room) {
    return 'Ordered from room #$room';
  }

  @override
  String get activeStayOrderAccepted => 'Order accepted!';

  @override
  String activeStayOrderDelivery(String name) {
    return 'We will bring \"$name\" within 15 minutes to your room.';
  }

  @override
  String get activeStayOrderOk => 'GREAT';

  @override
  String activeStayOrderError(String error) {
    return 'Error placing order: $error';
  }

  @override
  String get activeStayErrorRooms => 'Room error';

  @override
  String get activeStayRoomNotFound => 'Room not found';

  @override
  String activeStayRoomLabel(String name) {
    return 'Room $name';
  }

  @override
  String get faqTitle => 'FAQ';

  @override
  String get faqEmpty => 'No questions answered yet.';

  @override
  String get faqAnswerSoon => 'Answer coming soon...';

  @override
  String get faqAskQuestion => 'Ask a question';

  @override
  String get faqAskDialogTitle => 'Ask a Question';

  @override
  String get faqAskHint => 'Enter your question...';

  @override
  String get faqCancel => 'Cancel';

  @override
  String get faqSend => 'Send';

  @override
  String get faqGuest => 'Guest';

  @override
  String get faqSent => 'Question sent! We will reply shortly.';

  @override
  String faqErrorLoading(String error) {
    return 'Error loading: $error';
  }

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'You have no new notifications';

  @override
  String get notificationsClose => 'Close';

  @override
  String get notificationBookingConfirmed => 'Booking confirmed';

  @override
  String get notificationBookingConfirmedBody =>
      'Your booking for room #302 has been confirmed. We look forward to seeing you!';

  @override
  String get notificationWelcome => 'Welcome!';

  @override
  String get notificationWelcomeBody =>
      'Thank you for choosing Manas Hotel. Enjoy your stay!';

  @override
  String get notificationCleaningDone => 'Cleaning completed';

  @override
  String get notificationCleaningDoneBody =>
      'Your room has been fully cleaned and disinfected.';

  @override
  String get newsTitle => 'Latest News';

  @override
  String get newsErrorLoading => 'Error loading news';

  @override
  String get newsDialogTitle => 'News';

  @override
  String get adminDashboardTitle => 'Admin';

  @override
  String get adminOverview => 'Hotel Overview';

  @override
  String get adminBookings => 'Bookings';

  @override
  String get adminCalendar => 'Calendar';

  @override
  String get adminNewRequests => 'New Requests';

  @override
  String get adminCreateBooking => 'Create Booking';

  @override
  String get adminBookingHistory => 'Booking History';

  @override
  String get adminNews => 'News';

  @override
  String get adminCreateNews => 'Create Post';

  @override
  String get adminActiveNews => 'Active Posts';

  @override
  String get adminArchiveNews => 'Archive';

  @override
  String get adminRooms => 'Rooms';

  @override
  String get adminServices => 'Services';

  @override
  String get adminEmployees => 'Staff';

  @override
  String get adminFaq => 'FAQ';

  @override
  String get adminStatsNewRequests => 'New Requests';

  @override
  String get adminStatsMonthlyRevenue => 'Monthly Revenue';

  @override
  String get adminStatsUpcomingCheckIns => 'Upcoming Check-ins';

  @override
  String get adminStatsTotalBookings => 'Total Bookings';

  @override
  String get adminStatsPending => 'Pending';

  @override
  String get adminStatsAvailable => 'Available';

  @override
  String get adminStatsRevenue => 'Revenue';

  @override
  String get adminCalendarTitle => 'Calendar (Live)';

  @override
  String get adminCalendarRoomDates => 'Rooms \\ Dates';

  @override
  String get adminCalendarSelectBooking =>
      'Select a booking on the calendar\nto see details';

  @override
  String get adminCalendarBooking => 'Booking';

  @override
  String get adminCalendarConfirmed => 'Confirmed';

  @override
  String get adminCalendarPending => 'Pending';

  @override
  String adminCalendarGuest(String name) {
    return 'Guest: $name';
  }

  @override
  String get adminCalendarCheckIn => 'Check-in';

  @override
  String get adminCalendarCheckOut => 'Check-out';

  @override
  String get adminCalendarTotal => 'Total';

  @override
  String get adminCalendarConfirmButton => 'Confirm';

  @override
  String get adminCalendarCancelButton => 'Cancel';

  @override
  String get adminCalendarCheckOutButton => 'Process Check-out';

  @override
  String get adminCalendarEditButton => 'Edit';

  @override
  String get adminCalendarInvoice => 'Invoice';

  @override
  String adminCalendarCleaningTitle(String name) {
    return 'Cleaning after checkout: # $name';
  }

  @override
  String get adminCalendarCleaningDesc =>
      'Guest checked out. Full room cleaning, linen change and minibar inspection required.';

  @override
  String get adminCalendarCheckoutDone =>
      'Check-out processed. Cleaning task sent.';

  @override
  String adminCalendarCheckoutError(String error) {
    return 'Error processing check-out: $error';
  }

  @override
  String get adminCalendarBookingConfirmed => 'Booking confirmed!';

  @override
  String get adminCalendarBookingCancelled => 'Booking cancelled.';

  @override
  String adminCalendarUpdateError(String error) {
    return 'Update error: $error';
  }

  @override
  String adminCalendarGuestShort(String id) {
    return 'Guest $id';
  }

  @override
  String adminCalendarErrorRooms(String error) {
    return 'Error loading rooms: $error';
  }

  @override
  String adminCalendarErrorBookings(String error) {
    return 'Error loading bookings: $error';
  }

  @override
  String get adminRequestsTitle => 'New Requests';

  @override
  String get adminRequestsEmpty => 'No new requests';

  @override
  String get adminRequestsErrorLoading => 'Error loading requests';

  @override
  String adminRequestsErrorRooms(String error) {
    return 'Error loading rooms: $error';
  }

  @override
  String adminRequestsRoomLabel(String name, String type) {
    return 'Room: $name ($type)';
  }

  @override
  String get adminRequestsRejectTitle => 'Reject Request?';

  @override
  String get adminRequestsRejectBody =>
      'The request will be cancelled. The guest will be notified (if configured).';

  @override
  String get adminRequestsRejectButton => 'Reject';

  @override
  String get adminRequestsRejected => 'Request rejected';

  @override
  String get adminRequestsConfirm => 'Confirm';

  @override
  String get adminRequestsBack => 'Back';

  @override
  String adminRequestsError(String error) {
    return 'Error: $error';
  }

  @override
  String get adminRequestsIndexHint =>
      'You may need to create a composite index in Firebase Console:\nCollection \"bookings\" → fields: status (Ascending) + createdAt (Descending)';

  @override
  String adminRequestsDetails(String error) {
    return 'Details: $error';
  }

  @override
  String get adminRoomsTitle => 'Rooms Management';

  @override
  String get adminRoomsAddDialog => 'Add Room';

  @override
  String get adminRoomsNameLabel => 'Name/Number';

  @override
  String get adminRoomsPriceLabel => 'Price per night';

  @override
  String get adminRoomsTypeLabel => 'Room type';

  @override
  String get adminRoomsSelectType => 'Select type';

  @override
  String get adminRoomsServices => 'Available services:';

  @override
  String get adminRoomsEnterName => 'Enter name';

  @override
  String get adminRoomsEnterPrice => 'Enter price';

  @override
  String get adminRoomsSelectTypeHint => 'Select room type';

  @override
  String get adminRoomsErrorTypes => 'Error loading types';

  @override
  String get adminRoomsCreate => 'Create';

  @override
  String get adminRoomsCancel => 'Cancel';

  @override
  String get adminServicesTitle => 'Hotel Services';

  @override
  String get adminServicesAddDialog => 'Add Service';

  @override
  String get adminServicesCancel => 'Cancel';

  @override
  String get adminServicesSave => 'Save';

  @override
  String get adminEmployeesTitle => 'Staff Management';

  @override
  String get adminEmployeesEmpty => 'No employees yet';

  @override
  String get adminEmployeesErrorLoading => 'Error loading';

  @override
  String get adminEmployeesNoName => 'No name';

  @override
  String get adminEmployeesAddDialog => 'Add Employee';

  @override
  String get adminEmployeesName => 'Name';

  @override
  String get adminEmployeesEmail => 'Email';

  @override
  String get adminEmployeesNickname => 'Nickname';

  @override
  String get adminEmployeesPassword => 'Password';

  @override
  String get adminEmployeesEnterName => 'Enter name';

  @override
  String get adminEmployeesEnterEmail => 'Enter email';

  @override
  String get adminEmployeesEnterNickname => 'Enter nickname';

  @override
  String get adminEmployeesInvalidEmail => 'Invalid email';

  @override
  String get adminEmployeesMinPassword => 'Minimum 6 characters';

  @override
  String get adminEmployeesWeakPassword => 'Password is too weak';

  @override
  String get adminEmployeesEmailInUse => 'This email is already in use';

  @override
  String get adminEmployeesRegisterError => 'An error occurred';

  @override
  String get adminEmployeesRegistered => 'Employee registered successfully';

  @override
  String adminEmployeesError(String error) {
    return 'Error: $error';
  }

  @override
  String get adminEmployeesRegister => 'Register';

  @override
  String get adminEmployeesCancel => 'Cancel';

  @override
  String get adminFaqTitle => 'FAQ Management';

  @override
  String get adminFaqAllQuestions => 'All Questions';

  @override
  String get adminFaqUnanswered => 'Unanswered';

  @override
  String get adminFaqCreateTitle => 'Create FAQ';

  @override
  String adminFaqErrorLoading(String error) {
    return 'Error: $error';
  }

  @override
  String get adminBookingDialogTitle => 'New Booking (Admin)';

  @override
  String get adminBookingSelectDates => 'Select check-in and check-out dates';

  @override
  String get adminBookingRoom => 'Room';

  @override
  String get adminBookingGuestName => 'Guest name';

  @override
  String get adminBookingRequired => 'Required field';

  @override
  String adminBookingTotal(String price) {
    return 'Total: \$$price';
  }

  @override
  String get adminBookingFillFields => 'Fill in all fields';

  @override
  String get adminBookingSave => 'Save';

  @override
  String get adminBookingCancel => 'Cancel';

  @override
  String adminBookingError(String error) {
    return 'Error: $error';
  }

  @override
  String get adminBookingNoName => 'No name';

  @override
  String get bookingActionPending =>
      'Request awaiting confirmation. Please confirm or reject.';

  @override
  String get bookingActionConfirmed =>
      'Booking confirmed. Has the guest arrived? Click «Check In».';

  @override
  String get bookingActionCheckedIn =>
      'Guest is staying. Process check-out to send room for cleaning.';

  @override
  String get bookingActionCheckedOut =>
      'Guest has checked out. Actions unavailable.';

  @override
  String get bookingActionCancelled => 'Booking cancelled.';

  @override
  String get bookingActionConfirmButton => 'Confirm';

  @override
  String get bookingActionRejectButton => 'Reject';

  @override
  String get bookingActionCheckinButton => 'Check In';

  @override
  String get bookingActionCheckoutButton => 'Process Check-out';

  @override
  String get bookingActionClose => 'Close';

  @override
  String bookingActionError(String error) {
    return 'Error: $error';
  }

  @override
  String get bookingStatusCheckedIn => 'Checked in';

  @override
  String get bookingStatusCheckedOut => 'Checked out';

  @override
  String get bookingStatusCancelled => 'Cancelled';

  @override
  String get tasksTitle => 'Tasks';

  @override
  String get tasksMyTasksTitle => 'My Tasks';

  @override
  String get tasksPending => 'Pending';

  @override
  String get tasksInProgress => 'In Progress';

  @override
  String get tasksDone => 'Done';

  @override
  String get tasksNew => 'New Task';

  @override
  String get tasksName => 'Name';

  @override
  String get tasksDescription => 'Description';

  @override
  String get tasksNameHint => 'E.g.: Room Cleaning';

  @override
  String get tasksDescHint => 'What needs to be done?';

  @override
  String get tasksAssignEmployee => 'Assign Employee';

  @override
  String get tasksAttachRoom => 'Attach to Room';

  @override
  String get tasksUnattached => 'Unattached';

  @override
  String get tasksUnassigned => 'Unassigned';

  @override
  String get tasksCreate => 'Create';

  @override
  String get tasksCancel => 'Cancel';

  @override
  String get tasksErrorRooms => 'Error loading rooms';

  @override
  String get tasksErrorStaff => 'Error loading staff';

  @override
  String tasksError(String error) {
    return 'Error: $error';
  }

  @override
  String get tasksTakeButton => 'TAKE TASK';

  @override
  String get tasksCompleteButton => 'COMPLETE';

  @override
  String get tasksNoTasksToday => 'No tasks for today!';

  @override
  String get tasksWellDone => 'You did great.';

  @override
  String get tasksLoginRequired => 'Please log in';

  @override
  String get tasksCommonArea => 'Common Area';

  @override
  String tasksRoomLabel(String name) {
    return 'Room # $name';
  }

  @override
  String get newsCreateTitle => 'Create Post';

  @override
  String get newsCreateHeadline => 'Headline';

  @override
  String get newsCreateEnterHeadline => 'Enter headline!';

  @override
  String get newsCreateAudience => 'Who sees the post:';

  @override
  String get newsCreateAudienceAll => 'Everyone';

  @override
  String get newsCreateAudienceGuests => 'Guests';

  @override
  String get newsCreateAudienceStaff => 'Staff';

  @override
  String newsCreateSectionHint(int num) {
    return 'Section $num text';
  }

  @override
  String get newsCreateAddImage => 'Add image';

  @override
  String get newsCreateNoContent => 'Add at least some text or an image';

  @override
  String get newsCreateSuccess => 'News published successfully! 🎉';

  @override
  String newsCreateError(String error) {
    return 'Error: $error';
  }

  @override
  String get newsCreatePublish => 'Publish';

  @override
  String get newsCreateImageSizeError =>
      'Desktop image size must not exceed 250 KB';

  @override
  String get newsManageTitle => 'News Management';

  @override
  String get newsManageActive => 'Active';

  @override
  String get newsManageArchive => 'Archive';

  @override
  String get newsManageActiveEmpty => 'No active news';

  @override
  String get newsManageArchiveEmpty => 'Archive is empty';

  @override
  String get newsManageCreate => 'Create';

  @override
  String get newsManageDelete => 'Delete';

  @override
  String get newsManageDeleteTitle => 'Delete';

  @override
  String get newsManageDeleteConfirm =>
      'Are you sure you want to delete this post permanently?';

  @override
  String get newsManageCancel => 'Cancel';

  @override
  String newsManageError(String error) {
    return 'Error: $error';
  }

  @override
  String get newsManageCreateHint =>
      'Use the \"Create\" button in the menu or FAB';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get delete => 'Delete';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';
}
