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

  /// No description provided for @authVerifyCta.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get authVerifyCta;

  /// No description provided for @authResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get authResendOtp;

  /// No description provided for @authOtpSecondsShort.
  ///
  /// In en, this message translates to:
  /// **'Sec'**
  String get authOtpSecondsShort;

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

  /// Title on the pharmacy detail screen header
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get pharmacyScreenTitle;

  /// Pharmacy medicines list failed to load
  ///
  /// In en, this message translates to:
  /// **'Unable to load medicines right now. Please try again in a moment.'**
  String get pharmacyLoadError;

  /// Pharmacy list has no items
  ///
  /// In en, this message translates to:
  /// **'No medicine found'**
  String get pharmacyEmptyMedicines;

  /// Section title on pharmacy hub main screen
  ///
  /// In en, this message translates to:
  /// **'Choose Medicine'**
  String get pharmacyMainChooseMedicineTitle;

  /// Search field hint on pharmacy hub
  ///
  /// In en, this message translates to:
  /// **'Search medicine..'**
  String get pharmacyMainSearchHint;

  /// No description provided for @pharmacyCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get pharmacyCartTitle;

  /// No description provided for @pharmacyCartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get pharmacyCartEmpty;

  /// No description provided for @pharmacyCheckoutCta.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get pharmacyCheckoutCta;

  /// No description provided for @pharmacyCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get pharmacyCheckoutTitle;

  /// No description provided for @pharmacyCheckoutPatientDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Patient Detail'**
  String get pharmacyCheckoutPatientDetailTitle;

  /// No description provided for @pharmacyCheckoutPatientLabel.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get pharmacyCheckoutPatientLabel;

  /// No description provided for @pharmacyCheckoutPatientSelf.
  ///
  /// In en, this message translates to:
  /// **'Self'**
  String get pharmacyCheckoutPatientSelf;

  /// No description provided for @pharmacyCheckoutSpecialInstructionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Special Instructions'**
  String get pharmacyCheckoutSpecialInstructionsLabel;

  /// No description provided for @pharmacyCheckoutSpecialInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'----'**
  String get pharmacyCheckoutSpecialInstructionsHint;

  /// No description provided for @pharmacyCheckoutOrderDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get pharmacyCheckoutOrderDetailsTitle;

  /// No description provided for @pharmacyCheckoutDeliveryChargesLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Charges'**
  String get pharmacyCheckoutDeliveryChargesLabel;

  /// No description provided for @pharmacyCheckoutDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount (8%)'**
  String get pharmacyCheckoutDiscountLabel;

  /// No description provided for @pharmacyCheckoutTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get pharmacyCheckoutTotalLabel;

  /// No description provided for @pharmacyCheckoutAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get pharmacyCheckoutAddressLabel;

  /// No description provided for @pharmacyCheckoutAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get pharmacyCheckoutAddressHint;

  /// No description provided for @pharmacyCheckoutCityLabel.
  ///
  /// In en, this message translates to:
  /// **'Area / City *'**
  String get pharmacyCheckoutCityLabel;

  /// No description provided for @pharmacyCheckoutPaymentMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get pharmacyCheckoutPaymentMethodTitle;

  /// No description provided for @pharmacyCheckoutDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get pharmacyCheckoutDisclaimerTitle;

  /// No description provided for @pharmacyCheckoutDisclaimerMessage.
  ///
  /// In en, this message translates to:
  /// **'Sold and fulfilled by our Licensed Pharmacy Partner(s) \"MEDIQ PHARMACY\". License No. : 05-352-0070-053618P'**
  String get pharmacyCheckoutDisclaimerMessage;

  /// No description provided for @pharmacyCheckoutDeliveryInfoMessage.
  ///
  /// In en, this message translates to:
  /// **'Orders will be delivered within 3 hours between 8:00 AM and 8:00 PM. Orders placed after 8:00 PM will be delivered by 12PM the following day.'**
  String get pharmacyCheckoutDeliveryInfoMessage;

  /// No description provided for @pharmacyCheckoutDeliveryInfoFooter.
  ///
  /// In en, this message translates to:
  /// **'Orders below Rs 2500 will include delivery charges of Rs 250.'**
  String get pharmacyCheckoutDeliveryInfoFooter;

  /// No description provided for @pharmacyCheckoutConfirmCta.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get pharmacyCheckoutConfirmCta;

  /// No description provided for @pharmacyOrderPlacedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get pharmacyOrderPlacedTitle;

  /// No description provided for @pharmacyOrderPlacedMessage.
  ///
  /// In en, this message translates to:
  /// **'Orders received b/w 8 AM - 8 PM will be delivered within 3 business hrs.'**
  String get pharmacyOrderPlacedMessage;

  /// No description provided for @pharmacyOrderPlacedClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get pharmacyOrderPlacedClose;

  /// No description provided for @pharmacyPaymentJazzCash.
  ///
  /// In en, this message translates to:
  /// **'Jazz Cash'**
  String get pharmacyPaymentJazzCash;

  /// No description provided for @pharmacyPaymentDebitCard.
  ///
  /// In en, this message translates to:
  /// **'Debit / Credit Card'**
  String get pharmacyPaymentDebitCard;

  /// No description provided for @pharmacyPaymentCash.
  ///
  /// In en, this message translates to:
  /// **'Pay via Cash'**
  String get pharmacyPaymentCash;

  /// No description provided for @pharmacyCurrencyPrefix.
  ///
  /// In en, this message translates to:
  /// **'Rs. '**
  String get pharmacyCurrencyPrefix;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingDoctorConsultationTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctor Consultation'**
  String get onboardingDoctorConsultationTitle;

  /// No description provided for @onboardingDoctorConsultationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access to PMDC certified doctors'**
  String get onboardingDoctorConsultationSubtitle;

  /// No description provided for @onboardingPharmacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get onboardingPharmacyTitle;

  /// No description provided for @onboardingPharmacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get authentic medicines at your doorstep.'**
  String get onboardingPharmacySubtitle;

  /// No description provided for @onboardingLaboratoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Laboratory Testing'**
  String get onboardingLaboratoryTitle;

  /// No description provided for @onboardingLaboratorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access reliable lab tests with accurate results.'**
  String get onboardingLaboratorySubtitle;

  /// No description provided for @onboardingSurgeryTitle.
  ///
  /// In en, this message translates to:
  /// **'Surgery Booking'**
  String get onboardingSurgeryTitle;

  /// No description provided for @onboardingSurgerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book your surgery with ease.'**
  String get onboardingSurgerySubtitle;

  /// No description provided for @pharmacyMoreLike.
  ///
  /// In en, this message translates to:
  /// **'More Like'**
  String get pharmacyMoreLike;

  /// No description provided for @pharmacyAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get pharmacyAddToCart;

  /// No description provided for @pharmacyAddToCartLower.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get pharmacyAddToCartLower;

  /// No description provided for @freeDoctorTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Doctor'**
  String get freeDoctorTitle;

  /// No description provided for @freeDoctorOpenAppCta.
  ///
  /// In en, this message translates to:
  /// **'Open Fikrfree app'**
  String get freeDoctorOpenAppCta;

  /// No description provided for @freeDoctorOpenAppError.
  ///
  /// In en, this message translates to:
  /// **'Could not open FikrFree right now.'**
  String get freeDoctorOpenAppError;

  /// No description provided for @freeDoctorConsultationTitle.
  ///
  /// In en, this message translates to:
  /// **'24/7 Free Doctor Consultation'**
  String get freeDoctorConsultationTitle;

  /// No description provided for @freeDoctorPoint1.
  ///
  /// In en, this message translates to:
  /// **'This service is available exclusively for Bima m-Health subscribers.'**
  String get freeDoctorPoint1;

  /// No description provided for @freeDoctorPoint2.
  ///
  /// In en, this message translates to:
  /// **'Get 24/7 access to qualified doctors for general medical support and much more.'**
  String get freeDoctorPoint2;

  /// No description provided for @freeDoctorPoint3.
  ///
  /// In en, this message translates to:
  /// **'To avail the service, subscribe to BIMA m-Health via FikrFree.'**
  String get freeDoctorPoint3;

  /// No description provided for @customerSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Support'**
  String get customerSupportTitle;

  /// No description provided for @customerSupportHelpCentreTitle.
  ///
  /// In en, this message translates to:
  /// **'Help Centre'**
  String get customerSupportHelpCentreTitle;

  /// No description provided for @customerSupportHelpCentreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reach out to Apna Clinic for any support.'**
  String get customerSupportHelpCentreSubtitle;

  /// No description provided for @customerSupportFallbackCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Apna Clinic Support'**
  String get customerSupportFallbackCardTitle;

  /// No description provided for @customerSupportFallbackDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Support'**
  String get customerSupportFallbackDialogTitle;

  /// No description provided for @customerSupportFallbackDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Or further support please contact us 24/7 on\n042-111-333-033.'**
  String get customerSupportFallbackDialogMessage;

  /// No description provided for @customerSupportCallNowCta.
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get customerSupportCallNowCta;

  /// No description provided for @customerSupportDialError.
  ///
  /// In en, this message translates to:
  /// **'Could not start the call.'**
  String get customerSupportDialError;
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
