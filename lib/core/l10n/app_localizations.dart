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

  /// No description provided for @profileUpdateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get profileUpdateSubtitle;

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

  /// No description provided for @profileUpdateCta.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get profileUpdateCta;

  /// No description provided for @profileSetupHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Setup'**
  String get profileSetupHeaderTitle;

  /// No description provided for @profileImagePickerRestartMessage.
  ///
  /// In en, this message translates to:
  /// **'Image picker not ready yet. Please fully restart the app.'**
  String get profileImagePickerRestartMessage;

  /// No description provided for @profileImagePickerFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not pick image. Please try again.'**
  String get profileImagePickerFailedMessage;

  /// No description provided for @profileGuestUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get profileGuestUserTitle;

  /// No description provided for @profileSignupLoginCta.
  ///
  /// In en, this message translates to:
  /// **'Sign Up / Login'**
  String get profileSignupLoginCta;

  /// No description provided for @profileEditCta.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profileEditCta;

  /// No description provided for @profileAccountDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get profileAccountDetailsTitle;

  /// No description provided for @profileDefaultTag.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get profileDefaultTag;

  /// No description provided for @profileAddAccountCta.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get profileAddAccountCta;

  /// No description provided for @profileMobileBankPrefix.
  ///
  /// In en, this message translates to:
  /// **'Mobile Bank'**
  String get profileMobileBankPrefix;

  /// No description provided for @profileRemoveAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Account'**
  String get profileRemoveAccountTitle;

  /// No description provided for @profileRemoveAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {bankName} account {accountNumber} ?'**
  String profileRemoveAccountMessage(String bankName, String accountNumber);

  /// No description provided for @profileRemoveCta.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get profileRemoveCta;

  /// No description provided for @profileCancelCta.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancelCta;

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

  /// No description provided for @pharmacyBookingOrderPrefix.
  ///
  /// In en, this message translates to:
  /// **'Order no'**
  String get pharmacyBookingOrderPrefix;

  /// No description provided for @pharmacyBookingMedicineName.
  ///
  /// In en, this message translates to:
  /// **'O-ZEETINE Capsules 6/25MG'**
  String get pharmacyBookingMedicineName;

  /// No description provided for @pharmacyBookingMedicineQty.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get pharmacyBookingMedicineQty;

  /// No description provided for @pharmacyBookingCurrencyCompact.
  ///
  /// In en, this message translates to:
  /// **'Rs.'**
  String get pharmacyBookingCurrencyCompact;

  /// No description provided for @pharmacyBookingInvoiceFileName.
  ///
  /// In en, this message translates to:
  /// **'E-Invoice.pdf'**
  String get pharmacyBookingInvoiceFileName;

  /// No description provided for @pharmacyBookingDeliveryCity.
  ///
  /// In en, this message translates to:
  /// **'Islamabad'**
  String get pharmacyBookingDeliveryCity;

  /// No description provided for @pharmacyBookingDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Office #7 2nd Floor Plaza 2000, I-8 Markaz Islamabad.'**
  String get pharmacyBookingDeliveryAddress;

  /// No description provided for @pharmacyBookingOrderStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get pharmacyBookingOrderStatusTitle;

  /// No description provided for @pharmacyBookingStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get pharmacyBookingStatusConfirmed;

  /// No description provided for @pharmacyBookingStatusReadyForDispatch.
  ///
  /// In en, this message translates to:
  /// **'Ready for Dispatch'**
  String get pharmacyBookingStatusReadyForDispatch;

  /// No description provided for @pharmacyBookingStatusDispatched.
  ///
  /// In en, this message translates to:
  /// **'Dispatched / Shipped'**
  String get pharmacyBookingStatusDispatched;

  /// No description provided for @pharmacyBookingStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get pharmacyBookingStatusCompleted;

  /// No description provided for @pharmacyBookingStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order Cancel'**
  String get pharmacyBookingStatusCancelled;

  /// No description provided for @pharmacyBookingFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback'**
  String get pharmacyBookingFeedbackTitle;

  /// No description provided for @pharmacyBookingFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We hope your medications have been helpful. Please take a moment to share your feedback on order #PH123456.'**
  String get pharmacyBookingFeedbackSubtitle;

  /// No description provided for @pharmacyBookingFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Write your feedback...'**
  String get pharmacyBookingFeedbackHint;

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
  /// **'Instant Doctor'**
  String get freeDoctorTitle;

  /// No description provided for @freeDoctorOpenAppCta.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now!'**
  String get freeDoctorOpenAppCta;

  /// No description provided for @freeDoctorOpenAppError.
  ///
  /// In en, this message translates to:
  /// **'Could not open subscription page right now.'**
  String get freeDoctorOpenAppError;

  /// No description provided for @freeDoctorConsultationTitle.
  ///
  /// In en, this message translates to:
  /// **'24/7 Instant Doctor Consultation'**
  String get freeDoctorConsultationTitle;

  /// No description provided for @freeDoctorPoint1.
  ///
  /// In en, this message translates to:
  /// **'This service is available exclusively for M-Health subscribers.'**
  String get freeDoctorPoint1;

  /// No description provided for @freeDoctorPoint2.
  ///
  /// In en, this message translates to:
  /// **'Get 24/7 access to qualified doctors for general medical support and much more.'**
  String get freeDoctorPoint2;

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

  /// No description provided for @accountDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetailsTitle;

  /// No description provided for @accountAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get accountAddTitle;

  /// No description provided for @accountEnterDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Account Details'**
  String get accountEnterDetailsTitle;

  /// No description provided for @accountMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Method'**
  String get accountMethodLabel;

  /// No description provided for @accountNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumberLabel;

  /// No description provided for @accountSaveCta.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get accountSaveCta;

  /// No description provided for @accountContinueCta.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get accountContinueCta;

  /// No description provided for @accountMethodAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment Method Added Successfully'**
  String get accountMethodAddedSuccess;

  /// No description provided for @accountLinkedMessagePrefix.
  ///
  /// In en, this message translates to:
  /// **'Your'**
  String get accountLinkedMessagePrefix;

  /// No description provided for @accountLinkedMessageMiddle.
  ///
  /// In en, this message translates to:
  /// **'account no.'**
  String get accountLinkedMessageMiddle;

  /// No description provided for @accountLinkedMessageSuffix.
  ///
  /// In en, this message translates to:
  /// **'has been linked successfully'**
  String get accountLinkedMessageSuffix;

  /// No description provided for @accountHolderFallback.
  ///
  /// In en, this message translates to:
  /// **'Account Holder'**
  String get accountHolderFallback;

  /// No description provided for @accountValidationEnterNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter account number'**
  String get accountValidationEnterNumber;

  /// No description provided for @accountValidationDigitsOnly.
  ///
  /// In en, this message translates to:
  /// **'Only digits are allowed'**
  String get accountValidationDigitsOnly;

  /// No description provided for @accountValidationElevenDigits.
  ///
  /// In en, this message translates to:
  /// **'Enter 11 digit Pakistan number'**
  String get accountValidationElevenDigits;

  /// No description provided for @accountValidationValidPakistanMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter valid Pakistan mobile number'**
  String get accountValidationValidPakistanMobile;

  /// No description provided for @accountMethodJazzCash.
  ///
  /// In en, this message translates to:
  /// **'JazzCash'**
  String get accountMethodJazzCash;

  /// No description provided for @accountNoAccountsMessage.
  ///
  /// In en, this message translates to:
  /// **'No accounts found.'**
  String get accountNoAccountsMessage;

  /// No description provided for @accountIdLabel.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get accountIdLabel;

  /// No description provided for @accountNumberShortLabel.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get accountNumberShortLabel;

  /// No description provided for @accountDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get accountDefaultLabel;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @dashboardHello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String dashboardHello(String name);

  /// No description provided for @dashboardGuestName.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get dashboardGuestName;

  /// No description provided for @dashboardSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search Medicine, Doctor, Test....'**
  String get dashboardSearchHint;

  /// No description provided for @dashboardOurServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Services'**
  String get dashboardOurServicesTitle;

  /// No description provided for @dashboardSecureHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure Your Health First'**
  String get dashboardSecureHealthTitle;

  /// No description provided for @dashboardFikrfreeTagline.
  ///
  /// In en, this message translates to:
  /// **'Sehat aur insurance ab apke hath mei!'**
  String get dashboardFikrfreeTagline;

  /// No description provided for @dashboardBottomFreeDoctor.
  ///
  /// In en, this message translates to:
  /// **'Instant Doctor'**
  String get dashboardBottomFreeDoctor;

  /// No description provided for @dashboardBottomSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get dashboardBottomSupport;

  /// No description provided for @dashboardBottomBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get dashboardBottomBookings;

  /// No description provided for @dashboardBottomProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get dashboardBottomProfile;

  /// No description provided for @dashboardBottomHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get dashboardBottomHome;

  /// No description provided for @dashboardMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get dashboardMenuTitle;

  /// No description provided for @dashboardMenuCustomerSupport.
  ///
  /// In en, this message translates to:
  /// **'Customer Support'**
  String get dashboardMenuCustomerSupport;

  /// No description provided for @dashboardMenuFaq.
  ///
  /// In en, this message translates to:
  /// **'FAQ’s'**
  String get dashboardMenuFaq;

  /// No description provided for @dashboardMenuGuestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get dashboardMenuGuestUser;

  /// No description provided for @dashboardMenuSignInManageAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your account'**
  String get dashboardMenuSignInManageAccount;

  /// No description provided for @dashboardMenuSignInContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get dashboardMenuSignInContinue;

  /// No description provided for @dashboardMenuLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get dashboardMenuLogout;

  /// No description provided for @dashboardMenuAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get dashboardMenuAbout;

  /// No description provided for @dashboardMenuAppVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get dashboardMenuAppVersion;

  /// No description provided for @dashboardMenuTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get dashboardMenuTerms;

  /// No description provided for @dashboardMenuPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get dashboardMenuPrivacy;

  /// No description provided for @dashboardMenuEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get dashboardMenuEditProfile;

  /// No description provided for @dashboardMenuLoginSignup.
  ///
  /// In en, this message translates to:
  /// **'Login / Signup'**
  String get dashboardMenuLoginSignup;

  /// No description provided for @dashboardLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout from your account?'**
  String get dashboardLogoutMessage;

  /// No description provided for @dashboardCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dashboardCancel;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsRetryCta.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get notificationsRetryCta;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Notifications Yet!'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load notifications. Pull to refresh or try again.'**
  String get notificationsLoadError;

  /// No description provided for @searchScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchScreenTitle;

  /// No description provided for @searchListeningHint.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get searchListeningHint;

  /// No description provided for @searchRecentSearchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get searchRecentSearchesTitle;

  /// No description provided for @searchPopularSearchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Popular Searches'**
  String get searchPopularSearchesTitle;

  /// No description provided for @searchSeeAllCta.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get searchSeeAllCta;

  /// No description provided for @searchForQuery.
  ///
  /// In en, this message translates to:
  /// **'Search for \"{query}\"'**
  String searchForQuery(String query);

  /// Title for the lab test browse screen app bar
  ///
  /// In en, this message translates to:
  /// **'Lab Test'**
  String get labTestScreenTitle;

  /// No description provided for @surgeryScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Procedures & Surgeries'**
  String get surgeryScreenTitle;

  /// No description provided for @surgeryBookingScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Surgery Booking'**
  String get surgeryBookingScreenTitle;

  /// No description provided for @surgeryNoProceduresMessage.
  ///
  /// In en, this message translates to:
  /// **'No surgery procedures available right now.'**
  String get surgeryNoProceduresMessage;

  /// No description provided for @surgerySelectForSurgery.
  ///
  /// In en, this message translates to:
  /// **'Select for Surgery'**
  String get surgerySelectForSurgery;

  /// No description provided for @surgeryLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get surgeryLocationLabel;

  /// No description provided for @commonChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get commonChange;

  /// No description provided for @surgerySearchNameHint.
  ///
  /// In en, this message translates to:
  /// **'Search name..'**
  String get surgerySearchNameHint;

  /// No description provided for @surgerySelectCityTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a city'**
  String get surgerySelectCityTitle;

  /// No description provided for @surgerySearchByNameHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get surgerySearchByNameHint;

  /// No description provided for @commonProceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get commonProceed;

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
  /// **'Select a city'**
  String get labTestSelectCitySheetTitle;

  /// No description provided for @labTestSelectCitySheetSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
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

  /// No description provided for @labTestViewDetailsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load details. Please try again.'**
  String get labTestViewDetailsLoadError;

  /// No description provided for @labTestSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get labTestSomethingWentWrong;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @labTestViewDetailsResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Results'**
  String get labTestViewDetailsResultsTitle;

  /// No description provided for @labTestViewDetailsOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get labTestViewDetailsOrderTitle;

  /// No description provided for @labTestDiscountCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Discount code copied'**
  String get labTestDiscountCodeCopied;

  /// No description provided for @labTestOrderNoPrefix.
  ///
  /// In en, this message translates to:
  /// **'Order no.'**
  String get labTestOrderNoPrefix;

  /// No description provided for @labTestBookingDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking Date'**
  String get labTestBookingDateLabel;

  /// No description provided for @labTestTotalFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Fee'**
  String get labTestTotalFeeLabel;

  /// No description provided for @labTestDiscountCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount Code'**
  String get labTestDiscountCodeLabel;

  /// No description provided for @labTestShowCodeInstruction.
  ///
  /// In en, this message translates to:
  /// **'Show this code to the lab representative'**
  String get labTestShowCodeInstruction;

  /// No description provided for @labTestCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get labTestCheckoutTitle;

  /// No description provided for @labTestCheckoutRequiredFieldsError.
  ///
  /// In en, this message translates to:
  /// **'Please fill all the required fields'**
  String get labTestCheckoutRequiredFieldsError;

  /// No description provided for @labTestCheckoutBookedTitle.
  ///
  /// In en, this message translates to:
  /// **'Lab Test Booked Successfully'**
  String get labTestCheckoutBookedTitle;

  /// No description provided for @labTestCheckoutBookedMessage.
  ///
  /// In en, this message translates to:
  /// **'A lab representative will contact you shortly.\nPresent your discount code to the lab representative.\nTo access your code later:'**
  String get labTestCheckoutBookedMessage;

  /// No description provided for @labTestCheckoutBookedPathHint.
  ///
  /// In en, this message translates to:
  /// **'Menu > My Bookings > Lab Test'**
  String get labTestCheckoutBookedPathHint;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @labTestBookingMethodWalkInCompact.
  ///
  /// In en, this message translates to:
  /// **'Walk In'**
  String get labTestBookingMethodWalkInCompact;

  /// No description provided for @labTestCheckoutFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get labTestCheckoutFeeLabel;

  /// No description provided for @labTestCheckoutDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get labTestCheckoutDiscountLabel;

  /// No description provided for @labTestCheckoutTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get labTestCheckoutTotalLabel;

  /// No description provided for @labTestPatientDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Patient Details'**
  String get labTestPatientDetailsTitle;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @labTestEmergencyContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get labTestEmergencyContactTitle;

  /// No description provided for @labTestEmergencyContactHintText.
  ///
  /// In en, this message translates to:
  /// **'Please provide an emergency contact number, incase you are unavailable.'**
  String get labTestEmergencyContactHintText;

  /// No description provided for @labTestEmergencyNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Number here...'**
  String get labTestEmergencyNumberHint;

  /// No description provided for @labTestPatientNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get labTestPatientNameLabel;

  /// No description provided for @labTestContactNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get labTestContactNumberLabel;

  /// No description provided for @labTestAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get labTestAddressLabel;

  /// No description provided for @labTestFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get labTestFullNameHint;

  /// No description provided for @labTestPhonebookHint.
  ///
  /// In en, this message translates to:
  /// **'Type or select from phonebook'**
  String get labTestPhonebookHint;

  /// No description provided for @labTestAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get labTestAgeLabel;

  /// No description provided for @labTestAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Type address here...'**
  String get labTestAddressHint;

  /// No description provided for @commonMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get commonMale;

  /// No description provided for @commonFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get commonFemale;

  /// No description provided for @labTestBookCta.
  ///
  /// In en, this message translates to:
  /// **'Book Lab Test'**
  String get labTestBookCta;

  /// No description provided for @consultationAiScreeningTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Screening'**
  String get consultationAiScreeningTitle;

  /// No description provided for @consultationAiWelcomePrefix.
  ///
  /// In en, this message translates to:
  /// **'Hello, welcome to '**
  String get consultationAiWelcomePrefix;

  /// No description provided for @consultationAiWelcomeSuffix.
  ///
  /// In en, this message translates to:
  /// **' , let\'s get started'**
  String get consultationAiWelcomeSuffix;

  /// No description provided for @consultationAiStartCta.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Start'**
  String get consultationAiStartCta;

  /// No description provided for @consultationSelectCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Categories'**
  String get consultationSelectCategoriesTitle;

  /// No description provided for @consultationSpecialistTitle.
  ///
  /// In en, this message translates to:
  /// **'Specialist'**
  String get consultationSpecialistTitle;

  /// No description provided for @consultationVideoBookingPrompt.
  ///
  /// In en, this message translates to:
  /// **'Book your video consultation here!'**
  String get consultationVideoBookingPrompt;

  /// No description provided for @consultationGetAppointmentCta.
  ///
  /// In en, this message translates to:
  /// **'Get Appointment'**
  String get consultationGetAppointmentCta;

  /// No description provided for @consultationBookingConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment Confirmed!'**
  String get consultationBookingConfirmedTitle;

  /// No description provided for @consultationBookingConfirmedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your consultation has been booked with {doctorName}. You can join the call from Appointments.'**
  String consultationBookingConfirmedMessage(Object doctorName);

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @consultationUploadDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get consultationUploadDocumentTitle;

  /// No description provided for @consultationUseCamera.
  ///
  /// In en, this message translates to:
  /// **'Use camera'**
  String get consultationUseCamera;

  /// No description provided for @consultationUploadFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Upload from gallery'**
  String get consultationUploadFromGallery;

  /// No description provided for @consultationUploadFromFile.
  ///
  /// In en, this message translates to:
  /// **'Upload from File'**
  String get consultationUploadFromFile;

  /// No description provided for @consultationCameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera access is unavailable right now.'**
  String get consultationCameraUnavailable;

  /// No description provided for @consultationCaptureMediaFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not capture media. Please try again.'**
  String get consultationCaptureMediaFailed;

  /// No description provided for @consultationGalleryUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Gallery access is unavailable right now.'**
  String get consultationGalleryUnavailable;

  /// No description provided for @consultationPickGalleryFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not pick media from gallery.'**
  String get consultationPickGalleryFailed;

  /// No description provided for @consultationPickFileFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not pick file. Please try again.'**
  String get consultationPickFileFailed;

  /// No description provided for @consultationPaymentMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get consultationPaymentMethodTitle;

  /// No description provided for @consultationVideoConsultationLabel.
  ///
  /// In en, this message translates to:
  /// **'Video Consultation'**
  String get consultationVideoConsultationLabel;

  /// No description provided for @consultationConsultationFeesLabel.
  ///
  /// In en, this message translates to:
  /// **'Consultation Fees'**
  String get consultationConsultationFeesLabel;

  /// No description provided for @consultationDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get consultationDiscountLabel;

  /// No description provided for @consultationTotalChargesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Charges'**
  String get consultationTotalChargesLabel;

  /// No description provided for @consultationSelectAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Account'**
  String get consultationSelectAccountTitle;

  /// No description provided for @consultationProceedCta.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get consultationProceedCta;

  /// No description provided for @consultationJazzCashChargeDescription.
  ///
  /// In en, this message translates to:
  /// **'Amount will be charged from your jazz cash account.'**
  String get consultationJazzCashChargeDescription;

  /// No description provided for @consultationRequiredFieldsError.
  ///
  /// In en, this message translates to:
  /// **'Please fill all the required fields'**
  String get consultationRequiredFieldsError;

  /// No description provided for @consultationSelectSlotError.
  ///
  /// In en, this message translates to:
  /// **'Please select a slot for video consultation'**
  String get consultationSelectSlotError;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @bookingsDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get bookingsDashboardTitle;

  /// No description provided for @bookingsTabDoctorConsultation.
  ///
  /// In en, this message translates to:
  /// **'Doctor Consultation'**
  String get bookingsTabDoctorConsultation;

  /// No description provided for @bookingsTabSurgery.
  ///
  /// In en, this message translates to:
  /// **'Surgery'**
  String get bookingsTabSurgery;

  /// No description provided for @bookingsTabLabTest.
  ///
  /// In en, this message translates to:
  /// **'Lab Test'**
  String get bookingsTabLabTest;

  /// No description provided for @bookingsTabPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get bookingsTabPharmacy;

  /// No description provided for @bookingsLabTestEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'No lab test bookings yet.'**
  String get bookingsLabTestEmptyDescription;

  /// No description provided for @bookingsSurgeryEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'No surgery bookings yet.'**
  String get bookingsSurgeryEmptyDescription;

  /// No description provided for @bookingsStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get bookingsStatusLabel;

  /// No description provided for @bookingsDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get bookingsDateLabel;

  /// No description provided for @bookingsDateCreatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Date Created'**
  String get bookingsDateCreatedLabel;

  /// No description provided for @bookingsViewDetailsCta.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get bookingsViewDetailsCta;

  /// No description provided for @bookingsFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get bookingsFeeLabel;

  /// No description provided for @bookingsTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get bookingsTotalLabel;

  /// No description provided for @bookingsSurgeryProcedureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Photorefractive keratectomy Surgery'**
  String get bookingsSurgeryProcedureSubtitle;

  /// No description provided for @bookingsSurgeryPatientName.
  ///
  /// In en, this message translates to:
  /// **'Haseeb Qasim'**
  String get bookingsSurgeryPatientName;

  /// No description provided for @bookingsProceedCheckoutCta.
  ///
  /// In en, this message translates to:
  /// **'Proceed Checkout'**
  String get bookingsProceedCheckoutCta;

  /// No description provided for @bookingsRequirementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get bookingsRequirementsTitle;

  /// No description provided for @bookingsSurgeryRequirement1.
  ///
  /// In en, this message translates to:
  /// **'Fast for 9-12 Hours before Appointment time'**
  String get bookingsSurgeryRequirement1;

  /// No description provided for @bookingsSurgeryRequirement2.
  ///
  /// In en, this message translates to:
  /// **'Avoid Stenious Physical Activ ity the day of the appointment'**
  String get bookingsSurgeryRequirement2;

  /// No description provided for @bookingsSurgeryRequirement3.
  ///
  /// In en, this message translates to:
  /// **'Ensure that you are NOTtaking any antibiotic medication course'**
  String get bookingsSurgeryRequirement3;

  /// No description provided for @bookingsDetailsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load booking details. Please try again.'**
  String get bookingsDetailsLoadError;

  /// No description provided for @bookingsStatusPending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get bookingsStatusPending;

  /// No description provided for @bookingsStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'CONFIRMED'**
  String get bookingsStatusConfirmed;

  /// No description provided for @bookingsStatusCancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get bookingsStatusCancel;

  /// No description provided for @bookingsStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get bookingsStatusCompleted;

  /// No description provided for @bookingsPatientLabel.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get bookingsPatientLabel;

  /// No description provided for @bookingsIssueLabel.
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get bookingsIssueLabel;

  /// No description provided for @bookingsBillingTitle.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get bookingsBillingTitle;

  /// No description provided for @bookingsEInvoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'E-Invoice'**
  String get bookingsEInvoiceLabel;

  /// No description provided for @bookingsConsultationFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Consultation fee'**
  String get bookingsConsultationFeeLabel;

  /// No description provided for @bookingsDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount (100%)'**
  String get bookingsDiscountLabel;

  /// No description provided for @bookingsJoinNowCta.
  ///
  /// In en, this message translates to:
  /// **'Join Now'**
  String get bookingsJoinNowCta;

  /// No description provided for @labTestSampleTypeBlood.
  ///
  /// In en, this message translates to:
  /// **'Blood'**
  String get labTestSampleTypeBlood;
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
