import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @parkingName.
  ///
  /// In en, this message translates to:
  /// **'Parking Name'**
  String get parkingName;

  /// No description provided for @addYourParkingLotInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Add Your Parking Lot in Minutes'**
  String get addYourParkingLotInMinutes;

  /// No description provided for @earnAndManageSmartly.
  ///
  /// In en, this message translates to:
  /// **'Earn and Manage Smartly'**
  String get earnAndManageSmartly;

  /// No description provided for @joinSmartCityMovement.
  ///
  /// In en, this message translates to:
  /// **'Join the Smart City Movement'**
  String get joinSmartCityMovement;

  /// No description provided for @parkingNumber.
  ///
  /// In en, this message translates to:
  /// **'Parking\'s Number'**
  String get parkingNumber;

  /// No description provided for @activeLots.
  ///
  /// In en, this message translates to:
  /// **'Active Lots'**
  String get activeLots;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get locationPermissionDenied;

  /// No description provided for @failedToGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Failed to get location'**
  String get failedToGetLocation;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @occupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get occupied;

  /// No description provided for @continueAsDriver.
  ///
  /// In en, this message translates to:
  /// **'Continue as Driver'**
  String get continueAsDriver;

  /// No description provided for @continueAsOwner.
  ///
  /// In en, this message translates to:
  /// **'Continue as Parking Owner'**
  String get continueAsOwner;

  /// No description provided for @smartParkJordan.
  ///
  /// In en, this message translates to:
  /// **'SmartPark JORDAN'**
  String get smartParkJordan;

  /// No description provided for @findReserveParkSmart.
  ///
  /// In en, this message translates to:
  /// **'Find. Reserve. Park Smart.'**
  String get findReserveParkSmart;

  /// No description provided for @thankYouForRating.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your rating!'**
  String get thankYouForRating;

  /// No description provided for @pickParkingLocation.
  ///
  /// In en, this message translates to:
  /// **'Pick parking location'**
  String get pickParkingLocation;

  /// No description provided for @selectParkingSpot.
  ///
  /// In en, this message translates to:
  /// **'Select parking spot'**
  String get selectParkingSpot;

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @pleaseSelectParkingSpot.
  ///
  /// In en, this message translates to:
  /// **'Please select a parking spot!'**
  String get pleaseSelectParkingSpot;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @rateYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Experience'**
  String get rateYourExperience;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @welcomeDriver.
  ///
  /// In en, this message translates to:
  /// **'Welcome Driver'**
  String get welcomeDriver;

  /// No description provided for @parkingAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Parking Added Successfully'**
  String get parkingAddedSuccessfully;

  /// No description provided for @addParkingLot.
  ///
  /// In en, this message translates to:
  /// **'Add Parking Lot'**
  String get addParkingLot;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @failedToUpdateTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed to update. Try again.'**
  String get failedToUpdateTryAgain;

  /// No description provided for @chooseAvailableSpot.
  ///
  /// In en, this message translates to:
  /// **'Choose Available Spot'**
  String get chooseAvailableSpot;

  /// No description provided for @myBooking.
  ///
  /// In en, this message translates to:
  /// **'My Booking'**
  String get myBooking;

  /// No description provided for @noReservationFound.
  ///
  /// In en, this message translates to:
  /// **'No reservation found.'**
  String get noReservationFound;

  /// No description provided for @notEnoughMoney.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have enough money to make a reservation!'**
  String get notEnoughMoney;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @noPastReservations.
  ///
  /// In en, this message translates to:
  /// **'No past reservations.'**
  String get noPastReservations;

  /// No description provided for @noUserLoggedInError.
  ///
  /// In en, this message translates to:
  /// **'No user logged in'**
  String get noUserLoggedInError;

  /// No description provided for @confirmLogOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get confirmLogOut;

  /// No description provided for @reserveSpot.
  ///
  /// In en, this message translates to:
  /// **'Reserve Spot'**
  String get reserveSpot;

  /// No description provided for @pricePerHour.
  ///
  /// In en, this message translates to:
  /// **'Price per hour'**
  String get pricePerHour;

  /// No description provided for @alreadyRated.
  ///
  /// In en, this message translates to:
  /// **'You have already rated this parking!'**
  String get alreadyRated;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @thankYouForReachingOut.
  ///
  /// In en, this message translates to:
  /// **'Thank you for reaching out!'**
  String get thankYouForReachingOut;

  /// No description provided for @totalThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Total This Month'**
  String get totalThisMonth;

  /// No description provided for @confirmDeleteParking.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this parking lot?'**
  String get confirmDeleteParking;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @aiChatBot.
  ///
  /// In en, this message translates to:
  /// **'AI Chat Bot'**
  String get aiChatBot;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @fillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get fillRequiredFields;

  /// No description provided for @myInformation.
  ///
  /// In en, this message translates to:
  /// **'My Information'**
  String get myInformation;

  /// No description provided for @mustBeLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in!'**
  String get mustBeLoggedIn;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid Input'**
  String get invalidInput;

  /// No description provided for @ownerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Owner Dashboard'**
  String get ownerDashboard;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// No description provided for @logOutAccount.
  ///
  /// In en, this message translates to:
  /// **'Log out of your account'**
  String get logOutAccount;

  /// No description provided for @noParkingLotsYet.
  ///
  /// In en, this message translates to:
  /// **'No parking lots added yet.'**
  String get noParkingLotsYet;

  /// No description provided for @yourMessage.
  ///
  /// In en, this message translates to:
  /// **'Your Message'**
  String get yourMessage;

  /// No description provided for @confirmReservation.
  ///
  /// In en, this message translates to:
  /// **'Confirm reservation'**
  String get confirmReservation;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @selectPaymentType.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Type'**
  String get selectPaymentType;

  /// No description provided for @activeReservation.
  ///
  /// In en, this message translates to:
  /// **'Active Reservation'**
  String get activeReservation;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need Help?'**
  String get needHelp;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @parkWithSmile.
  ///
  /// In en, this message translates to:
  /// **'Park with a Smile 😊'**
  String get parkWithSmile;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @leaveComment.
  ///
  /// In en, this message translates to:
  /// **'Leave a comment (optional)'**
  String get leaveComment;

  /// No description provided for @addParking.
  ///
  /// In en, this message translates to:
  /// **'Add Parking'**
  String get addParking;

  /// No description provided for @myParkingLots.
  ///
  /// In en, this message translates to:
  /// **'My Parking Lots'**
  String get myParkingLots;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @yourControl.
  ///
  /// In en, this message translates to:
  /// **'Your Control'**
  String get yourControl;

  /// No description provided for @timeElapsed.
  ///
  /// In en, this message translates to:
  /// **'Time Elapsed'**
  String get timeElapsed;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @updatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get updatedSuccessfully;

  /// No description provided for @parkingUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Parking updated successfully!'**
  String get parkingUpdatedSuccessfully;

  /// No description provided for @noAvailableSpots.
  ///
  /// In en, this message translates to:
  /// **'No available spots'**
  String get noAvailableSpots;

  /// No description provided for @removeCard.
  ///
  /// In en, this message translates to:
  /// **'Remove Card'**
  String get removeCard;

  /// No description provided for @parkingDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Parking lot deleted successfully!'**
  String get parkingDeletedSuccessfully;

  /// No description provided for @privacyMatters.
  ///
  /// In en, this message translates to:
  /// **'Your Privacy Matters'**
  String get privacyMatters;

  /// No description provided for @addPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Add Payment Method'**
  String get addPaymentMethod;

  /// No description provided for @confirmSpot.
  ///
  /// In en, this message translates to:
  /// **'Confirm Spot'**
  String get confirmSpot;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your Password'**
  String get enterPassword;

  /// No description provided for @ratingSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Rating submitted successfully!'**
  String get ratingSubmittedSuccess;

  /// No description provided for @noSpotsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No spots available'**
  String get noSpotsAvailable;

  /// No description provided for @pleaseSelectRating.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating'**
  String get pleaseSelectRating;

  /// No description provided for @pick.
  ///
  /// In en, this message translates to:
  /// **'Pick'**
  String get pick;

  /// No description provided for @confirmParkingSpot.
  ///
  /// In en, this message translates to:
  /// **'Confirm Parking Spot'**
  String get confirmParkingSpot;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @messageSentHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Your message has been sent to the Help Center!'**
  String get messageSentHelpCenter;

  /// No description provided for @editParking.
  ///
  /// In en, this message translates to:
  /// **'Edit Parking'**
  String get editParking;

  /// No description provided for @noParkingLotsFound.
  ///
  /// In en, this message translates to:
  /// **'No parking lots found'**
  String get noParkingLotsFound;

  /// No description provided for @noUserSet.
  ///
  /// In en, this message translates to:
  /// **'No user details found'**
  String get noUserSet;

  /// No description provided for @searchLocationName.
  ///
  /// In en, this message translates to:
  /// **'Search by location or name...'**
  String get searchLocationName;

  /// No description provided for @welcomeOwner.
  ///
  /// In en, this message translates to:
  /// **'Welcome Owner'**
  String get welcomeOwner;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @noUpcomingReservations.
  ///
  /// In en, this message translates to:
  /// **'No upcoming reservations.'**
  String get noUpcomingReservations;

  /// No description provided for @manageSpots.
  ///
  /// In en, this message translates to:
  /// **'Manage Spots'**
  String get manageSpots;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @userInformation.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userInformation;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @pickLocation.
  ///
  /// In en, this message translates to:
  /// **'Pick Location'**
  String get pickLocation;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @cardRemovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Card removed successfully'**
  String get cardRemovedSuccessfully;

  /// No description provided for @alreadyHaveCard.
  ///
  /// In en, this message translates to:
  /// **'You already have a card linked'**
  String get alreadyHaveCard;

  /// No description provided for @updatePrivacySettings.
  ///
  /// In en, this message translates to:
  /// **'You can update or delete your personal information at any time from your profile settings. '**
  String get updatePrivacySettings;

  /// No description provided for @privacyPolicy1.
  ///
  /// In en, this message translates to:
  /// **'We are committed to protecting your personal information and ensuring transparency about how we collect, use, and store it. '**
  String get privacyPolicy1;

  /// No description provided for @privacyPolicy2.
  ///
  /// In en, this message translates to:
  /// **'For more details, contact our support team or review our full privacy policy in the app settings.'**
  String get privacyPolicy2;

  /// No description provided for @tellUsWhatsGoingOn.
  ///
  /// In en, this message translates to:
  /// **'Tell us what’s going on, and we’ll get back to you as soon as possible.'**
  String get tellUsWhatsGoingOn;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @findParkingNearYou.
  ///
  /// In en, this message translates to:
  /// **'Find Parking Near You'**
  String get findParkingNearYou;

  /// No description provided for @reserveInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Reserve in Seconds'**
  String get reserveInSeconds;

  /// No description provided for @saveTimeMoney.
  ///
  /// In en, this message translates to:
  /// **'Save Time & Money'**
  String get saveTimeMoney;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Discover available parking spots in real-time on an interactive map.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Book your parking spot instantly and avoid the hassle of searching.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Get the best rates and never waste time looking for parking again.'**
  String get onboardingDesc3;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @letsPark.
  ///
  /// In en, this message translates to:
  /// **'Let’s Park!'**
  String get letsPark;

  /// No description provided for @myReservation.
  ///
  /// In en, this message translates to:
  /// **'My Reservation'**
  String get myReservation;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @access24.
  ///
  /// In en, this message translates to:
  /// **'24/7 Access'**
  String get access24;

  /// No description provided for @cctv.
  ///
  /// In en, this message translates to:
  /// **'CCTV Security'**
  String get cctv;

  /// No description provided for @evCharging.
  ///
  /// In en, this message translates to:
  /// **'EV Charging'**
  String get evCharging;

  /// No description provided for @disabledAccess.
  ///
  /// In en, this message translates to:
  /// **'Disabled Access'**
  String get disabledAccess;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @pricePerHourLabel.
  ///
  /// In en, this message translates to:
  /// **'Price per hour'**
  String get pricePerHourLabel;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @reserveSpotConfirmation.
  ///
  /// In en, this message translates to:
  /// **'You’re about to reserve\nspot {id}'**
  String reserveSpotConfirmation(Object id);

  /// No description provided for @spotOccupied.
  ///
  /// In en, this message translates to:
  /// **'Spot {id} is now occupied'**
  String spotOccupied(Object id);

  /// No description provided for @spotSelected.
  ///
  /// In en, this message translates to:
  /// **'Spot {id} selected'**
  String spotSelected(Object id);

  /// No description provided for @reservationCompleted.
  ///
  /// In en, this message translates to:
  /// **'Reservation Completed'**
  String get reservationCompleted;

  /// No description provided for @showQrInstruction.
  ///
  /// In en, this message translates to:
  /// **'Show this QR at the parking entrance'**
  String get showQrInstruction;

  /// No description provided for @pricePerHourValue.
  ///
  /// In en, this message translates to:
  /// **'Price/hour: {price} JOD'**
  String pricePerHourValue(Object price);

  /// No description provided for @yourDuration.
  ///
  /// In en, this message translates to:
  /// **'Your duration: {duration}'**
  String yourDuration(Object duration);

  /// No description provided for @yourTotalPrice.
  ///
  /// In en, this message translates to:
  /// **'Your total Price: {total}'**
  String yourTotalPrice(Object total);

  /// No description provided for @rateReservation.
  ///
  /// In en, this message translates to:
  /// **'Rate Reservation'**
  String get rateReservation;

  /// No description provided for @showQrCode.
  ///
  /// In en, this message translates to:
  /// **'Show QR Code'**
  String get showQrCode;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 letters'**
  String get nameTooShort;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 10 digits'**
  String get phoneInvalid;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @enterNew.
  ///
  /// In en, this message translates to:
  /// **'Enter new'**
  String get enterNew;

  /// No description provided for @passwordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Password must be exactly 6 characters'**
  String get passwordInvalid;

  /// No description provided for @nameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Name must contain letters only'**
  String get nameInvalid;

  /// No description provided for @cardHolderName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name'**
  String get cardHolderName;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry (MM/YY)'**
  String get expiryDate;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @pleaseEnter.
  ///
  /// In en, this message translates to:
  /// **'Please enter'**
  String get pleaseEnter;

  /// No description provided for @balanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balanceLabel;

  /// No description provided for @paymentAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{type} added successfully'**
  String paymentAddedSuccess(String type);

  /// No description provided for @updateField.
  ///
  /// In en, this message translates to:
  /// **'Update {field}'**
  String updateField(Object field);

  /// No description provided for @enterNewField.
  ///
  /// In en, this message translates to:
  /// **'Enter new {field}'**
  String enterNewField(Object field);

  /// No description provided for @phoneValidationError.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be exactly 10 digits'**
  String get phoneValidationError;

  /// No description provided for @passwordValidationError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordValidationError;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get createdAt;

  /// No description provided for @startedAt.
  ///
  /// In en, this message translates to:
  /// **'Started at'**
  String get startedAt;

  /// No description provided for @endedAt.
  ///
  /// In en, this message translates to:
  /// **'Ended at'**
  String get endedAt;

  /// No description provided for @spot.
  ///
  /// In en, this message translates to:
  /// **'Spot'**
  String get spot;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
