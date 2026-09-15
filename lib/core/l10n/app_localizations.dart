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

  /// No description provided for @profileImageSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get profileImageSourceTitle;

  /// No description provided for @profileUseCamera.
  ///
  /// In en, this message translates to:
  /// **'Use camera'**
  String get profileUseCamera;

  /// No description provided for @profileChooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get profileChooseFromGallery;

  /// No description provided for @profileCameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera access is unavailable right now.'**
  String get profileCameraUnavailable;

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
  /// **'Search medicine'**
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

  /// No description provided for @pharmacyCartUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to update cart right now. Please try again.'**
  String get pharmacyCartUpdateFailed;

  /// No description provided for @pharmacyCartBadgeOverflow.
  ///
  /// In en, this message translates to:
  /// **'99+'**
  String get pharmacyCartBadgeOverflow;

  /// No description provided for @pharmacyRemoveFromCart.
  ///
  /// In en, this message translates to:
  /// **'Remove from cart'**
  String get pharmacyRemoveFromCart;

  /// No description provided for @pharmacyAbandonUnpaidOrderCta.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t pay? Cancel and return to cart'**
  String get pharmacyAbandonUnpaidOrderCta;

  /// No description provided for @pharmacyAbandonUnpaidOrderFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to cancel the unpaid order right now. Please try again.'**
  String get pharmacyAbandonUnpaidOrderFailed;

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
  /// **'Write any special instructions here'**
  String get pharmacyCheckoutSpecialInstructionsHint;

  /// No description provided for @pharmacyCheckoutOrderDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get pharmacyCheckoutOrderDetailsTitle;

  /// No description provided for @pharmacyCheckoutSubtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get pharmacyCheckoutSubtotalLabel;

  /// No description provided for @pharmacyCheckoutDeliveryChargesLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Charges'**
  String get pharmacyCheckoutDeliveryChargesLabel;

  /// No description provided for @pharmacyCheckoutDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
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

  /// No description provided for @pharmacyCheckoutPrescriptionNotice.
  ///
  /// In en, this message translates to:
  /// **'Prescription is required for some items. Customer representative will contact you shortly.'**
  String get pharmacyCheckoutPrescriptionNotice;

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

  /// No description provided for @pharmacyCheckoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to place pharmacy order right now. Please try again.'**
  String get pharmacyCheckoutFailed;

  /// No description provided for @pharmacyCheckoutPaymentPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get pharmacyCheckoutPaymentPendingTitle;

  /// No description provided for @pharmacyCheckoutPaymentPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your pharmacy order is waiting for payment. We\'ll update it once payment completes — check Bookings for the latest status.'**
  String get pharmacyCheckoutPaymentPendingMessage;

  /// No description provided for @pharmacyOrderPlacedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Successfully Placed!'**
  String get pharmacyOrderPlacedTitle;

  /// No description provided for @pharmacyOrderPlacedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your order number {orderNo} has been placed and will be processed soon. A representative will reach out to you for order confirmation.'**
  String pharmacyOrderPlacedMessage(String orderNo);

  /// No description provided for @pharmacyOrderPlacedViewOrdersCta.
  ///
  /// In en, this message translates to:
  /// **'View My Orders'**
  String get pharmacyOrderPlacedViewOrdersCta;

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

  /// No description provided for @onboardingInstantDoctorTitle.
  ///
  /// In en, this message translates to:
  /// **'24/7 Instant Doctor'**
  String get onboardingInstantDoctorTitle;

  /// No description provided for @onboardingInstantDoctorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get instant doctor consultation 24/7 round the clock.'**
  String get onboardingInstantDoctorSubtitle;

  /// No description provided for @onboardingBookConsultationTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Consultation'**
  String get onboardingBookConsultationTitle;

  /// No description provided for @onboardingBookConsultationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book online consultation with PMDC certified specialist doctors'**
  String get onboardingBookConsultationSubtitle;

  /// No description provided for @onboardingPharmacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Medicine'**
  String get onboardingPharmacyTitle;

  /// No description provided for @onboardingPharmacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get authentic medicines delivered at your doorstep.'**
  String get onboardingPharmacySubtitle;

  /// No description provided for @onboardingLaboratoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Lab Test'**
  String get onboardingLaboratoryTitle;

  /// No description provided for @onboardingLaboratorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access lab tests from your trusted labs with free home sampling'**
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

  /// Badge shown when a medicine requires a prescription
  ///
  /// In en, this message translates to:
  /// **'REQUIRES PRESCRIPTION'**
  String get pharmacyRequiresPrescription;

  /// No description provided for @pharmacyPrescriptionRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'This medicine requires a valid doctor prescription. Please upload a prescription.'**
  String get pharmacyPrescriptionRequiredMessage;

  /// No description provided for @pharmacyPrescriptionUploadHint.
  ///
  /// In en, this message translates to:
  /// **'Click to upload prescription'**
  String get pharmacyPrescriptionUploadHint;

  /// No description provided for @pharmacyPrescriptionUploadFormats.
  ///
  /// In en, this message translates to:
  /// **'PNG, JPEG, WEBP, PDF supported (Max 5MB)'**
  String get pharmacyPrescriptionUploadFormats;

  /// No description provided for @pharmacyPrescriptionRemoveFile.
  ///
  /// In en, this message translates to:
  /// **'Remove file'**
  String get pharmacyPrescriptionRemoveFile;

  /// No description provided for @pharmacyPrescriptionRequiredToAdd.
  ///
  /// In en, this message translates to:
  /// **'Please upload a prescription before adding to cart.'**
  String get pharmacyPrescriptionRequiredToAdd;

  /// No description provided for @pharmacyPrescriptionUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Prescription upload failed. Please try again.'**
  String get pharmacyPrescriptionUploadFailed;

  /// No description provided for @pharmacyPrescriptionPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to pick prescription file. Please try again.'**
  String get pharmacyPrescriptionPickFailed;

  /// No description provided for @pharmacyPrescriptionInvalidType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file type. Use PNG, JPEG, WEBP, or PDF.'**
  String get pharmacyPrescriptionInvalidType;

  /// No description provided for @pharmacyPrescriptionTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File is too large. Maximum size is 5MB.'**
  String get pharmacyPrescriptionTooLarge;

  /// No description provided for @pharmacyPrescriptionUploadedLabel.
  ///
  /// In en, this message translates to:
  /// **'Prescription uploaded'**
  String get pharmacyPrescriptionUploadedLabel;

  /// No description provided for @pharmacyPrescriptionUploadedHint.
  ///
  /// In en, this message translates to:
  /// **'A prescription is already attached for this medicine.'**
  String get pharmacyPrescriptionUploadedHint;

  /// No description provided for @pharmacyPrescriptionReupload.
  ///
  /// In en, this message translates to:
  /// **'Re-upload'**
  String get pharmacyPrescriptionReupload;

  /// No description provided for @pharmacyPrescriptionKeepCurrent.
  ///
  /// In en, this message translates to:
  /// **'Keep current'**
  String get pharmacyPrescriptionKeepCurrent;

  /// No description provided for @pharmacyAddToCartFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to add to cart right now. Please try again.'**
  String get pharmacyAddToCartFailed;

  /// No description provided for @instantDoctorTitle.
  ///
  /// In en, this message translates to:
  /// **'Instant Doctor'**
  String get instantDoctorTitle;

  /// No description provided for @instantDoctorOpenAppCta.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now!'**
  String get instantDoctorOpenAppCta;

  /// No description provided for @instantDoctorOpenAppError.
  ///
  /// In en, this message translates to:
  /// **'Could not open subscription page right now.'**
  String get instantDoctorOpenAppError;

  /// No description provided for @instantDoctorMediaPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Allow camera and microphone access in Settings to start the video consultation.'**
  String get instantDoctorMediaPermissionDenied;

  /// No description provided for @instantDoctorSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get instantDoctorSubscribe;

  /// No description provided for @instantDoctorStartConsultation.
  ///
  /// In en, this message translates to:
  /// **'Start Consultation'**
  String get instantDoctorStartConsultation;

  /// No description provided for @instantDoctorSubscribed.
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get instantDoctorSubscribed;

  /// No description provided for @instantDoctorNoProviders.
  ///
  /// In en, this message translates to:
  /// **'No instant doctor plans available right now.'**
  String get instantDoctorNoProviders;

  /// No description provided for @instantDoctorPlanDetails.
  ///
  /// In en, this message translates to:
  /// **'Plan details'**
  String get instantDoctorPlanDetails;

  /// No description provided for @instantDoctorOtpInstruction.
  ///
  /// In en, this message translates to:
  /// **'A 4 digit OTP code is sent to your number. Please enter the code below to proceed'**
  String get instantDoctorOtpInstruction;

  /// No description provided for @instantDoctorOtpUnsubscribeInstruction.
  ///
  /// In en, this message translates to:
  /// **'A 4 digit OTP code is sent to your number. Please enter the code below to unsubscribe this service'**
  String get instantDoctorOtpUnsubscribeInstruction;

  /// No description provided for @instantDoctorSubscribeSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Successfully Subscribed!'**
  String get instantDoctorSubscribeSuccessTitle;

  /// No description provided for @instantDoctorSubscribeSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You have successfully subscribed to {providerName}. Consult a doctor any time instantly'**
  String instantDoctorSubscribeSuccessMessage(String providerName);

  /// No description provided for @instantDoctorSubscribeFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription Failed!'**
  String get instantDoctorSubscribeFailedTitle;

  /// No description provided for @instantDoctorSubscribeFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately some error has occurred. Please try again.'**
  String get instantDoctorSubscribeFailedMessage;

  /// No description provided for @instantDoctorClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get instantDoctorClose;

  /// No description provided for @instantDoctorCancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get instantDoctorCancelSubscription;

  /// No description provided for @instantDoctorCancelSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unsubscribe?'**
  String get instantDoctorCancelSubscriptionTitle;

  /// No description provided for @instantDoctorCancelSubscriptionMessage.
  ///
  /// In en, this message translates to:
  /// **'This service will be unsubscribed from your account.'**
  String get instantDoctorCancelSubscriptionMessage;

  /// No description provided for @instantDoctorCancelSubscriptionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe'**
  String get instantDoctorCancelSubscriptionConfirm;

  /// No description provided for @instantDoctorCancelSubscriptionDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get instantDoctorCancelSubscriptionDiscard;

  /// No description provided for @instantDoctorCancelSubscriptionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Subscription cancelled successfully.'**
  String get instantDoctorCancelSubscriptionSuccess;

  /// No description provided for @instantDoctorCancelSubscriptionFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to cancel subscription. Please try again.'**
  String get instantDoctorCancelSubscriptionFailed;

  /// No description provided for @instantDoctorConsultationTitle.
  ///
  /// In en, this message translates to:
  /// **'24/7 Instant Doctor Consultation'**
  String get instantDoctorConsultationTitle;

  /// No description provided for @instantDoctorConsultationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Consult a doctor instantly and any time by choosing a package of your choice.'**
  String get instantDoctorConsultationSubtitle;

  /// No description provided for @instantDoctorPoint1.
  ///
  /// In en, this message translates to:
  /// **'This service is available exclusively for M-Health subscribers.'**
  String get instantDoctorPoint1;

  /// No description provided for @instantDoctorPoint2.
  ///
  /// In en, this message translates to:
  /// **'Get 24/7 access to qualified doctors for general medical support and much more.'**
  String get instantDoctorPoint2;

  /// No description provided for @instantDoctorConsultationExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit consultation?'**
  String get instantDoctorConsultationExitTitle;

  /// No description provided for @instantDoctorConsultationExitMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit from this video Consultation?'**
  String get instantDoctorConsultationExitMessage;

  /// No description provided for @instantDoctorConsultationExitCta.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get instantDoctorConsultationExitCta;

  /// No description provided for @instantDoctorConsultationExitCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get instantDoctorConsultationExitCancel;

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

  /// No description provided for @accountAddFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to Add Account'**
  String get accountAddFailedTitle;

  /// No description provided for @accountAddFailedFallback.
  ///
  /// In en, this message translates to:
  /// **'Account could not be added. Please try again.'**
  String get accountAddFailedFallback;

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
  /// **'Search doctor, medicine, lab tests...'**
  String get dashboardSearchHint;

  /// No description provided for @dashboardInstantDoctorDescription.
  ///
  /// In en, this message translates to:
  /// **'Consult a certified doctor any time of the day instantly without appointment'**
  String get dashboardInstantDoctorDescription;

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

  /// No description provided for @dashboardBottomInstantDoctor.
  ///
  /// In en, this message translates to:
  /// **'Instant Doctor'**
  String get dashboardBottomInstantDoctor;

  /// No description provided for @dashboardBottomSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get dashboardBottomSupport;

  /// No description provided for @dashboardBottomBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
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

  /// No description provided for @dashboardCloseAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get dashboardCloseAppTitle;

  /// No description provided for @dashboardCloseAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit Apna Clinic?'**
  String get dashboardCloseAppMessage;

  /// No description provided for @dashboardCloseAppCta.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get dashboardCloseAppCta;

  /// No description provided for @dashboardAppUpdateAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get dashboardAppUpdateAvailableTitle;

  /// No description provided for @dashboardAppUpdateRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get dashboardAppUpdateRequiredTitle;

  /// No description provided for @dashboardAppUpdateAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'A newer version of Apna Clinic is available. Update now for the latest features and improvements.'**
  String get dashboardAppUpdateAvailableMessage;

  /// No description provided for @dashboardAppUpdateRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Please update Apna Clinic to continue using the app.'**
  String get dashboardAppUpdateRequiredMessage;

  /// No description provided for @dashboardAppUpdateCta.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get dashboardAppUpdateCta;

  /// No description provided for @dashboardAppUpdateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get dashboardAppUpdateLater;

  /// No description provided for @dashboardAppUpdateVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Current {currentVersion} → {latestVersion}'**
  String dashboardAppUpdateVersionLabel(
    String currentVersion,
    String latestVersion,
  );

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

  /// No description provided for @notificationsDeepLinkUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Details unavailable'**
  String get notificationsDeepLinkUnavailableTitle;

  /// No description provided for @notificationsDeepLinkUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'This notification cannot be opened. The booking or order reference may be missing or unsupported.'**
  String get notificationsDeepLinkUnavailableMessage;

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

  /// No description provided for @searchVoicePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Allow microphone access in Settings to use voice search.'**
  String get searchVoicePermissionDenied;

  /// No description provided for @searchVoiceNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Voice search is not available on this emulator. Use a physical phone with Google speech services.'**
  String get searchVoiceNotAvailable;

  /// No description provided for @searchVoiceRebuildRequired.
  ///
  /// In en, this message translates to:
  /// **'Voice search needs a full app restart. Stop the app, then run flutter run (not hot restart).'**
  String get searchVoiceRebuildRequired;

  /// No description provided for @searchVoiceFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not start voice search. Please try again.'**
  String get searchVoiceFailed;

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

  /// No description provided for @searchNoResultsFor.
  ///
  /// In en, this message translates to:
  /// **'No result found for \"{query}\"'**
  String searchNoResultsFor(String query);

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

  /// No description provided for @surgeryNoDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get surgeryNoDataFound;

  /// No description provided for @commonReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get commonReset;

  /// No description provided for @surgeryPatientValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields.'**
  String get surgeryPatientValidationMessage;

  /// No description provided for @surgeryEmergencyContactRequired.
  ///
  /// In en, this message translates to:
  /// **'Please add emergency contact number.'**
  String get surgeryEmergencyContactRequired;

  /// No description provided for @surgeryAgeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid age.'**
  String get surgeryAgeInvalid;

  /// No description provided for @surgeryPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number.'**
  String get surgeryPhoneInvalid;

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

  /// No description provided for @commonApplyFilter.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get commonApplyFilter;

  /// No description provided for @surgeryPatientDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Patient Details'**
  String get surgeryPatientDetailsTitle;

  /// No description provided for @surgeryPatientNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get surgeryPatientNameLabel;

  /// No description provided for @surgeryPatientNameHint.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get surgeryPatientNameHint;

  /// No description provided for @surgeryPatientNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter patient name'**
  String get surgeryPatientNameError;

  /// No description provided for @surgeryPatientAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get surgeryPatientAgeLabel;

  /// No description provided for @surgeryPatientAgeHint.
  ///
  /// In en, this message translates to:
  /// **'Patient Age'**
  String get surgeryPatientAgeHint;

  /// No description provided for @surgeryPatientAgeError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid age'**
  String get surgeryPatientAgeError;

  /// No description provided for @surgeryContactNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get surgeryContactNumberLabel;

  /// No description provided for @surgeryContactNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Patient Contact Number'**
  String get surgeryContactNumberHint;

  /// No description provided for @surgeryContactNumberError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get surgeryContactNumberError;

  /// No description provided for @surgeryEmergencyContactLabel.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get surgeryEmergencyContactLabel;

  /// No description provided for @surgeryEmergencyContactHint.
  ///
  /// In en, this message translates to:
  /// **'Patient Emergency Contact'**
  String get surgeryEmergencyContactHint;

  /// No description provided for @surgeryEmergencyContactError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get surgeryEmergencyContactError;

  /// No description provided for @surgeryLabel.
  ///
  /// In en, this message translates to:
  /// **'Surgery'**
  String get surgeryLabel;

  /// No description provided for @surgeryProceedCheckout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get surgeryProceedCheckout;

  /// No description provided for @surgeryStartingFrom.
  ///
  /// In en, this message translates to:
  /// **'Starting from'**
  String get surgeryStartingFrom;

  /// No description provided for @surgeryBookingSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Request Submitted'**
  String get surgeryBookingSubmittedTitle;

  /// No description provided for @surgeryBookingSubmittedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your surgery request has been received. Our representative will contact you within 24 hours to gather your medical history and relevant details for confirmation.'**
  String get surgeryBookingSubmittedMessage;

  /// No description provided for @surgeryBookingViewBookingsCta.
  ///
  /// In en, this message translates to:
  /// **'View My Bookings'**
  String get surgeryBookingViewBookingsCta;

  /// No description provided for @surgeryBookingPaymentPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get surgeryBookingPaymentPendingTitle;

  /// No description provided for @surgeryBookingPaymentPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your surgery booking is waiting for payment. We\'ll update it once payment completes — check Bookings for the latest status.'**
  String get surgeryBookingPaymentPendingMessage;

  /// No description provided for @surgeryBookingFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Request Failed'**
  String get surgeryBookingFailedTitle;

  /// No description provided for @surgeryTypesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load surgery types. Please try again.'**
  String get surgeryTypesLoadFailed;

  /// No description provided for @surgerySubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to submit booking request. Please try again.'**
  String get surgerySubmitFailed;

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

  /// No description provided for @selectCityTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a city'**
  String get selectCityTitle;

  /// No description provided for @selectCitySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get selectCitySearchHint;

  /// No description provided for @selectCityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No cities available'**
  String get selectCityEmpty;

  /// No description provided for @selectCityNoResults.
  ///
  /// In en, this message translates to:
  /// **'No cities found'**
  String get selectCityNoResults;

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

  /// No description provided for @labTestSampleTypeNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get labTestSampleTypeNotAvailable;

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

  /// No description provided for @labTestNoRecordFound.
  ///
  /// In en, this message translates to:
  /// **'No Record Found'**
  String get labTestNoRecordFound;

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

  /// No description provided for @paymentWebViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Card Payment'**
  String get paymentWebViewTitle;

  /// No description provided for @paymentWebViewLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load the payment page. Please try again.'**
  String get paymentWebViewLoadError;

  /// No description provided for @paymentWebViewFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed. Please try again.'**
  String get paymentWebViewFailed;

  /// No description provided for @paymentWebViewFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentWebViewFailedTitle;

  /// No description provided for @paymentWebViewCancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment cancelled.'**
  String get paymentWebViewCancelled;

  /// No description provided for @paymentWebViewCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Cancelled'**
  String get paymentWebViewCancelledTitle;

  /// No description provided for @paymentWebViewCancelledMessage.
  ///
  /// In en, this message translates to:
  /// **'Your payment was cancelled. You can try again when you are ready.'**
  String get paymentWebViewCancelledMessage;

  /// No description provided for @paymentPendingViewBookingsCta.
  ///
  /// In en, this message translates to:
  /// **'View My Bookings'**
  String get paymentPendingViewBookingsCta;

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

  /// No description provided for @labTestReportPendingNote.
  ///
  /// In en, this message translates to:
  /// **'Your report will be available once the lab completes processing.'**
  String get labTestReportPendingNote;

  /// No description provided for @labTestReportAvailableNote.
  ///
  /// In en, this message translates to:
  /// **'Your report is ready. You can download it from the test results section.'**
  String get labTestReportAvailableNote;

  /// No description provided for @labTestDownloadReport.
  ///
  /// In en, this message translates to:
  /// **'Download Report'**
  String get labTestDownloadReport;

  /// No description provided for @labTestDownloadReportFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to download the report. Please try again.'**
  String get labTestDownloadReportFailed;

  /// No description provided for @bookingsInvoiceDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to open the invoice. Please try again.'**
  String get bookingsInvoiceDownloadFailed;

  /// No description provided for @pdfViewerShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get pdfViewerShare;

  /// No description provided for @pdfViewerDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get pdfViewerDownload;

  /// No description provided for @pdfViewerShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to share the PDF. Please try again.'**
  String get pdfViewerShareFailed;

  /// No description provided for @pdfViewerDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to save the PDF. Please try again.'**
  String get pdfViewerDownloadFailed;

  /// No description provided for @pdfViewerSaved.
  ///
  /// In en, this message translates to:
  /// **'PDF saved'**
  String get pdfViewerSaved;

  /// No description provided for @labTestInvoiceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get labTestInvoiceSectionTitle;

  /// No description provided for @labTestInvoiceFileName.
  ///
  /// In en, this message translates to:
  /// **'E-Invoice.pdf'**
  String get labTestInvoiceFileName;

  /// No description provided for @labTestDiscountCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Discount code copied'**
  String get labTestDiscountCodeCopied;

  /// No description provided for @labTestOrderNoPrefix.
  ///
  /// In en, this message translates to:
  /// **'Order No.'**
  String get labTestOrderNoPrefix;

  /// No description provided for @labTestBookingCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lab Test Report'**
  String get labTestBookingCardSubtitle;

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

  /// No description provided for @labTestCheckoutPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile or landline number.'**
  String get labTestCheckoutPhoneInvalid;

  /// No description provided for @labTestCheckoutBookedTitle.
  ///
  /// In en, this message translates to:
  /// **'Lab Test Booked!'**
  String get labTestCheckoutBookedTitle;

  /// No description provided for @labTestCheckoutBookedMessage.
  ///
  /// In en, this message translates to:
  /// **'A lab representative will reach out to you soon to confirm your booking.\nYou can view your booking in Bookings Tab.'**
  String get labTestCheckoutBookedMessage;

  /// No description provided for @labTestCheckoutPaymentPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get labTestCheckoutPaymentPendingTitle;

  /// No description provided for @labTestCheckoutPaymentPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your lab booking is waiting for payment. We\'ll update it once payment completes — check Bookings for the latest status.'**
  String get labTestCheckoutPaymentPendingMessage;

  /// No description provided for @labTestAbandonUnpaidOrderCta.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t pay? Cancel unpaid booking'**
  String get labTestAbandonUnpaidOrderCta;

  /// No description provided for @labTestAbandonUnpaidOrderFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to cancel the unpaid booking right now. Please try again.'**
  String get labTestAbandonUnpaidOrderFailed;

  /// No description provided for @labTestCheckoutViewBookingsCta.
  ///
  /// In en, this message translates to:
  /// **'View My Bookings'**
  String get labTestCheckoutViewBookingsCta;

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
  /// **'Enter Number here.'**
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

  /// No description provided for @consultationAiScreeningExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Close AI Screening?'**
  String get consultationAiScreeningExitTitle;

  /// No description provided for @consultationAiScreeningExitMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the AI Screening?'**
  String get consultationAiScreeningExitMessage;

  /// No description provided for @consultationAiScreeningExitCta.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get consultationAiScreeningExitCta;

  /// No description provided for @consultationAiScreeningExitCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get consultationAiScreeningExitCancel;

  /// No description provided for @consultationMicrophonePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Allow microphone access in Settings to start the online consultation.'**
  String get consultationMicrophonePermissionDenied;

  /// No description provided for @consultationCameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access in Settings to start the online consultation.'**
  String get consultationCameraPermissionDenied;

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

  /// No description provided for @consultationAiAssistantHeading.
  ///
  /// In en, this message translates to:
  /// **'Not sure which doctor to consult?'**
  String get consultationAiAssistantHeading;

  /// No description provided for @consultationAiAssistantSubheading.
  ///
  /// In en, this message translates to:
  /// **'Apna Clinic AI will help you find the right doctor'**
  String get consultationAiAssistantSubheading;

  /// No description provided for @consultationChooseCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Category'**
  String get consultationChooseCategoryTitle;

  /// No description provided for @consultationSearchCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Search category'**
  String get consultationSearchCategoryHint;

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

  /// No description provided for @consultationResultsFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get consultationResultsFilter;

  /// No description provided for @consultationClearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get consultationClearFilter;

  /// No description provided for @consultationSelectPartnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Partner'**
  String get consultationSelectPartnerTitle;

  /// No description provided for @consultationSearchPartner.
  ///
  /// In en, this message translates to:
  /// **'Search Partner'**
  String get consultationSearchPartner;

  /// No description provided for @consultationNoPartnersFound.
  ///
  /// In en, this message translates to:
  /// **'No partners found.'**
  String get consultationNoPartnersFound;

  /// No description provided for @consultationNoDoctorsFound.
  ///
  /// In en, this message translates to:
  /// **'No doctors found.'**
  String get consultationNoDoctorsFound;

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

  /// No description provided for @consultationViewBookingsCta.
  ///
  /// In en, this message translates to:
  /// **'View Bookings'**
  String get consultationViewBookingsCta;

  /// No description provided for @consultationBookingPaymentPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get consultationBookingPaymentPendingTitle;

  /// No description provided for @consultationBookingPaymentPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your appointment is waiting for payment. We\'ll update it once payment completes — check Bookings for the latest status.'**
  String get consultationBookingPaymentPendingMessage;

  /// No description provided for @consultationAbandonUnpaidOrderCta.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t pay? Cancel unpaid booking'**
  String get consultationAbandonUnpaidOrderCta;

  /// No description provided for @consultationAbandonUnpaidOrderFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to cancel the unpaid booking right now. Please try again.'**
  String get consultationAbandonUnpaidOrderFailed;

  /// No description provided for @consultationBookingConfirmedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your appointment has been booked with {doctorName}. You can join the consultation call from booking screen at the time of appointment'**
  String consultationBookingConfirmedMessage(Object doctorName);

  /// No description provided for @consultationBookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to book consultation. Please try again.'**
  String get consultationBookingFailed;

  /// No description provided for @consultationBookingInvalidContextError.
  ///
  /// In en, this message translates to:
  /// **'Booking details are incomplete. Please go back and try again.'**
  String get consultationBookingInvalidContextError;

  /// No description provided for @consultationBookingMissingMsisdnError.
  ///
  /// In en, this message translates to:
  /// **'A valid phone number is required to complete booking.'**
  String get consultationBookingMissingMsisdnError;

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

  /// No description provided for @consultationDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get consultationDocumentsTitle;

  /// No description provided for @consultationIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get consultationIssueTitle;

  /// No description provided for @consultationIssueHint.
  ///
  /// In en, this message translates to:
  /// **'Explain how are you feeling?'**
  String get consultationIssueHint;

  /// No description provided for @consultationDocumentsBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get consultationDocumentsBrowse;

  /// No description provided for @consultationDocumentsUploadHint.
  ///
  /// In en, this message translates to:
  /// **'You can upload up to 5 files. Maximum size is 1 MB per file. Supported formats: images and PDF.'**
  String get consultationDocumentsUploadHint;

  /// No description provided for @consultationUploadDocumentHint.
  ///
  /// In en, this message translates to:
  /// **'You can upload up to 5 files. Maximum size is 1 MB per file. Supported formats: images and PDF.'**
  String get consultationUploadDocumentHint;

  /// No description provided for @consultationFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'{fileName} exceeds the 1 MB limit. Please choose a smaller file.'**
  String consultationFileTooLarge(Object fileName);

  /// No description provided for @consultationMaxFilesReached.
  ///
  /// In en, this message translates to:
  /// **'You can upload a maximum of 5 files per booking.'**
  String get consultationMaxFilesReached;

  /// No description provided for @consultationUnsupportedFileType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file type. Only images and PDF documents are allowed.'**
  String get consultationUnsupportedFileType;

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
  /// **'Consultation fee'**
  String get consultationConsultationFeesLabel;

  /// No description provided for @consultationDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get consultationDiscountLabel;

  /// No description provided for @consultationDiscountNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get consultationDiscountNotAvailable;

  /// No description provided for @consultationTotalChargesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Charges'**
  String get consultationTotalChargesLabel;

  /// No description provided for @promoCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter promo code'**
  String get promoCodeHint;

  /// No description provided for @promoCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid Promo Code'**
  String get promoCodeInvalid;

  /// No description provided for @promoCodeDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Promo Discount'**
  String get promoCodeDiscountLabel;

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

  /// No description provided for @consultationCardChargeDescription.
  ///
  /// In en, this message translates to:
  /// **'Amount will be charged from your card.'**
  String get consultationCardChargeDescription;

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

  /// No description provided for @consultationNoAvailability.
  ///
  /// In en, this message translates to:
  /// **'Time Slots are not available right now. Please try again later!'**
  String get consultationNoAvailability;

  /// No description provided for @consultationPatientsReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Patient\'s Reviews'**
  String get consultationPatientsReviewsTitle;

  /// No description provided for @consultationSeeMoreReviews.
  ///
  /// In en, this message translates to:
  /// **'See More Reviews'**
  String get consultationSeeMoreReviews;

  /// No description provided for @consultationShowLessReviews.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get consultationShowLessReviews;

  /// No description provided for @consultationFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get consultationFeedbackTitle;

  /// No description provided for @consultationAvailabilityRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get consultationAvailabilityRetry;

  /// No description provided for @consultationSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get consultationSummaryTitle;

  /// No description provided for @consultationSummaryAccountNoLabel.
  ///
  /// In en, this message translates to:
  /// **'Account No.'**
  String get consultationSummaryAccountNoLabel;

  /// No description provided for @consultationSummaryTotalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get consultationSummaryTotalAmountLabel;

  /// No description provided for @consultationTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get consultationTimeLabel;

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

  /// No description provided for @bookingsDetailsOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Order no {orderId}'**
  String bookingsDetailsOrderTitle(String orderId);

  /// No description provided for @bookingsSurgeryDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get bookingsSurgeryDetailsTitle;

  /// No description provided for @bookingsTabInstantDoctor.
  ///
  /// In en, this message translates to:
  /// **'Instant Doctor'**
  String get bookingsTabInstantDoctor;

  /// No description provided for @bookingsTabPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get bookingsTabPharmacy;

  /// No description provided for @bookingsTabDoctorConsultation.
  ///
  /// In en, this message translates to:
  /// **'Doctor Consultation'**
  String get bookingsTabDoctorConsultation;

  /// No description provided for @bookingsTabLabTest.
  ///
  /// In en, this message translates to:
  /// **'Lab Tests'**
  String get bookingsTabLabTest;

  /// No description provided for @bookingsTabSurgery.
  ///
  /// In en, this message translates to:
  /// **'Surgery'**
  String get bookingsTabSurgery;

  /// No description provided for @bookingsInstantDoctorEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'No instant doctor bookings yet.'**
  String get bookingsInstantDoctorEmptyDescription;

  /// No description provided for @bookingsLabTestEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'No lab test bookings yet.'**
  String get bookingsLabTestEmptyDescription;

  /// No description provided for @bookingsDoctorConsultationEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'No Booking Available'**
  String get bookingsDoctorConsultationEmptyDescription;

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

  /// No description provided for @bookingsJoinConsultationCta.
  ///
  /// In en, this message translates to:
  /// **'Join Consultation'**
  String get bookingsJoinConsultationCta;

  /// No description provided for @bookingsJoinConsultationDisabledTooltip.
  ///
  /// In en, this message translates to:
  /// **'You will be able to join the consultation at the time of appointment'**
  String get bookingsJoinConsultationDisabledTooltip;

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
  /// **'Pending'**
  String get bookingsStatusPending;

  /// No description provided for @bookingsStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get bookingsStatusConfirmed;

  /// No description provided for @bookingsStatusCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get bookingsStatusCancel;

  /// No description provided for @bookingsStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get bookingsStatusFailed;

  /// No description provided for @bookingsStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
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
  /// **'Discount ({percent}%)'**
  String bookingsDiscountLabel(String percent);

  /// No description provided for @bookingsJoinNowCta.
  ///
  /// In en, this message translates to:
  /// **'Join Now'**
  String get bookingsJoinNowCta;

  /// No description provided for @bookingsPatientsReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Patient’s Review'**
  String get bookingsPatientsReviewTitle;

  /// No description provided for @bookingsDoctorsFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctor’s Feedback'**
  String get bookingsDoctorsFeedbackTitle;

  /// No description provided for @bookingsYourFeedbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback'**
  String get bookingsYourFeedbackLabel;

  /// No description provided for @bookingsFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Write your feedback...'**
  String get bookingsFeedbackHint;

  /// No description provided for @bookingsSubmitFeedbackCta.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get bookingsSubmitFeedbackCta;

  /// No description provided for @bookingsFeedbackSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback.'**
  String get bookingsFeedbackSubmitSuccess;

  /// No description provided for @bookingsFeedbackSelectRating.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating.'**
  String get bookingsFeedbackSelectRating;

  /// No description provided for @bookingsFeedbackMissingRef.
  ///
  /// In en, this message translates to:
  /// **'Unable to submit feedback for this booking.'**
  String get bookingsFeedbackMissingRef;

  /// No description provided for @bookingsDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get bookingsDocumentsTitle;

  /// No description provided for @bookingsPrescriptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get bookingsPrescriptionsTitle;

  /// No description provided for @bookingsDownloadCta.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get bookingsDownloadCta;

  /// No description provided for @bookingsAttachmentFallback.
  ///
  /// In en, this message translates to:
  /// **'Document {index}'**
  String bookingsAttachmentFallback(int index);

  /// No description provided for @labTestSampleTypeBlood.
  ///
  /// In en, this message translates to:
  /// **'Blood'**
  String get labTestSampleTypeBlood;

  /// No description provided for @securityGateAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get securityGateAccessDenied;

  /// No description provided for @securityGateFallbackMessage.
  ///
  /// In en, this message translates to:
  /// **'Your device does not meet security requirements.'**
  String get securityGateFallbackMessage;

  /// No description provided for @securityGateWillCloseIn.
  ///
  /// In en, this message translates to:
  /// **'This app will close in {count} seconds'**
  String securityGateWillCloseIn(int count);

  /// No description provided for @securityGateChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking device security…'**
  String get securityGateChecking;

  /// No description provided for @proCatalogLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load ApnaClinic Pro right now. Please try again.'**
  String get proCatalogLoadError;

  /// No description provided for @proRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get proRetry;

  /// No description provided for @proMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'ApnaClinic Pro'**
  String get proMenuTitle;

  /// No description provided for @proMenuYouAreMember.
  ///
  /// In en, this message translates to:
  /// **'You are a Pro Member'**
  String get proMenuYouAreMember;

  /// No description provided for @proShowInfoSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to Pro'**
  String get proShowInfoSectionTitle;

  /// No description provided for @proShowInfoSubscribeCta.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now!'**
  String get proShowInfoSubscribeCta;

  /// No description provided for @proSubscribeSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re subscribed to the Pro version!'**
  String get proSubscribeSuccessTitle;

  /// No description provided for @proSubscribeSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Enjoy discounts on the Pro bundle'**
  String get proSubscribeSuccessMessage;

  /// No description provided for @proSubscribeSuccessOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get proSubscribeSuccessOk;

  /// No description provided for @proHomeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Apna Clinic PRO'**
  String get proHomeSectionTitle;

  /// No description provided for @proHomeCardFallbackCta.
  ///
  /// In en, this message translates to:
  /// **'Tap to Subscribe'**
  String get proHomeCardFallbackCta;

  /// No description provided for @proActiveMemberSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You are eligible for the following discounts on Apna Clinic'**
  String get proActiveMemberSubtitle;

  /// No description provided for @proActiveBenefitsSuffix.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get proActiveBenefitsSuffix;

  /// No description provided for @proPlanRenewsOn.
  ///
  /// In en, this message translates to:
  /// **'Plan renews on {date}'**
  String proPlanRenewsOn(String date);

  /// No description provided for @proPlanExpiresOn.
  ///
  /// In en, this message translates to:
  /// **'Plan expires on {date}'**
  String proPlanExpiresOn(String date);

  /// No description provided for @proCancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get proCancelSubscription;

  /// No description provided for @proCancelSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel your Pro Subscription?'**
  String get proCancelSubscriptionTitle;

  /// No description provided for @proCancelSubscriptionMessage.
  ///
  /// In en, this message translates to:
  /// **'All the PRO discounts and free delivery will be removed from your account if you choose to cancel the subscription.'**
  String get proCancelSubscriptionMessage;

  /// No description provided for @proCancelSubscriptionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get proCancelSubscriptionConfirm;

  /// No description provided for @proCancelSubscriptionDiscard.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Cancel'**
  String get proCancelSubscriptionDiscard;
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
