import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_ru.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
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
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Manas Hotel'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get navLogin;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get navAdmin;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorGeneric(String error);

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading error'**
  String get errorLoading;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data: {error}'**
  String errorLoadingData(String error);

  /// No description provided for @errorAuth.
  ///
  /// In en, this message translates to:
  /// **'Authorization error'**
  String get errorAuth;

  /// No description provided for @errorRole.
  ///
  /// In en, this message translates to:
  /// **'Role error'**
  String get errorRole;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginTitle;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginFillFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get loginFillFields;

  /// No description provided for @loginSignInToAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get loginSignInToAccount;

  /// No description provided for @loginUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get loginUserNotFound;

  /// No description provided for @loginWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get loginWrongPassword;

  /// No description provided for @loginEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get loginEmailInUse;

  /// No description provided for @loginWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get loginWeakPassword;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registerTitle;

  /// No description provided for @registerName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get registerName;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get profileUser;

  /// No description provided for @profileMyActions.
  ///
  /// In en, this message translates to:
  /// **'My Actions'**
  String get profileMyActions;

  /// No description provided for @profileBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get profileBookings;

  /// No description provided for @profileMyReviews.
  ///
  /// In en, this message translates to:
  /// **'My Reviews'**
  String get profileMyReviews;

  /// No description provided for @profileFaq.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get profileFaq;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @profileSignOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profileSignOutConfirmTitle;

  /// No description provided for @profileSignOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get profileSignOutConfirmBody;

  /// No description provided for @profileRoleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get profileRoleAdmin;

  /// No description provided for @profileRoleEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get profileRoleEmployee;

  /// No description provided for @profileRoleClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get profileRoleClient;

  /// No description provided for @profileSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettingsTitle;

  /// No description provided for @profileSettingsChooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose Avatar'**
  String get profileSettingsChooseAvatar;

  /// No description provided for @profileSettingsYourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get profileSettingsYourName;

  /// No description provided for @profileSettingsSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileSettingsSave;

  /// No description provided for @profileSettingsNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get profileSettingsNameEmpty;

  /// No description provided for @profileSettingsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileSettingsUpdated;

  /// No description provided for @profileSettingsCooldown.
  ///
  /// In en, this message translates to:
  /// **'Profile update available in {hours} h.'**
  String profileSettingsCooldown(int hours);

  /// No description provided for @profileSettingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profileSettingsSecurity;

  /// No description provided for @profileSettingsChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profileSettingsChangePassword;

  /// No description provided for @profileSettingsPasswordEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email'**
  String get profileSettingsPasswordEmailSent;

  /// No description provided for @myBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookingsTitle;

  /// No description provided for @myBookingsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no bookings yet'**
  String get myBookingsEmpty;

  /// No description provided for @myBookingsLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in'**
  String get myBookingsLoginRequired;

  /// No description provided for @myBookingsErrorRooms.
  ///
  /// In en, this message translates to:
  /// **'Error loading room data'**
  String get myBookingsErrorRooms;

  /// No description provided for @myBookingsRoomDeleted.
  ///
  /// In en, this message translates to:
  /// **'Room deleted'**
  String get myBookingsRoomDeleted;

  /// No description provided for @myBookingsRoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Room: {name}'**
  String myBookingsRoomLabel(String name);

  /// No description provided for @myBookingsGuestName.
  ///
  /// In en, this message translates to:
  /// **'Guest: {name}'**
  String myBookingsGuestName(String name);

  /// No description provided for @myBookingsExpressCheckout.
  ///
  /// In en, this message translates to:
  /// **'Express Checkout'**
  String get myBookingsExpressCheckout;

  /// No description provided for @myBookingsCheckoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get myBookingsCheckoutDialogTitle;

  /// No description provided for @myBookingsCheckoutDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to end your stay in room {name}?'**
  String myBookingsCheckoutDialogBody(String name);

  /// No description provided for @myBookingsConfirmCheckout.
  ///
  /// In en, this message translates to:
  /// **'Confirm checkout'**
  String get myBookingsConfirmCheckout;

  /// No description provided for @homeSearchDates.
  ///
  /// In en, this message translates to:
  /// **'Select stay dates'**
  String get homeSearchDates;

  /// No description provided for @homeRoomType.
  ///
  /// In en, this message translates to:
  /// **'Room type'**
  String get homeRoomType;

  /// No description provided for @homeAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get homeAllTypes;

  /// No description provided for @homeNoRooms.
  ///
  /// In en, this message translates to:
  /// **'Sorry, no available rooms for these dates'**
  String get homeNoRooms;

  /// No description provided for @homeOrderServices.
  ///
  /// In en, this message translates to:
  /// **'Order in-room services'**
  String get homeOrderServices;

  /// No description provided for @homeErrorTypes.
  ///
  /// In en, this message translates to:
  /// **'Error loading types'**
  String get homeErrorTypes;

  /// No description provided for @homeProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeProfile;

  /// No description provided for @homeNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get homeNew;

  /// No description provided for @roomDetailsPerNight.
  ///
  /// In en, this message translates to:
  /// **'per night'**
  String get roomDetailsPerNight;

  /// No description provided for @roomDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get roomDetailsDescription;

  /// No description provided for @roomDetailsDescriptionText.
  ///
  /// In en, this message translates to:
  /// **'Cozy room with all amenities for a comfortable stay. We guarantee high-quality service and cleanliness.'**
  String get roomDetailsDescriptionText;

  /// No description provided for @roomDetailsAmenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get roomDetailsAmenities;

  /// No description provided for @roomDetailsAc.
  ///
  /// In en, this message translates to:
  /// **'Air Conditioning'**
  String get roomDetailsAc;

  /// No description provided for @roomDetailsCoffeeMaker.
  ///
  /// In en, this message translates to:
  /// **'Coffee Maker'**
  String get roomDetailsCoffeeMaker;

  /// No description provided for @roomDetailsBook.
  ///
  /// In en, this message translates to:
  /// **'Book Room'**
  String get roomDetailsBook;

  /// No description provided for @roomDetailsSelectDates.
  ///
  /// In en, this message translates to:
  /// **'Select stay dates'**
  String get roomDetailsSelectDates;

  /// No description provided for @roomDetailsGuestName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get roomDetailsGuestName;

  /// No description provided for @roomDetailsGuestEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get roomDetailsGuestEmail;

  /// No description provided for @roomDetailsEnterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get roomDetailsEnterName;

  /// No description provided for @roomDetailsEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get roomDetailsEnterEmail;

  /// No description provided for @roomDetailsTotalNights.
  ///
  /// In en, this message translates to:
  /// **'Total for {nights} nights:'**
  String roomDetailsTotalNights(int nights);

  /// No description provided for @roomDetailsBookButton.
  ///
  /// In en, this message translates to:
  /// **'BOOK NOW'**
  String get roomDetailsBookButton;

  /// No description provided for @roomDetailsReviews.
  ///
  /// In en, this message translates to:
  /// **'Guest Reviews'**
  String get roomDetailsReviews;

  /// No description provided for @roomDetailsNoReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet. Be the first!'**
  String get roomDetailsNoReviews;

  /// No description provided for @roomDetailsErrorReviews.
  ///
  /// In en, this message translates to:
  /// **'Error loading reviews: {error}'**
  String roomDetailsErrorReviews(String error);

  /// No description provided for @roomDetailsDatesOccupied.
  ///
  /// In en, this message translates to:
  /// **'Selected period contains already occupied dates'**
  String get roomDetailsDatesOccupied;

  /// No description provided for @roomDetailsFillFields.
  ///
  /// In en, this message translates to:
  /// **'Please select dates and fill in the fields'**
  String get roomDetailsFillFields;

  /// No description provided for @roomDetailsDatesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Error: dates are already taken'**
  String get roomDetailsDatesUnavailable;

  /// No description provided for @roomDetailsBookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking request sent! Awaiting confirmation.'**
  String get roomDetailsBookingSuccess;

  /// No description provided for @roomDetailsBookingError.
  ///
  /// In en, this message translates to:
  /// **'Booking error: {error}'**
  String roomDetailsBookingError(String error);

  /// No description provided for @roomDetailsErrorCalendar.
  ///
  /// In en, this message translates to:
  /// **'Error loading calendar'**
  String get roomDetailsErrorCalendar;

  /// No description provided for @servicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Services'**
  String get servicesTitle;

  /// No description provided for @servicesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No services available'**
  String get servicesEmpty;

  /// No description provided for @servicesErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading services: {error}'**
  String servicesErrorLoading(String error);

  /// No description provided for @servicesOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get servicesOrder;

  /// No description provided for @servicesConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get servicesConfirmTitle;

  /// No description provided for @servicesConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You want to order \"{name}\" for \${price} charged to your room?'**
  String servicesConfirmBody(String name, String price);

  /// No description provided for @servicesCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get servicesCancel;

  /// No description provided for @servicesConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get servicesConfirm;

  /// No description provided for @servicesOrdered.
  ///
  /// In en, this message translates to:
  /// **'Service ordered! Staff will contact you shortly.'**
  String get servicesOrdered;

  /// No description provided for @activeStayTitle.
  ///
  /// In en, this message translates to:
  /// **'My Room'**
  String get activeStayTitle;

  /// No description provided for @activeStayLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in'**
  String get activeStayLoginRequired;

  /// No description provided for @activeStayNoActive.
  ///
  /// In en, this message translates to:
  /// **'You have no active stay'**
  String get activeStayNoActive;

  /// No description provided for @activeStayNoActiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Check in to the hotel to manage your room and order services.'**
  String get activeStayNoActiveDesc;

  /// No description provided for @activeStayRoomServices.
  ///
  /// In en, this message translates to:
  /// **'In-room Services'**
  String get activeStayRoomServices;

  /// No description provided for @activeStayNoServices.
  ///
  /// In en, this message translates to:
  /// **'No services available.'**
  String get activeStayNoServices;

  /// No description provided for @activeStayCheckout.
  ///
  /// In en, this message translates to:
  /// **'Check-out:'**
  String get activeStayCheckout;

  /// No description provided for @activeStayOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Order: {name}'**
  String activeStayOrderTitle(String name);

  /// No description provided for @activeStayOrderDesc.
  ///
  /// In en, this message translates to:
  /// **'Ordered from room #{room}'**
  String activeStayOrderDesc(String room);

  /// No description provided for @activeStayOrderAccepted.
  ///
  /// In en, this message translates to:
  /// **'Order accepted!'**
  String get activeStayOrderAccepted;

  /// No description provided for @activeStayOrderDelivery.
  ///
  /// In en, this message translates to:
  /// **'We will bring \"{name}\" within 15 minutes to your room.'**
  String activeStayOrderDelivery(String name);

  /// No description provided for @activeStayOrderOk.
  ///
  /// In en, this message translates to:
  /// **'GREAT'**
  String get activeStayOrderOk;

  /// No description provided for @activeStayOrderError.
  ///
  /// In en, this message translates to:
  /// **'Error placing order: {error}'**
  String activeStayOrderError(String error);

  /// No description provided for @activeStayErrorRooms.
  ///
  /// In en, this message translates to:
  /// **'Room error'**
  String get activeStayErrorRooms;

  /// No description provided for @activeStayRoomNotFound.
  ///
  /// In en, this message translates to:
  /// **'Room not found'**
  String get activeStayRoomNotFound;

  /// No description provided for @activeStayRoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Room {name}'**
  String activeStayRoomLabel(String name);

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faqTitle;

  /// No description provided for @faqEmpty.
  ///
  /// In en, this message translates to:
  /// **'No questions answered yet.'**
  String get faqEmpty;

  /// No description provided for @faqAnswerSoon.
  ///
  /// In en, this message translates to:
  /// **'Answer coming soon...'**
  String get faqAnswerSoon;

  /// No description provided for @faqAskQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get faqAskQuestion;

  /// No description provided for @faqAskDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask a Question'**
  String get faqAskDialogTitle;

  /// No description provided for @faqAskHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your question...'**
  String get faqAskHint;

  /// No description provided for @faqCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get faqCancel;

  /// No description provided for @faqSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get faqSend;

  /// No description provided for @faqGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get faqGuest;

  /// No description provided for @faqSent.
  ///
  /// In en, this message translates to:
  /// **'Question sent! We will reply shortly.'**
  String get faqSent;

  /// No description provided for @faqErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading: {error}'**
  String faqErrorLoading(String error);

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no new notifications'**
  String get notificationsEmpty;

  /// No description provided for @notificationsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get notificationsClose;

  /// No description provided for @notificationBookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed'**
  String get notificationBookingConfirmed;

  /// No description provided for @notificationBookingConfirmedBody.
  ///
  /// In en, this message translates to:
  /// **'Your booking for room #302 has been confirmed. We look forward to seeing you!'**
  String get notificationBookingConfirmedBody;

  /// No description provided for @notificationWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get notificationWelcome;

  /// No description provided for @notificationWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Thank you for choosing Manas Hotel. Enjoy your stay!'**
  String get notificationWelcomeBody;

  /// No description provided for @notificationCleaningDone.
  ///
  /// In en, this message translates to:
  /// **'Cleaning completed'**
  String get notificationCleaningDone;

  /// No description provided for @notificationCleaningDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Your room has been fully cleaned and disinfected.'**
  String get notificationCleaningDoneBody;

  /// No description provided for @newsTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest News'**
  String get newsTitle;

  /// No description provided for @newsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading news'**
  String get newsErrorLoading;

  /// No description provided for @newsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get newsDialogTitle;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminDashboardTitle;

  /// No description provided for @adminOverview.
  ///
  /// In en, this message translates to:
  /// **'Hotel Overview'**
  String get adminOverview;

  /// No description provided for @adminBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get adminBookings;

  /// No description provided for @adminCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get adminCalendar;

  /// No description provided for @adminNewRequests.
  ///
  /// In en, this message translates to:
  /// **'New Requests'**
  String get adminNewRequests;

  /// No description provided for @adminCreateBooking.
  ///
  /// In en, this message translates to:
  /// **'Create Booking'**
  String get adminCreateBooking;

  /// No description provided for @adminBookingHistory.
  ///
  /// In en, this message translates to:
  /// **'Booking History'**
  String get adminBookingHistory;

  /// No description provided for @adminNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get adminNews;

  /// No description provided for @adminCreateNews.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get adminCreateNews;

  /// No description provided for @adminActiveNews.
  ///
  /// In en, this message translates to:
  /// **'Active Posts'**
  String get adminActiveNews;

  /// No description provided for @adminArchiveNews.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get adminArchiveNews;

  /// No description provided for @adminRooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get adminRooms;

  /// No description provided for @adminServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get adminServices;

  /// No description provided for @adminEmployees.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get adminEmployees;

  /// No description provided for @adminFaq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get adminFaq;

  /// No description provided for @adminStatsNewRequests.
  ///
  /// In en, this message translates to:
  /// **'New Requests'**
  String get adminStatsNewRequests;

  /// No description provided for @adminStatsMonthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get adminStatsMonthlyRevenue;

  /// No description provided for @adminStatsUpcomingCheckIns.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Check-ins'**
  String get adminStatsUpcomingCheckIns;

  /// No description provided for @adminStatsTotalBookings.
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get adminStatsTotalBookings;

  /// No description provided for @adminStatsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminStatsPending;

  /// No description provided for @adminStatsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get adminStatsAvailable;

  /// No description provided for @adminStatsRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get adminStatsRevenue;

  /// No description provided for @adminCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar (Live)'**
  String get adminCalendarTitle;

  /// No description provided for @adminCalendarRoomDates.
  ///
  /// In en, this message translates to:
  /// **'Rooms \\ Dates'**
  String get adminCalendarRoomDates;

  /// No description provided for @adminCalendarSelectBooking.
  ///
  /// In en, this message translates to:
  /// **'Select a booking on the calendar\nto see details'**
  String get adminCalendarSelectBooking;

  /// No description provided for @adminCalendarBooking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get adminCalendarBooking;

  /// No description provided for @adminCalendarConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get adminCalendarConfirmed;

  /// No description provided for @adminCalendarPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminCalendarPending;

  /// No description provided for @adminCalendarGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest: {name}'**
  String adminCalendarGuest(String name);

  /// No description provided for @adminCalendarCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get adminCalendarCheckIn;

  /// No description provided for @adminCalendarCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get adminCalendarCheckOut;

  /// No description provided for @adminCalendarTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get adminCalendarTotal;

  /// No description provided for @adminCalendarConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get adminCalendarConfirmButton;

  /// No description provided for @adminCalendarCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminCalendarCancelButton;

  /// No description provided for @adminCalendarCheckOutButton.
  ///
  /// In en, this message translates to:
  /// **'Process Check-out'**
  String get adminCalendarCheckOutButton;

  /// No description provided for @adminCalendarEditButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get adminCalendarEditButton;

  /// No description provided for @adminCalendarInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get adminCalendarInvoice;

  /// No description provided for @adminCalendarCleaningTitle.
  ///
  /// In en, this message translates to:
  /// **'Cleaning after checkout: # {name}'**
  String adminCalendarCleaningTitle(String name);

  /// No description provided for @adminCalendarCleaningDesc.
  ///
  /// In en, this message translates to:
  /// **'Guest checked out. Full room cleaning, linen change and minibar inspection required.'**
  String get adminCalendarCleaningDesc;

  /// No description provided for @adminCalendarCheckoutDone.
  ///
  /// In en, this message translates to:
  /// **'Check-out processed. Cleaning task sent.'**
  String get adminCalendarCheckoutDone;

  /// No description provided for @adminCalendarCheckoutError.
  ///
  /// In en, this message translates to:
  /// **'Error processing check-out: {error}'**
  String adminCalendarCheckoutError(String error);

  /// No description provided for @adminCalendarBookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed!'**
  String get adminCalendarBookingConfirmed;

  /// No description provided for @adminCalendarBookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled.'**
  String get adminCalendarBookingCancelled;

  /// No description provided for @adminCalendarUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Update error: {error}'**
  String adminCalendarUpdateError(String error);

  /// No description provided for @adminCalendarGuestShort.
  ///
  /// In en, this message translates to:
  /// **'Guest {id}'**
  String adminCalendarGuestShort(String id);

  /// No description provided for @adminCalendarErrorRooms.
  ///
  /// In en, this message translates to:
  /// **'Error loading rooms: {error}'**
  String adminCalendarErrorRooms(String error);

  /// No description provided for @adminCalendarErrorBookings.
  ///
  /// In en, this message translates to:
  /// **'Error loading bookings: {error}'**
  String adminCalendarErrorBookings(String error);

  /// No description provided for @adminRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'New Requests'**
  String get adminRequestsTitle;

  /// No description provided for @adminRequestsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No new requests'**
  String get adminRequestsEmpty;

  /// No description provided for @adminRequestsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading requests'**
  String get adminRequestsErrorLoading;

  /// No description provided for @adminRequestsErrorRooms.
  ///
  /// In en, this message translates to:
  /// **'Error loading rooms: {error}'**
  String adminRequestsErrorRooms(String error);

  /// No description provided for @adminRequestsRoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Room: {name} ({type})'**
  String adminRequestsRoomLabel(String name, String type);

  /// No description provided for @adminRequestsRejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject Request?'**
  String get adminRequestsRejectTitle;

  /// No description provided for @adminRequestsRejectBody.
  ///
  /// In en, this message translates to:
  /// **'The request will be cancelled. The guest will be notified (if configured).'**
  String get adminRequestsRejectBody;

  /// No description provided for @adminRequestsRejectButton.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get adminRequestsRejectButton;

  /// No description provided for @adminRequestsRejected.
  ///
  /// In en, this message translates to:
  /// **'Request rejected'**
  String get adminRequestsRejected;

  /// No description provided for @adminRequestsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get adminRequestsConfirm;

  /// No description provided for @adminRequestsBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get adminRequestsBack;

  /// No description provided for @adminRequestsError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String adminRequestsError(String error);

  /// No description provided for @adminRequestsIndexHint.
  ///
  /// In en, this message translates to:
  /// **'You may need to create a composite index in Firebase Console:\nCollection \"bookings\" → fields: status (Ascending) + createdAt (Descending)'**
  String get adminRequestsIndexHint;

  /// No description provided for @adminRequestsDetails.
  ///
  /// In en, this message translates to:
  /// **'Details: {error}'**
  String adminRequestsDetails(String error);

  /// No description provided for @adminRoomsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rooms Management'**
  String get adminRoomsTitle;

  /// No description provided for @adminRoomsAddDialog.
  ///
  /// In en, this message translates to:
  /// **'Add Room'**
  String get adminRoomsAddDialog;

  /// No description provided for @adminRoomsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name/Number'**
  String get adminRoomsNameLabel;

  /// No description provided for @adminRoomsPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price per night'**
  String get adminRoomsPriceLabel;

  /// No description provided for @adminRoomsTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Room type'**
  String get adminRoomsTypeLabel;

  /// No description provided for @adminRoomsSelectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get adminRoomsSelectType;

  /// No description provided for @adminRoomsServices.
  ///
  /// In en, this message translates to:
  /// **'Available services:'**
  String get adminRoomsServices;

  /// No description provided for @adminRoomsEnterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get adminRoomsEnterName;

  /// No description provided for @adminRoomsEnterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get adminRoomsEnterPrice;

  /// No description provided for @adminRoomsSelectTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select room type'**
  String get adminRoomsSelectTypeHint;

  /// No description provided for @adminRoomsErrorTypes.
  ///
  /// In en, this message translates to:
  /// **'Error loading types'**
  String get adminRoomsErrorTypes;

  /// No description provided for @adminRoomsCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get adminRoomsCreate;

  /// No description provided for @adminRoomsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminRoomsCancel;

  /// No description provided for @adminServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Hotel Services'**
  String get adminServicesTitle;

  /// No description provided for @adminServicesAddDialog.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get adminServicesAddDialog;

  /// No description provided for @adminServicesCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminServicesCancel;

  /// No description provided for @adminServicesSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get adminServicesSave;

  /// No description provided for @adminEmployeesTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff Management'**
  String get adminEmployeesTitle;

  /// No description provided for @adminEmployeesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No employees yet'**
  String get adminEmployeesEmpty;

  /// No description provided for @adminEmployeesErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading'**
  String get adminEmployeesErrorLoading;

  /// No description provided for @adminEmployeesNoName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get adminEmployeesNoName;

  /// No description provided for @adminEmployeesAddDialog.
  ///
  /// In en, this message translates to:
  /// **'Add Employee'**
  String get adminEmployeesAddDialog;

  /// No description provided for @adminEmployeesName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get adminEmployeesName;

  /// No description provided for @adminEmployeesEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get adminEmployeesEmail;

  /// No description provided for @adminEmployeesNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get adminEmployeesNickname;

  /// No description provided for @adminEmployeesPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get adminEmployeesPassword;

  /// No description provided for @adminEmployeesEnterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get adminEmployeesEnterName;

  /// No description provided for @adminEmployeesEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get adminEmployeesEnterEmail;

  /// No description provided for @adminEmployeesEnterNickname.
  ///
  /// In en, this message translates to:
  /// **'Enter nickname'**
  String get adminEmployeesEnterNickname;

  /// No description provided for @adminEmployeesInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get adminEmployeesInvalidEmail;

  /// No description provided for @adminEmployeesMinPassword.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get adminEmployeesMinPassword;

  /// No description provided for @adminEmployeesWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get adminEmployeesWeakPassword;

  /// No description provided for @adminEmployeesEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use'**
  String get adminEmployeesEmailInUse;

  /// No description provided for @adminEmployeesRegisterError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get adminEmployeesRegisterError;

  /// No description provided for @adminEmployeesRegistered.
  ///
  /// In en, this message translates to:
  /// **'Employee registered successfully'**
  String get adminEmployeesRegistered;

  /// No description provided for @adminEmployeesError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String adminEmployeesError(String error);

  /// No description provided for @adminEmployeesRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get adminEmployeesRegister;

  /// No description provided for @adminEmployeesCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminEmployeesCancel;

  /// No description provided for @adminFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'FAQ Management'**
  String get adminFaqTitle;

  /// No description provided for @adminFaqAllQuestions.
  ///
  /// In en, this message translates to:
  /// **'All Questions'**
  String get adminFaqAllQuestions;

  /// No description provided for @adminFaqUnanswered.
  ///
  /// In en, this message translates to:
  /// **'Unanswered'**
  String get adminFaqUnanswered;

  /// No description provided for @adminFaqCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create FAQ'**
  String get adminFaqCreateTitle;

  /// No description provided for @adminFaqErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String adminFaqErrorLoading(String error);

  /// No description provided for @adminBookingDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'New Booking (Admin)'**
  String get adminBookingDialogTitle;

  /// No description provided for @adminBookingSelectDates.
  ///
  /// In en, this message translates to:
  /// **'Select check-in and check-out dates'**
  String get adminBookingSelectDates;

  /// No description provided for @adminBookingRoom.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get adminBookingRoom;

  /// No description provided for @adminBookingGuestName.
  ///
  /// In en, this message translates to:
  /// **'Guest name'**
  String get adminBookingGuestName;

  /// No description provided for @adminBookingRequired.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get adminBookingRequired;

  /// No description provided for @adminBookingTotal.
  ///
  /// In en, this message translates to:
  /// **'Total: \${price}'**
  String adminBookingTotal(String price);

  /// No description provided for @adminBookingFillFields.
  ///
  /// In en, this message translates to:
  /// **'Fill in all fields'**
  String get adminBookingFillFields;

  /// No description provided for @adminBookingSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get adminBookingSave;

  /// No description provided for @adminBookingCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminBookingCancel;

  /// No description provided for @adminBookingError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String adminBookingError(String error);

  /// No description provided for @adminBookingNoName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get adminBookingNoName;

  /// No description provided for @bookingActionPending.
  ///
  /// In en, this message translates to:
  /// **'Request awaiting confirmation. Please confirm or reject.'**
  String get bookingActionPending;

  /// No description provided for @bookingActionConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed. Has the guest arrived? Click «Check In».'**
  String get bookingActionConfirmed;

  /// No description provided for @bookingActionCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Guest is staying. Process check-out to send room for cleaning.'**
  String get bookingActionCheckedIn;

  /// No description provided for @bookingActionCheckedOut.
  ///
  /// In en, this message translates to:
  /// **'Guest has checked out. Actions unavailable.'**
  String get bookingActionCheckedOut;

  /// No description provided for @bookingActionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled.'**
  String get bookingActionCancelled;

  /// No description provided for @bookingActionConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get bookingActionConfirmButton;

  /// No description provided for @bookingActionRejectButton.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get bookingActionRejectButton;

  /// No description provided for @bookingActionCheckinButton.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get bookingActionCheckinButton;

  /// No description provided for @bookingActionCheckoutButton.
  ///
  /// In en, this message translates to:
  /// **'Process Check-out'**
  String get bookingActionCheckoutButton;

  /// No description provided for @bookingActionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get bookingActionClose;

  /// No description provided for @bookingActionError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String bookingActionError(String error);

  /// No description provided for @bookingStatusCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get bookingStatusCheckedIn;

  /// No description provided for @bookingStatusCheckedOut.
  ///
  /// In en, this message translates to:
  /// **'Checked out'**
  String get bookingStatusCheckedOut;

  /// No description provided for @bookingStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingStatusCancelled;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksTitle;

  /// No description provided for @tasksMyTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'My Tasks'**
  String get tasksMyTasksTitle;

  /// No description provided for @tasksPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get tasksPending;

  /// No description provided for @tasksInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get tasksInProgress;

  /// No description provided for @tasksDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tasksDone;

  /// No description provided for @tasksNew.
  ///
  /// In en, this message translates to:
  /// **'New Task'**
  String get tasksNew;

  /// No description provided for @tasksName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get tasksName;

  /// No description provided for @tasksDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get tasksDescription;

  /// No description provided for @tasksNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: Room Cleaning'**
  String get tasksNameHint;

  /// No description provided for @tasksDescHint.
  ///
  /// In en, this message translates to:
  /// **'What needs to be done?'**
  String get tasksDescHint;

  /// No description provided for @tasksAssignEmployee.
  ///
  /// In en, this message translates to:
  /// **'Assign Employee'**
  String get tasksAssignEmployee;

  /// No description provided for @tasksAttachRoom.
  ///
  /// In en, this message translates to:
  /// **'Attach to Room'**
  String get tasksAttachRoom;

  /// No description provided for @tasksUnattached.
  ///
  /// In en, this message translates to:
  /// **'Unattached'**
  String get tasksUnattached;

  /// No description provided for @tasksUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get tasksUnassigned;

  /// No description provided for @tasksCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get tasksCreate;

  /// No description provided for @tasksCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get tasksCancel;

  /// No description provided for @tasksErrorRooms.
  ///
  /// In en, this message translates to:
  /// **'Error loading rooms'**
  String get tasksErrorRooms;

  /// No description provided for @tasksErrorStaff.
  ///
  /// In en, this message translates to:
  /// **'Error loading staff'**
  String get tasksErrorStaff;

  /// No description provided for @tasksError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String tasksError(String error);

  /// No description provided for @tasksTakeButton.
  ///
  /// In en, this message translates to:
  /// **'TAKE TASK'**
  String get tasksTakeButton;

  /// No description provided for @tasksCompleteButton.
  ///
  /// In en, this message translates to:
  /// **'COMPLETE'**
  String get tasksCompleteButton;

  /// No description provided for @tasksNoTasksToday.
  ///
  /// In en, this message translates to:
  /// **'No tasks for today!'**
  String get tasksNoTasksToday;

  /// No description provided for @tasksWellDone.
  ///
  /// In en, this message translates to:
  /// **'You did great.'**
  String get tasksWellDone;

  /// No description provided for @tasksLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in'**
  String get tasksLoginRequired;

  /// No description provided for @tasksCommonArea.
  ///
  /// In en, this message translates to:
  /// **'Common Area'**
  String get tasksCommonArea;

  /// No description provided for @tasksRoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Room # {name}'**
  String tasksRoomLabel(String name);

  /// No description provided for @newsCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get newsCreateTitle;

  /// No description provided for @newsCreateHeadline.
  ///
  /// In en, this message translates to:
  /// **'Headline'**
  String get newsCreateHeadline;

  /// No description provided for @newsCreateEnterHeadline.
  ///
  /// In en, this message translates to:
  /// **'Enter headline!'**
  String get newsCreateEnterHeadline;

  /// No description provided for @newsCreateAudience.
  ///
  /// In en, this message translates to:
  /// **'Who sees the post:'**
  String get newsCreateAudience;

  /// No description provided for @newsCreateAudienceAll.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get newsCreateAudienceAll;

  /// No description provided for @newsCreateAudienceGuests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get newsCreateAudienceGuests;

  /// No description provided for @newsCreateAudienceStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get newsCreateAudienceStaff;

  /// No description provided for @newsCreateSectionHint.
  ///
  /// In en, this message translates to:
  /// **'Section {num} text'**
  String newsCreateSectionHint(int num);

  /// No description provided for @newsCreateAddImage.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get newsCreateAddImage;

  /// No description provided for @newsCreateNoContent.
  ///
  /// In en, this message translates to:
  /// **'Add at least some text or an image'**
  String get newsCreateNoContent;

  /// No description provided for @newsCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'News published successfully! 🎉'**
  String get newsCreateSuccess;

  /// No description provided for @newsCreateError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String newsCreateError(String error);

  /// No description provided for @newsCreatePublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get newsCreatePublish;

  /// No description provided for @newsCreateImageSizeError.
  ///
  /// In en, this message translates to:
  /// **'Desktop image size must not exceed 250 KB'**
  String get newsCreateImageSizeError;

  /// No description provided for @newsManageTitle.
  ///
  /// In en, this message translates to:
  /// **'News Management'**
  String get newsManageTitle;

  /// No description provided for @newsManageActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get newsManageActive;

  /// No description provided for @newsManageArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get newsManageArchive;

  /// No description provided for @newsManageActiveEmpty.
  ///
  /// In en, this message translates to:
  /// **'No active news'**
  String get newsManageActiveEmpty;

  /// No description provided for @newsManageArchiveEmpty.
  ///
  /// In en, this message translates to:
  /// **'Archive is empty'**
  String get newsManageArchiveEmpty;

  /// No description provided for @newsManageCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get newsManageCreate;

  /// No description provided for @newsManageDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get newsManageDelete;

  /// No description provided for @newsManageDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get newsManageDeleteTitle;

  /// No description provided for @newsManageDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this post permanently?'**
  String get newsManageDeleteConfirm;

  /// No description provided for @newsManageCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get newsManageCancel;

  /// No description provided for @newsManageError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String newsManageError(String error);

  /// No description provided for @newsManageCreateHint.
  ///
  /// In en, this message translates to:
  /// **'Use the \"Create\" button in the menu or FAB'**
  String get newsManageCreateHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ky', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ky':
      return AppLocalizationsKy();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
