import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

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
    Locale('ur'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Flutter Sample Architecture'**
  String get appTitle;

  /// Dashboard page title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Theme settings
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Language settings
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Urdu language option
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get urdu;

  /// Select theme dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// Select language dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Home page title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Profile page title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Change theme button text
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get changeTheme;

  /// Change language button text
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @authVerifyPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Phone Number'**
  String get authVerifyPhoneTitle;

  /// No description provided for @authMobileNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number'**
  String get authMobileNumberLabel;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get started by Signing Up/Logging In'**
  String get authLoginSubtitle;

  /// No description provided for @authPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+92 3XXXXXXXXX'**
  String get authPhoneHint;

  /// No description provided for @authOtpHint.
  ///
  /// In en, this message translates to:
  /// **'An OTP will be sent to this number'**
  String get authOtpHint;

  /// No description provided for @authSendOtpCta.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get authSendOtpCta;

  /// No description provided for @authOtpVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get authOtpVerificationTitle;

  /// No description provided for @authOtpHintCode.
  ///
  /// In en, this message translates to:
  /// **'1 2 3 4'**
  String get authOtpHintCode;

  /// No description provided for @authProceedCta.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get authProceedCta;

  /// No description provided for @authResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get authResendOtp;

  /// No description provided for @authOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to'**
  String get authOtpSentTo;

  /// No description provided for @authOtpSentMessage.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully.'**
  String get authOtpSentMessage;

  /// No description provided for @authPhoneValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number.'**
  String get authPhoneValidationError;

  /// No description provided for @authOtpValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 4-digit OTP.'**
  String get authOtpValidationError;

  /// No description provided for @authTermsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'By Signing in, I agree to Terms & Conditions and Privacy Policy.'**
  String get authTermsAndPrivacy;

  /// No description provided for @authLegalPrefix.
  ///
  /// In en, this message translates to:
  /// **'By Signing in, I agree to'**
  String get authLegalPrefix;

  /// No description provided for @authTermsLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get authTermsLabel;

  /// No description provided for @authLegalConnector.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get authLegalConnector;

  /// No description provided for @authPrivacyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy.'**
  String get authPrivacyLabel;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Edit'**
  String get profileTitle;

  /// No description provided for @profileSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your profile'**
  String get profileSetupTitle;

  /// No description provided for @profileSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your personal information'**
  String get profileSetupSubtitle;

  /// No description provided for @profileFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get profileFirstNameLabel;

  /// No description provided for @profileFirstNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter First Name Here'**
  String get profileFirstNameHint;

  /// No description provided for @profileFirstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required.'**
  String get profileFirstNameRequired;

  /// No description provided for @profileLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get profileLastNameLabel;

  /// No description provided for @profileLastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Last Name Here'**
  String get profileLastNameHint;

  /// No description provided for @profileLastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required.'**
  String get profileLastNameRequired;

  /// No description provided for @profileGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileGenderLabel;

  /// No description provided for @profileGenderHint.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get profileGenderHint;

  /// No description provided for @profileGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get profileGenderMale;

  /// No description provided for @profileGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get profileGenderFemale;

  /// No description provided for @profileGenderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get profileGenderOther;

  /// No description provided for @profileGenderRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select gender.'**
  String get profileGenderRequired;

  /// No description provided for @profileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmailLabel;

  /// No description provided for @profileEmailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get profileEmailHint;

  /// No description provided for @profileEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email.'**
  String get profileEmailRequired;

  /// No description provided for @profileAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profileAddressLabel;

  /// No description provided for @profileAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Address'**
  String get profileAddressHint;

  /// No description provided for @profileAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required.'**
  String get profileAddressRequired;

  /// No description provided for @profileDobLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get profileDobLabel;

  /// No description provided for @profileDobHint.
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YY'**
  String get profileDobHint;

  /// No description provided for @profileDobRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select date of birth.'**
  String get profileDobRequired;

  /// No description provided for @profileSaveCta.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSaveCta;

  /// Title for the lab test browse screen app bar
  ///
  /// In en, this message translates to:
  /// **'Lab Test'**
  String get labTestScreenTitle;

  /// No description provided for @labTestSelectCityPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get labTestSelectCityPlaceholder;

  /// No description provided for @labTestCityFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get labTestCityFieldLabel;

  /// No description provided for @labTestChangeCityCta.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get labTestChangeCityCta;

  /// No description provided for @labTestSelectTestHeading.
  ///
  /// In en, this message translates to:
  /// **'Select Test'**
  String get labTestSelectTestHeading;

  /// No description provided for @labTestSearchFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get labTestSearchFieldHint;

  /// No description provided for @labTestSelectCitySheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a City'**
  String get labTestSelectCitySheetTitle;

  /// No description provided for @labTestSelectCitySheetSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for City'**
  String get labTestSelectCitySheetSearchHint;

  /// No description provided for @labTestRequirementLabel.
  ///
  /// In en, this message translates to:
  /// **'Requirement'**
  String get labTestRequirementLabel;

  /// No description provided for @labTestSampleTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Sample Type'**
  String get labTestSampleTypeLabel;

  /// No description provided for @labTestPleaseSelectCityFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a city first.'**
  String get labTestPleaseSelectCityFirst;

  /// No description provided for @labTestDataStillLoading.
  ///
  /// In en, this message translates to:
  /// **'Lab test data is still loading.'**
  String get labTestDataStillLoading;

  /// No description provided for @labTestCatalogLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load lab tests.'**
  String get labTestCatalogLoadFailed;

  /// No description provided for @labTestNoTestsFound.
  ///
  /// In en, this message translates to:
  /// **'No tests found'**
  String get labTestNoTestsFound;

  /// No description provided for @labTestCartBadgeOverflow.
  ///
  /// In en, this message translates to:
  /// **'9+'**
  String get labTestCartBadgeOverflow;

  /// No description provided for @labTestBrowseItemFeeFallback.
  ///
  /// In en, this message translates to:
  /// **'Rs. 15,000/-'**
  String get labTestBrowseItemFeeFallback;

  /// No description provided for @labTestBookingChooseMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a Booking Method'**
  String get labTestBookingChooseMethodTitle;

  /// No description provided for @labTestBookingMethodWalkIn.
  ///
  /// In en, this message translates to:
  /// **'Walk In'**
  String get labTestBookingMethodWalkIn;

  /// No description provided for @labTestBookingMethodHomeSample.
  ///
  /// In en, this message translates to:
  /// **'Home Sample'**
  String get labTestBookingMethodHomeSample;

  /// No description provided for @labTestBookingAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get labTestBookingAddToCart;

  /// No description provided for @labTestBookingViewYourCart.
  ///
  /// In en, this message translates to:
  /// **'View Your Cart'**
  String get labTestBookingViewYourCart;

  /// No description provided for @labTestBookingDataUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Lab test data unavailable'**
  String get labTestBookingDataUnavailable;

  /// No description provided for @labTestCartChangeWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Warning!'**
  String get labTestCartChangeWarningTitle;

  /// No description provided for @labTestCartChangeWarningBody.
  ///
  /// In en, this message translates to:
  /// **'Changing the City, Service Provider or\nLab will remove all items from your cart.\nDo you want to proceed?'**
  String get labTestCartChangeWarningBody;

  /// No description provided for @labTestCartChangeViewCart.
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get labTestCartChangeViewCart;

  /// No description provided for @labTestCartChangeContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get labTestCartChangeContinue;

  /// No description provided for @labTestCartBadgeOverflow99.
  ///
  /// In en, this message translates to:
  /// **'99+'**
  String get labTestCartBadgeOverflow99;

  /// No description provided for @labTestCartScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get labTestCartScreenTitle;

  /// No description provided for @labTestCartEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No items in cart'**
  String get labTestCartEmptyMessage;

  /// No description provided for @labTestCartProceedCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed Checkout'**
  String get labTestCartProceedCheckout;
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
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
