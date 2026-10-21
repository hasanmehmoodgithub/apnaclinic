// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Sample Architecture';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get english => 'English';

  @override
  String get urdu => 'Urdu';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get welcome => 'Welcome';

  @override
  String get changeTheme => 'Change Theme';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get authVerifyPhoneTitle => 'Verify Your Phone Number';

  @override
  String get authMobileNumberLabel => 'Enter Mobile Number';

  @override
  String get authLoginSubtitle => 'Get started by Signing Up/Logging In';

  @override
  String get authPhoneHint => '+92 3XXXXXXXXX';

  @override
  String get authOtpHint => 'An OTP will be sent to this number';

  @override
  String get authSendOtpCta => 'Send OTP';

  @override
  String get authOtpVerificationTitle => 'OTP Verification';

  @override
  String get authOtpHintCode => '1 2 3 4';

  @override
  String get authProceedCta => 'Proceed';

  @override
  String get authVerifyCta => 'Verify';

  @override
  String get authResendOtp => 'Resend OTP';

  @override
  String get authOtpSecondsShort => 'Sec';

  @override
  String get authOtpSentTo => 'OTP sent to';

  @override
  String get authOtpSentMessage => 'OTP sent successfully.';

  @override
  String get authPhoneValidationError => 'Please enter a valid phone number.';

  @override
  String get authOtpValidationError => 'Please enter a valid 4-digit OTP.';

  @override
  String get authTermsAndPrivacy =>
      'By Signing in, I agree to Terms & Conditions and Privacy Policy.';

  @override
  String get authLegalPrefix => 'By Signing in, I agree to';

  @override
  String get authTermsLabel => 'Terms & Conditions';

  @override
  String get authLegalConnector => 'and';

  @override
  String get authPrivacyLabel => 'Privacy Policy.';

  @override
  String get profileTitle => 'Profile Edit';

  @override
  String get profileSetupTitle => 'Set up your profile';

  @override
  String get profileSetupSubtitle => 'Enter your personal information';

  @override
  String get profileUpdateSubtitle => 'Update your personal information';

  @override
  String get profileFirstNameLabel => 'First Name';

  @override
  String get profileFirstNameHint => 'Enter First Name Here';

  @override
  String get profileFirstNameRequired => 'First name is required.';

  @override
  String get profileLastNameLabel => 'Last Name';

  @override
  String get profileLastNameHint => 'Enter Last Name Here';

  @override
  String get profileLastNameRequired => 'Last name is required.';

  @override
  String get profileGenderLabel => 'Gender';

  @override
  String get profileGenderHint => 'Select';

  @override
  String get profileGenderMale => 'Male';

  @override
  String get profileGenderFemale => 'Female';

  @override
  String get profileGenderRequired => 'Please select gender.';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileEmailHint => 'name@example.com';

  @override
  String get profileEmailRequired => 'Please enter a valid email.';

  @override
  String get profileAddressLabel => 'Address';

  @override
  String get profileAddressHint => 'Enter Address';

  @override
  String get profileAddressRequired => 'Address is required.';

  @override
  String get profileDobLabel => 'Date of Birth';

  @override
  String get profileDobHint => 'DD/MM/YY';

  @override
  String get profileDobRequired => 'Please select date of birth.';

  @override
  String get profileSaveCta => 'Save';

  @override
  String get profileUpdateCta => 'Update Profile';

  @override
  String get profileSetupHeaderTitle => 'Profile Setup';

  @override
  String get profileImagePickerRestartMessage =>
      'Image picker not ready yet. Please fully restart the app.';

  @override
  String get profileImagePickerFailedMessage =>
      'Could not pick image. Please try again.';

  @override
  String get profileImageSourceTitle => 'Choose photo';

  @override
  String get profileUseCamera => 'Use camera';

  @override
  String get profileChooseFromGallery => 'Choose from gallery';

  @override
  String get profileCameraUnavailable =>
      'Camera access is unavailable right now.';

  @override
  String get profileGuestUserTitle => 'Guest User';

  @override
  String get profileSignupLoginCta => 'Sign Up / Login';

  @override
  String get profileEditCta => 'Edit';

  @override
  String get profileAccountDetailsTitle => 'Account Details';

  @override
  String get profileDefaultTag => 'Default';

  @override
  String get profileAddAccountCta => 'Add Account';

  @override
  String get profileMobileBankPrefix => 'Mobile Bank';

  @override
  String get profileRemoveAccountTitle => 'Remove Account';

  @override
  String profileRemoveAccountMessage(String bankName, String accountNumber) {
    return 'Are you sure you want to remove $bankName account $accountNumber ?';
  }

  @override
  String get profileRemoveCta => 'Remove';

  @override
  String get profileCancelCta => 'Cancel';

  @override
  String get pharmacyScreenTitle => 'Pharmacy';

  @override
  String get pharmacyLoadError =>
      'Unable to load medicines right now. Please try again in a moment.';

  @override
  String get pharmacyEmptyMedicines => 'No medicine found';

  @override
  String get pharmacyMainChooseMedicineTitle => 'Choose Medicine';

  @override
  String get pharmacyMainSearchHint => 'Search medicine';

  @override
  String get pharmacyCartTitle => 'Cart';

  @override
  String get pharmacyCartEmpty => 'Your cart is empty';

  @override
  String get pharmacyCartUpdateFailed =>
      'Unable to update cart right now. Please try again.';

  @override
  String get pharmacyCartBadgeOverflow => '99+';

  @override
  String get pharmacyRemoveFromCart => 'Remove from cart';

  @override
  String get pharmacyAbandonUnpaidOrderCta =>
      'Didn\'t pay? Cancel and return to cart';

  @override
  String get pharmacyAbandonUnpaidOrderFailed =>
      'Unable to cancel the unpaid order right now. Please try again.';

  @override
  String get pharmacyCheckoutCta => 'Check Out';

  @override
  String get pharmacyCheckoutTitle => 'Check Out';

  @override
  String get pharmacyCheckoutPatientDetailTitle => 'Patient Detail';

  @override
  String get pharmacyCheckoutPatientLabel => 'Patient';

  @override
  String get pharmacyCheckoutPatientSelf => 'Self';

  @override
  String get pharmacyCheckoutSpecialInstructionsLabel => 'Special Instructions';

  @override
  String get pharmacyCheckoutSpecialInstructionsHint =>
      'Write any special instructions here';

  @override
  String get pharmacyCheckoutOrderDetailsTitle => 'Order Details';

  @override
  String get pharmacyCheckoutSubtotalLabel => 'Subtotal';

  @override
  String get pharmacyCheckoutDeliveryChargesLabel => 'Delivery Charges';

  @override
  String get pharmacyCheckoutFree => 'Free';

  @override
  String get pharmacyCheckoutDiscountLabel => 'Discount';

  @override
  String get pharmacyCheckoutTotalLabel => 'Total';

  @override
  String get pharmacyCheckoutAddressLabel => 'Delivery address';

  @override
  String get pharmacyCheckoutAddressHint => 'Enter your address';

  @override
  String get pharmacyCheckoutCityLabel => 'Area / City *';

  @override
  String get pharmacyCheckoutPaymentMethodTitle => 'Payment Method';

  @override
  String get pharmacyCheckoutDisclaimerTitle => 'Disclaimer';

  @override
  String get pharmacyCheckoutDisclaimerMessage =>
      'Sold and fulfilled by our Licensed Pharmacy Partner(s) \"MEDIQ PHARMACY\". License No. : 05-352-0070-053618P';

  @override
  String get pharmacyCheckoutPrescriptionNotice =>
      'Prescription is required for some items. Customer representative will contact you shortly.';

  @override
  String get pharmacyCheckoutDeliveryInfoMessage =>
      'Orders will be delivered within 3 hours between 8:00 AM and 8:00 PM. Orders placed after 8:00 PM will be delivered by 12PM the following day.';

  @override
  String get pharmacyCheckoutDeliveryInfoFooter =>
      'Orders below Rs 2500 will include delivery charges of Rs 250.';

  @override
  String get pharmacyCheckoutConfirmCta => 'Confirm';

  @override
  String get pharmacyCheckoutFailed =>
      'Unable to place pharmacy order right now. Please try again.';

  @override
  String get pharmacyCheckoutPaymentPendingTitle => 'Payment Pending';

  @override
  String get pharmacyCheckoutPaymentPendingMessage =>
      'Your pharmacy order is waiting for payment. We\'ll update it once payment completes — check Bookings for the latest status.';

  @override
  String get pharmacyOrderPlacedTitle => 'Order Successfully Placed!';

  @override
  String pharmacyOrderPlacedMessage(String orderNo) {
    return 'Your order number $orderNo has been placed and will be processed soon. A representative will reach out to you for order confirmation.';
  }

  @override
  String pharmacyOrderPlacedMessageAfterPayment(String orderNo) {
    return 'After your payment is verified, you will be able to track your pharmacy order $orderNo in My Orders. A representative will reach out to you for order confirmation.';
  }

  @override
  String get pharmacyOrderPlacedViewOrdersCta => 'View My Orders';

  @override
  String get pharmacyPaymentJazzCash => 'Jazz Cash';

  @override
  String get pharmacyPaymentDebitCard => 'Debit / Credit Card';

  @override
  String get pharmacyPaymentCash => 'Pay via Cash';

  @override
  String get pharmacyCurrencyPrefix => 'Rs. ';

  @override
  String get pharmacyBookingOrderPrefix => 'Order no';

  @override
  String get pharmacyBookingMedicineName => 'O-ZEETINE Capsules 6/25MG';

  @override
  String get pharmacyBookingMedicineQty => '2';

  @override
  String get pharmacyBookingCurrencyCompact => 'Rs.';

  @override
  String get pharmacyBookingInvoiceFileName => 'E-Invoice.pdf';

  @override
  String get pharmacyBookingDeliveryCity => 'Islamabad';

  @override
  String get pharmacyBookingDeliveryAddress =>
      'Office #7 2nd Floor Plaza 2000, I-8 Markaz Islamabad.';

  @override
  String get pharmacyBookingOrderStatusTitle => 'Order Status';

  @override
  String get pharmacyBookingStatusConfirmed => 'Confirmed';

  @override
  String get pharmacyBookingStatusReadyForDispatch => 'Ready for Dispatch';

  @override
  String get pharmacyBookingStatusDispatched => 'Dispatched / Shipped';

  @override
  String get pharmacyBookingStatusCompleted => 'Completed';

  @override
  String get pharmacyBookingStatusCancelled => 'Order Cancel';

  @override
  String get pharmacyBookingFeedbackTitle => 'Your Feedback';

  @override
  String get pharmacyBookingFeedbackSubtitle =>
      'We hope your medications have been helpful. Please take a moment to share your feedback on order #PH123456.';

  @override
  String get pharmacyBookingFeedbackHint => 'Write your feedback...';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingDoctorConsultationTitle => 'Doctor Consultation';

  @override
  String get onboardingDoctorConsultationSubtitle =>
      'Access to PMDC certified doctors';

  @override
  String get onboardingInstantDoctorTitle => '24/7 Instant Doctor';

  @override
  String get onboardingInstantDoctorSubtitle =>
      'Get instant doctor consultation 24/7 round the clock.';

  @override
  String get onboardingBookConsultationTitle => 'Book Consultation';

  @override
  String get onboardingBookConsultationSubtitle =>
      'Book online consultation with PMDC certified specialist doctors';

  @override
  String get onboardingPharmacyTitle => 'Order Medicine';

  @override
  String get onboardingPharmacySubtitle =>
      'Get authentic medicines delivered at your doorstep.';

  @override
  String get onboardingLaboratoryTitle => 'Book Lab Test';

  @override
  String get onboardingLaboratorySubtitle =>
      'Access lab tests from your trusted labs with free home sampling';

  @override
  String get onboardingSurgeryTitle => 'Surgery Booking';

  @override
  String get onboardingSurgerySubtitle => 'Book your surgery with ease.';

  @override
  String get pharmacyMoreLike => 'More Like';

  @override
  String get pharmacyAddToCart => 'Add to Cart';

  @override
  String get pharmacyAddToCartLower => 'Add to cart';

  @override
  String get pharmacyRequiresPrescription => 'REQUIRES PRESCRIPTION';

  @override
  String get pharmacyPrescriptionRequiredMessage =>
      'This medicine requires a valid doctor prescription. Please upload a prescription.';

  @override
  String get pharmacyPrescriptionUploadHint => 'Click to upload prescription';

  @override
  String get pharmacyPrescriptionUploadFormats =>
      'PNG, JPEG, WEBP, PDF supported (Max 5MB)';

  @override
  String get pharmacyPrescriptionRemoveFile => 'Remove file';

  @override
  String get pharmacyPrescriptionRequiredToAdd =>
      'Please upload a prescription before adding to cart.';

  @override
  String get pharmacyPrescriptionUploadFailed =>
      'Prescription upload failed. Please try again.';

  @override
  String get pharmacyPrescriptionPickFailed =>
      'Unable to pick prescription file. Please try again.';

  @override
  String get pharmacyPrescriptionInvalidType =>
      'Unsupported file type. Use PNG, JPEG, WEBP, or PDF.';

  @override
  String get pharmacyPrescriptionTooLarge =>
      'File is too large. Maximum size is 5MB.';

  @override
  String get pharmacyPrescriptionUploadedLabel => 'Prescription uploaded';

  @override
  String get pharmacyPrescriptionUploadedHint =>
      'A prescription is already attached for this medicine.';

  @override
  String get pharmacyPrescriptionReupload => 'Re-upload';

  @override
  String get pharmacyPrescriptionKeepCurrent => 'Keep current';

  @override
  String get pharmacyAddToCartFailed =>
      'Unable to add to cart right now. Please try again.';

  @override
  String get instantDoctorTitle => 'Instant Doctor';

  @override
  String get instantDoctorOpenAppCta => 'Subscribe Now!';

  @override
  String get instantDoctorOpenAppError =>
      'Could not open subscription page right now.';

  @override
  String get instantDoctorMediaPermissionDenied =>
      'Allow camera and microphone access in Settings to start the video consultation.';

  @override
  String get instantDoctorSubscribe => 'Subscribe';

  @override
  String get instantDoctorStartConsultation => 'Start Consultation';

  @override
  String get instantDoctorSubscribed => 'Subscribed';

  @override
  String get instantDoctorNoProviders =>
      'No instant doctor plans available right now.';

  @override
  String get instantDoctorPlanDetails => 'Plan details';

  @override
  String get instantDoctorOtpInstruction =>
      'A 4 digit OTP code is sent to your number. Please enter the code below to proceed';

  @override
  String get instantDoctorOtpUnsubscribeInstruction =>
      'A 4 digit OTP code is sent to your number. Please enter the code below to unsubscribe this service';

  @override
  String get instantDoctorSubscribeSuccessTitle => 'Successfully Subscribed!';

  @override
  String instantDoctorSubscribeSuccessMessage(String providerName) {
    return 'You have successfully subscribed to $providerName. Consult a doctor any time instantly';
  }

  @override
  String get instantDoctorSubscribeFailedTitle => 'Subscription Failed!';

  @override
  String get instantDoctorSubscribeFailedMessage =>
      'Unfortunately some error has occurred. Please try again.';

  @override
  String get instantDoctorClose => 'Close';

  @override
  String get instantDoctorCancelSubscription => 'Cancel Subscription';

  @override
  String get instantDoctorCancelSubscriptionTitle =>
      'Are you sure you want to unsubscribe?';

  @override
  String get instantDoctorCancelSubscriptionMessage =>
      'This service will be unsubscribed from your account.';

  @override
  String get instantDoctorCancelSubscriptionConfirm => 'Unsubscribe';

  @override
  String get instantDoctorCancelSubscriptionDiscard => 'Discard';

  @override
  String get instantDoctorCancelSubscriptionSuccess =>
      'Subscription cancelled successfully.';

  @override
  String get instantDoctorCancelSubscriptionFailed =>
      'Unable to cancel subscription. Please try again.';

  @override
  String get instantDoctorConsultationTitle =>
      '24/7 Instant Doctor Consultation';

  @override
  String get instantDoctorConsultationSubtitle =>
      'Consult a doctor instantly and any time by choosing a package of your choice.';

  @override
  String get instantDoctorPoint1 =>
      'This service is available exclusively for M-Health subscribers.';

  @override
  String get instantDoctorPoint2 =>
      'Get 24/7 access to qualified doctors for general medical support and much more.';

  @override
  String get instantDoctorConsultationExitTitle => 'Exit consultation?';

  @override
  String get instantDoctorConsultationExitMessage =>
      'Are you sure you want to exit from this video Consultation?';

  @override
  String get instantDoctorConsultationExitCta => 'Exit';

  @override
  String get instantDoctorConsultationExitCancel => 'Cancel';

  @override
  String get customerSupportTitle => 'Customer Support';

  @override
  String get customerSupportHelpCentreTitle => 'Help Centre';

  @override
  String get customerSupportHelpCentreSubtitle =>
      'Reach out to Apna Clinic for any support.';

  @override
  String get customerSupportFallbackCardTitle => 'Apna Clinic Support';

  @override
  String get customerSupportFallbackDialogTitle => 'Customer Support';

  @override
  String get customerSupportFallbackDialogMessage =>
      'Or further support please contact us 24/7 on\n042-111-333-033.';

  @override
  String get customerSupportCallNowCta => 'Call Now';

  @override
  String get customerSupportDialError => 'Could not start the call.';

  @override
  String get accountDetailsTitle => 'Account Details';

  @override
  String get accountAddTitle => 'Add Account';

  @override
  String get accountEnterDetailsTitle => 'Enter Account Details';

  @override
  String get accountMethodLabel => 'Account Method';

  @override
  String get accountNumberLabel => 'Account Number';

  @override
  String get accountSaveCta => 'Save';

  @override
  String get accountContinueCta => 'Continue';

  @override
  String get accountMethodAddedSuccess => 'Payment Method Added Successfully';

  @override
  String get accountAddFailedTitle => 'Unable to Add Account';

  @override
  String get accountAddFailedFallback =>
      'Account could not be added. Please try again.';

  @override
  String get accountLinkedMessagePrefix => 'Your';

  @override
  String get accountLinkedMessageMiddle => 'account no.';

  @override
  String get accountLinkedMessageSuffix => 'has been linked successfully';

  @override
  String get accountHolderFallback => 'Account Holder';

  @override
  String get accountValidationEnterNumber => 'Enter account number';

  @override
  String get accountValidationDigitsOnly => 'Only digits are allowed';

  @override
  String get accountValidationElevenDigits => 'Enter 11 digit Pakistan number';

  @override
  String get accountValidationValidPakistanMobile =>
      'Enter valid Pakistan mobile number';

  @override
  String get accountMethodJazzCash => 'JazzCash';

  @override
  String get accountNoAccountsMessage => 'No accounts found.';

  @override
  String get accountIdLabel => 'ID';

  @override
  String get accountNumberShortLabel => 'Number';

  @override
  String get accountDefaultLabel => 'Default';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String dashboardHello(String name) {
    return 'Hello, $name';
  }

  @override
  String get dashboardGuestName => 'Guest';

  @override
  String get dashboardSearchHint => 'Search doctor, medicine, lab tests...';

  @override
  String get dashboardInstantDoctorDescription =>
      'Consult a certified doctor any time of the day instantly without appointment';

  @override
  String get dashboardOurServicesTitle => 'Our Services';

  @override
  String get dashboardSecureHealthTitle => 'Secure Your Health First';

  @override
  String get dashboardFikrfreeTagline =>
      'Sehat aur insurance ab apke hath mei!';

  @override
  String get dashboardBottomInstantDoctor => 'Instant Doctor';

  @override
  String get dashboardBottomSupport => 'Support';

  @override
  String get dashboardBottomBookings => 'Bookings';

  @override
  String get dashboardBottomProfile => 'Profile';

  @override
  String get dashboardBottomHome => 'Home';

  @override
  String get dashboardMenuTitle => 'Menu';

  @override
  String get dashboardMenuCustomerSupport => 'Customer Support';

  @override
  String get dashboardMenuFaq => 'FAQ’s';

  @override
  String get dashboardMenuGuestUser => 'Guest User';

  @override
  String get dashboardMenuSignInManageAccount =>
      'Sign in to manage your account';

  @override
  String get dashboardMenuSignInContinue => 'Sign in to continue';

  @override
  String get dashboardMenuLogout => 'Logout';

  @override
  String get dashboardMenuAbout => 'About';

  @override
  String get dashboardMenuAppVersion => 'App Version';

  @override
  String get dashboardMenuTerms => 'Terms & Conditions';

  @override
  String get dashboardMenuPrivacy => 'Privacy Policy';

  @override
  String get dashboardMenuEditProfile => 'Edit Profile';

  @override
  String get dashboardMenuLoginSignup => 'Login / Signup';

  @override
  String get dashboardLogoutMessage =>
      'Are you sure you want to logout from your account?';

  @override
  String get dashboardCancel => 'Cancel';

  @override
  String get dashboardCloseAppTitle => 'Exit App';

  @override
  String get dashboardCloseAppMessage =>
      'Are you sure you want to exit Apna Clinic?';

  @override
  String get dashboardCloseAppCta => 'Exit';

  @override
  String get dashboardAppUpdateAvailableTitle => 'Update Available';

  @override
  String get dashboardAppUpdateRequiredTitle => 'Update Required';

  @override
  String get dashboardAppUpdateAvailableMessage =>
      'A newer version of Apna Clinic is available. Update now for the latest features and improvements.';

  @override
  String get dashboardAppUpdateRequiredMessage =>
      'Please update Apna Clinic to continue using the app.';

  @override
  String get dashboardAppUpdateCta => 'Update Now';

  @override
  String get dashboardAppUpdateLater => 'Later';

  @override
  String dashboardAppUpdateVersionLabel(
    String currentVersion,
    String latestVersion,
  ) {
    return 'Current $currentVersion → $latestVersion';
  }

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsRetryCta => 'Retry';

  @override
  String get notificationsEmptyTitle => 'No Notifications Yet!';

  @override
  String get notificationsLoadError =>
      'Unable to load notifications. Pull to refresh or try again.';

  @override
  String get notificationsDeepLinkUnavailableTitle => 'Details unavailable';

  @override
  String get notificationsDeepLinkUnavailableMessage =>
      'This notification cannot be opened. The booking or order reference may be missing or unsupported.';

  @override
  String get searchScreenTitle => 'Search';

  @override
  String get searchListeningHint => 'Listening...';

  @override
  String get searchVoicePermissionDenied =>
      'Allow microphone access in Settings to use voice search.';

  @override
  String get searchVoiceNotAvailable =>
      'Voice search is not available on this emulator. Use a physical phone with Google speech services.';

  @override
  String get searchVoiceRebuildRequired =>
      'Voice search needs a full app restart. Stop the app, then run flutter run (not hot restart).';

  @override
  String get searchVoiceFailed =>
      'Could not start voice search. Please try again.';

  @override
  String get searchRecentSearchesTitle => 'Recent Searches';

  @override
  String get searchPopularSearchesTitle => 'Popular Searches';

  @override
  String get searchSeeAllCta => 'See All';

  @override
  String searchForQuery(String query) {
    return 'Search for \"$query\"';
  }

  @override
  String searchNoResultsFor(String query) {
    return 'No result found for \"$query\"';
  }

  @override
  String get labTestScreenTitle => 'Lab Test';

  @override
  String get surgeryScreenTitle => 'Procedures & Surgeries';

  @override
  String get surgeryBookingScreenTitle => 'Surgery Booking';

  @override
  String get surgeryNoProceduresMessage =>
      'No surgery procedures available right now.';

  @override
  String get surgeryNoDataFound => 'No data found';

  @override
  String get commonReset => 'Reset';

  @override
  String get surgeryPatientValidationMessage =>
      'Please fill in all required fields.';

  @override
  String get surgeryEmergencyContactRequired =>
      'Please add emergency contact number.';

  @override
  String get surgeryAgeInvalid => 'Enter a valid age.';

  @override
  String get surgeryPhoneInvalid => 'Enter a valid number.';

  @override
  String get surgerySelectForSurgery => 'Select for Surgery';

  @override
  String get surgeryLocationLabel => 'Location';

  @override
  String get commonChange => 'Change';

  @override
  String get surgerySearchNameHint => 'Search name..';

  @override
  String get surgerySelectCityTitle => 'Select a city';

  @override
  String get surgerySearchByNameHint => 'Search by name';

  @override
  String get commonProceed => 'Proceed';

  @override
  String get commonApplyFilter => 'Apply Filter';

  @override
  String get surgeryPatientDetailsTitle => 'Patient Details';

  @override
  String get surgeryPatientNameLabel => 'Patient Name';

  @override
  String get surgeryPatientNameHint => 'Patient Name';

  @override
  String get surgeryPatientNameError => 'Enter patient name';

  @override
  String get surgeryPatientAgeLabel => 'Age';

  @override
  String get surgeryPatientAgeHint => 'Patient Age';

  @override
  String get surgeryPatientAgeError => 'Enter a valid age';

  @override
  String get surgeryContactNumberLabel => 'Contact Number';

  @override
  String get surgeryContactNumberHint => 'Patient Contact Number';

  @override
  String get surgeryContactNumberError => 'Enter a valid number';

  @override
  String get surgeryEmergencyContactLabel => 'Emergency Contact';

  @override
  String get surgeryEmergencyContactHint => 'Patient Emergency Contact';

  @override
  String get surgeryEmergencyContactError => 'Enter a valid number';

  @override
  String get surgeryLabel => 'Surgery';

  @override
  String get surgeryProceedCheckout => 'Confirm Booking';

  @override
  String get surgeryStartingFrom => 'Starting from';

  @override
  String get surgeryBookingSubmittedTitle => 'Booking Request Submitted';

  @override
  String get surgeryBookingSubmittedMessage =>
      'Your surgery request has been received. Our representative will contact you within 24 hours to gather your medical history and relevant details for confirmation.';

  @override
  String get surgeryBookingConfirmedTitle => 'Booking Confirmed';

  @override
  String surgeryBookingConfirmedMessageAfterPayment(
    String doctorName,
    String procedure,
    String appointmentSuffix,
    String hospitalSuffix,
  ) {
    return 'After your payment is verified, you will be able to view your surgery booking with $doctorName for $procedure$appointmentSuffix$hospitalSuffix in the Bookings tab.';
  }

  @override
  String get surgeryBookingViewBookingsCta => 'View My Bookings';

  @override
  String get surgeryBookingPaymentPendingTitle => 'Payment Pending';

  @override
  String get surgeryBookingPaymentPendingMessage =>
      'Your surgery booking is waiting for payment. We\'ll update it once payment completes — check Bookings for the latest status.';

  @override
  String get surgeryBookingFailedTitle => 'Booking Request Failed';

  @override
  String get surgeryTypesLoadFailed =>
      'Unable to load surgery types. Please try again.';

  @override
  String get surgerySubmitFailed =>
      'Unable to submit booking request. Please try again.';

  @override
  String get labTestSelectCityPlaceholder => 'Select City';

  @override
  String get labTestCityFieldLabel => 'City';

  @override
  String get labTestChangeCityCta => 'Change';

  @override
  String get labTestSelectTestHeading => 'Select Test';

  @override
  String get labTestSelectLabHeading => 'Select Lab';

  @override
  String get labTestLabsLoadFailed => 'Failed to load labs.';

  @override
  String get labTestNoLabsFound => 'No labs found';

  @override
  String get labTestRequirementsHeading => 'Requirements';

  @override
  String get labTestHomeSamplingUnavailable =>
      'Home sampling is not available for this test';

  @override
  String labTestFulfilledBy(String partner) {
    return 'This test service is fulfilled by $partner.';
  }

  @override
  String labTestCartFulfilledBy(String partner) {
    return 'Test fulfilled by $partner';
  }

  @override
  String get labTestSearchFieldHint => 'Search';

  @override
  String get labTestSelectCitySheetTitle => 'Select a city';

  @override
  String get labTestSelectCitySheetSearchHint => 'Search by name';

  @override
  String get selectCityTitle => 'Select a city';

  @override
  String get selectCitySearchHint => 'Search by name';

  @override
  String get selectCityEmpty => 'No cities available';

  @override
  String get selectCityNoResults => 'No cities found';

  @override
  String get labTestRequirementLabel => 'Requirement';

  @override
  String get labTestSampleTypeLabel => 'Sample Type';

  @override
  String get labTestSampleTypeNotAvailable => 'N/A';

  @override
  String get labTestBookingMethodLabel => 'Booking Method';

  @override
  String get labTestPleaseSelectCityFirst => 'Please select a city first.';

  @override
  String get labTestDataStillLoading => 'Lab test data is still loading.';

  @override
  String get labTestCatalogLoadFailed => 'Failed to load lab tests.';

  @override
  String get labTestNoTestsFound => 'No tests found';

  @override
  String get labTestNoRecordFound => 'No Record Found';

  @override
  String get labTestCartBadgeOverflow => '9+';

  @override
  String get labTestBrowseItemFeeFallback => 'Rs. 15,000/-';

  @override
  String get labTestBookingChooseMethodTitle => 'Choose a Booking Method';

  @override
  String get labTestBookingMethodWalkIn => 'Walk In';

  @override
  String get labTestBookingMethodHomeSample => 'Home Sample';

  @override
  String get labTestBookingAddToCart => 'Add to Cart';

  @override
  String get labTestBookingViewYourCart => 'View Your Cart';

  @override
  String get labTestBookingDataUnavailable => 'Lab test data unavailable';

  @override
  String get labTestCartChangeWarningTitle => 'Warning!';

  @override
  String get labTestCartChangeWarningBody =>
      'Changing the City, Service Provider or\nLab will remove all items from your cart.\nDo you want to proceed?';

  @override
  String get labTestCartChangeViewCart => 'View Cart';

  @override
  String get labTestCartChangeContinue => 'Continue';

  @override
  String get labTestCartBadgeOverflow99 => '99+';

  @override
  String get labTestCartScreenTitle => 'Cart';

  @override
  String get labTestCartEmptyMessage => 'No items in cart';

  @override
  String get labTestCartProceedCheckout => 'Proceed to Checkout';

  @override
  String get labTestViewDetailsLoadError =>
      'Unable to load details. Please try again.';

  @override
  String get labTestSomethingWentWrong => 'Something went wrong';

  @override
  String get commonRetry => 'Retry';

  @override
  String get paymentWebViewTitle => 'Card Payment';

  @override
  String get paymentWebViewLoadError =>
      'Unable to load the payment page. Please try again.';

  @override
  String get paymentWebViewFailed => 'Payment failed. Please try again.';

  @override
  String get paymentWebViewFailedTitle => 'Payment Failed';

  @override
  String get paymentWebViewCancelled => 'Payment cancelled.';

  @override
  String get paymentWebViewCancelledTitle => 'Payment Cancelled';

  @override
  String get paymentWebViewCancelledMessage =>
      'Your payment was cancelled. You can try again when you are ready.';

  @override
  String get paymentPendingViewBookingsCta => 'View My Bookings';

  @override
  String get labTestViewDetailsTitle => 'Details';

  @override
  String get labTestViewDetailsResultsTitle => 'Test Results';

  @override
  String get labTestViewDetailsOrderTitle => 'Order Details';

  @override
  String get labTestReportPendingNote =>
      'Your report will be available once the lab completes processing.';

  @override
  String get labTestReportAvailableNote =>
      'Your report is ready. You can download it from the test results section.';

  @override
  String get labTestDownloadReport => 'Download Report';

  @override
  String get labTestDownloadReportFailed =>
      'Unable to download the report. Please try again.';

  @override
  String get bookingsInvoiceDownloadFailed =>
      'Unable to open the invoice. Please try again.';

  @override
  String get pdfViewerShare => 'Share';

  @override
  String get pdfViewerDownload => 'Download';

  @override
  String get pdfViewerShareFailed =>
      'Unable to share the PDF. Please try again.';

  @override
  String get pdfViewerDownloadFailed =>
      'Unable to save the PDF. Please try again.';

  @override
  String get pdfViewerSaved => 'PDF saved';

  @override
  String get labTestInvoiceSectionTitle => 'Invoice';

  @override
  String get labTestInvoiceFileName => 'E-Invoice.pdf';

  @override
  String get labTestDiscountCodeCopied => 'Discount code copied';

  @override
  String get labTestOrderNoPrefix => 'Order No.';

  @override
  String get labTestBookingCardSubtitle => 'Lab Test Report';

  @override
  String get labTestBookingDateLabel => 'Booking Date';

  @override
  String get labTestTotalFeeLabel => 'Total Fee';

  @override
  String get labTestDiscountCodeLabel => 'Discount Code';

  @override
  String get labTestShowCodeInstruction =>
      'Show this code to the lab representative';

  @override
  String get labTestCheckoutTitle => 'Payment Details';

  @override
  String get labTestCheckoutRequiredFieldsError =>
      'Please fill all the required fields';

  @override
  String get labTestAgeInvalid => 'Please enter a valid age (1-99).';

  @override
  String get labTestCheckoutPhoneInvalid =>
      'Enter a valid mobile or landline number.';

  @override
  String get labTestCheckoutBookedTitle => 'Lab Test Booked!';

  @override
  String get labTestCheckoutBookedMessage =>
      'After your payment is verified, you will be able to view your lab test booking in the Bookings tab. A lab representative will reach out to you soon to confirm your booking.';

  @override
  String get labTestCheckoutPaymentPendingTitle => 'Payment Pending';

  @override
  String get labTestCheckoutPaymentPendingMessage =>
      'Your lab booking is waiting for payment. We\'ll update it once payment completes — check Bookings for the latest status.';

  @override
  String get labTestAbandonUnpaidOrderCta =>
      'Didn\'t pay? Cancel unpaid booking';

  @override
  String get labTestAbandonUnpaidOrderFailed =>
      'Unable to cancel the unpaid booking right now. Please try again.';

  @override
  String get labTestCheckoutViewBookingsCta => 'View My Bookings';

  @override
  String get commonClose => 'Close';

  @override
  String get labTestBookingMethodWalkInCompact => 'Walk In';

  @override
  String get labTestCheckoutFeeLabel => 'Fee';

  @override
  String get labTestCheckoutDiscountLabel => 'Discount';

  @override
  String get labTestCheckoutTotalLabel => 'Total';

  @override
  String get labTestPatientDetailsTitle => 'Patient Details';

  @override
  String get commonDone => 'Done';

  @override
  String get commonEdit => 'Edit';

  @override
  String get labTestEmergencyContactTitle => 'Emergency Contact';

  @override
  String get labTestEmergencyContactHintText =>
      'Please provide an emergency contact number, incase you are unavailable.';

  @override
  String get labTestEmergencyNumberHint => 'Enter Number here.';

  @override
  String get labTestPatientNameLabel => 'Patient Name';

  @override
  String get labTestContactNumberLabel => 'Contact Number';

  @override
  String get labTestAddressLabel => 'Address';

  @override
  String get labTestUseSavedAddressFromProfile =>
      'Use saved address from profile';

  @override
  String get labTestUseDifferentAddress => 'Use a different address';

  @override
  String get labTestFullNameHint => 'Full name';

  @override
  String get labTestPhonebookHint => 'Type or select from phonebook';

  @override
  String get labTestAgeLabel => 'Age';

  @override
  String get labTestAddPatientDetailsHeading => 'Add Patient Details';

  @override
  String get labTestAddPatientSheetTitle => 'Add patient details';

  @override
  String get labTestAddPatientSeparateCharges =>
      'Separate charges will be charged for each patient.';

  @override
  String get labTestAddPatientCta => 'Add Patient';

  @override
  String get labTestPatientSelfLabel => 'Self';

  @override
  String get labTestAddressHint => 'Enter your address here';

  @override
  String get commonMale => 'Male';

  @override
  String get commonFemale => 'Female';

  @override
  String get labTestBookCta => 'Book Lab Test';

  @override
  String get consultationAiScreeningTitle => 'AI Screening';

  @override
  String get consultationAiScreeningExitTitle => 'Close AI Screening?';

  @override
  String get consultationAiScreeningExitMessage =>
      'Are you sure you want to exit the AI Screening?';

  @override
  String get consultationAiScreeningExitCta => 'Exit';

  @override
  String get consultationAiScreeningExitCancel => 'Cancel';

  @override
  String get consultationMicrophonePermissionDenied =>
      'Allow microphone access in Settings to start the online consultation.';

  @override
  String get consultationCameraPermissionDenied =>
      'Allow camera access in Settings to start the online consultation.';

  @override
  String get consultationAiWelcomePrefix => 'Hello, welcome to ';

  @override
  String get consultationAiWelcomeSuffix => ' , let\'s get started';

  @override
  String get consultationAiStartCta => 'Let\'s Start';

  @override
  String get consultationAiAssistantHeading =>
      'Not sure which doctor to consult?';

  @override
  String get consultationAiAssistantSubheading =>
      'Apna Clinic AI will help you find the right doctor';

  @override
  String get consultationChooseCategoryTitle => 'Choose Category';

  @override
  String get consultationSearchCategoryHint => 'Search category';

  @override
  String get consultationSelectCategoriesTitle => 'Select Categories';

  @override
  String get consultationSpecialistTitle => 'Specialist';

  @override
  String get consultationResultsFilter => 'Filter';

  @override
  String get consultationClearFilter => 'Clear';

  @override
  String get consultationSelectPartnerTitle => 'Select Partner';

  @override
  String get consultationSearchPartner => 'Search Partner';

  @override
  String get consultationNoPartnersFound => 'No partners found.';

  @override
  String get consultationNoDoctorsFound => 'No doctors found.';

  @override
  String get consultationVideoBookingPrompt =>
      'Book your video consultation here!';

  @override
  String get consultationGetAppointmentCta => 'Get Appointment';

  @override
  String get consultationBookingConfirmedTitle => 'Appointment Confirmed!';

  @override
  String get consultationViewBookingsCta => 'View Bookings';

  @override
  String get consultationBookingPaymentPendingTitle => 'Payment Pending';

  @override
  String get consultationBookingPaymentPendingMessage =>
      'Your appointment is waiting for payment. We\'ll update it once payment completes — check Bookings for the latest status.';

  @override
  String get consultationAbandonUnpaidOrderCta =>
      'Didn\'t pay? Cancel unpaid booking';

  @override
  String get consultationAbandonUnpaidOrderFailed =>
      'Unable to cancel the unpaid booking right now. Please try again.';

  @override
  String consultationBookingConfirmedMessage(Object doctorName) {
    return 'After your payment is verified, you will be able to join the consultation call with $doctorName from the Bookings tab at the time of your appointment.';
  }

  @override
  String get consultationBookingFailed =>
      'Unable to book consultation. Please try again.';

  @override
  String get consultationBookingInvalidContextError =>
      'Booking details are incomplete. Please go back and try again.';

  @override
  String get consultationBookingMissingMsisdnError =>
      'A valid phone number is required to complete booking.';

  @override
  String get commonOk => 'OK';

  @override
  String get consultationUploadDocumentTitle => 'Upload Document';

  @override
  String get consultationUseCamera => 'Use camera';

  @override
  String get consultationUploadFromGallery => 'Upload from gallery';

  @override
  String get consultationUploadFromFile => 'Upload from File';

  @override
  String get consultationCameraUnavailable =>
      'Camera access is unavailable right now.';

  @override
  String get consultationCaptureMediaFailed =>
      'Could not capture media. Please try again.';

  @override
  String get consultationGalleryUnavailable =>
      'Gallery access is unavailable right now.';

  @override
  String get consultationPickGalleryFailed =>
      'Could not pick media from gallery.';

  @override
  String get consultationPickFileFailed =>
      'Could not pick file. Please try again.';

  @override
  String get consultationDocumentsTitle => 'Documents';

  @override
  String get consultationIssueTitle => 'Issue';

  @override
  String get consultationIssueHint => 'Explain how are you feeling?';

  @override
  String get consultationDocumentsBrowse => 'Browse';

  @override
  String get consultationDocumentsUploadHint =>
      'You can upload up to 5 files. Maximum size is 1 MB per file. Supported formats: images and PDF.';

  @override
  String get consultationUploadDocumentHint =>
      'You can upload up to 5 files. Maximum size is 1 MB per file. Supported formats: images and PDF.';

  @override
  String consultationFileTooLarge(Object fileName) {
    return '$fileName exceeds the 1 MB limit. Please choose a smaller file.';
  }

  @override
  String get consultationMaxFilesReached =>
      'You can upload a maximum of 5 files per booking.';

  @override
  String get consultationUnsupportedFileType =>
      'Unsupported file type. Only images and PDF documents are allowed.';

  @override
  String get consultationPaymentMethodTitle => 'Payment Method';

  @override
  String get paymentTermsAndConditionsApply => 'Terms & Conditions apply';

  @override
  String get consultationVideoConsultationLabel => 'Video Consultation';

  @override
  String get consultationConsultationFeesLabel => 'Consultation fee';

  @override
  String get consultationDiscountLabel => 'Discount';

  @override
  String get consultationDiscountNotAvailable => 'N/A';

  @override
  String get consultationTotalChargesLabel => 'Total Charges';

  @override
  String get promoCodeHint => 'Enter promo code';

  @override
  String get promoCodeInvalid => 'Invalid Promo Code';

  @override
  String get promoCodeApplyRequired => 'Please apply the promo code';

  @override
  String get promoCodeDiscountLabel => 'Promo Discount';

  @override
  String get consultationSelectAccountTitle => 'Select Account';

  @override
  String get consultationProceedCta => 'Proceed';

  @override
  String get consultationJazzCashChargeDescription =>
      'Amount will be charged from your jazz cash account.';

  @override
  String get consultationCardChargeDescription =>
      'Amount will be charged from your card.';

  @override
  String get consultationRequiredFieldsError =>
      'Please fill all the required fields';

  @override
  String get consultationSelectSlotError =>
      'Please select a slot for video consultation';

  @override
  String get consultationNoAvailability =>
      'Time Slots are not available right now. Please try again later!';

  @override
  String get consultationPatientsReviewsTitle => 'Patient\'s Reviews';

  @override
  String get consultationSeeMoreReviews => 'See More Reviews';

  @override
  String get consultationShowLessReviews => 'Show Less';

  @override
  String get consultationFeedbackTitle => 'Feedback';

  @override
  String get consultationAvailabilityRetry => 'Retry';

  @override
  String get consultationSummaryTitle => 'Summary';

  @override
  String get consultationSummaryAccountNoLabel => 'Account No.';

  @override
  String get consultationSummaryTotalAmountLabel => 'Total Amount';

  @override
  String get consultationTimeLabel => 'Time';

  @override
  String get commonContinue => 'Continue';

  @override
  String get bookingsDashboardTitle => 'My Bookings';

  @override
  String bookingsDetailsOrderTitle(String orderId) {
    return 'Order no $orderId';
  }

  @override
  String get bookingsSurgeryDetailsTitle => 'Details';

  @override
  String get bookingsTabInstantDoctor => 'Instant Doctor';

  @override
  String get bookingsTabPharmacy => 'Pharmacy';

  @override
  String get bookingsTabDoctorConsultation => 'Doctor Consultation';

  @override
  String get bookingsTabLabTest => 'Lab Tests';

  @override
  String get bookingsTabSurgery => 'Surgery';

  @override
  String get bookingsInstantDoctorEmptyDescription =>
      'No instant doctor bookings yet.';

  @override
  String get bookingsLabTestEmptyDescription => 'No lab test bookings yet.';

  @override
  String get bookingsDoctorConsultationEmptyDescription =>
      'No Booking Available';

  @override
  String get bookingsSurgeryEmptyDescription => 'No surgery bookings yet.';

  @override
  String get bookingsStatusLabel => 'Status';

  @override
  String get bookingsDateLabel => 'Date';

  @override
  String get bookingsDateCreatedLabel => 'Date Created';

  @override
  String get bookingsViewDetailsCta => 'View Details';

  @override
  String get bookingsJoinConsultationCta => 'Join Consultation';

  @override
  String get bookingsJoinConsultationDisabledTooltip =>
      'You will be able to join the consultation at the time of appointment';

  @override
  String get bookingsFeeLabel => 'Fee';

  @override
  String get bookingsTotalLabel => 'Total';

  @override
  String get bookingsPaymentDetailsTitle => 'Payment Details';

  @override
  String get bookingsDiscountCodeLabel => 'Discount Code';

  @override
  String get bookingsShowCodeInstruction =>
      'Show this code to the hospital representative';

  @override
  String get bookingsSurgeryProcedureSubtitle =>
      'Photorefractive keratectomy Surgery';

  @override
  String get bookingsSurgeryPatientName => 'Haseeb Qasim';

  @override
  String get bookingsProceedCheckoutCta => 'Proceed Checkout';

  @override
  String get bookingsRequirementsTitle => 'Requirements';

  @override
  String get bookingsSurgeryRequirement1 =>
      'Fast for 9-12 Hours before Appointment time';

  @override
  String get bookingsSurgeryRequirement2 =>
      'Avoid Stenious Physical Activ ity the day of the appointment';

  @override
  String get bookingsSurgeryRequirement3 =>
      'Ensure that you are NOTtaking any antibiotic medication course';

  @override
  String get bookingsDetailsLoadError =>
      'Unable to load booking details. Please try again.';

  @override
  String get bookingsStatusPending => 'Pending';

  @override
  String get bookingsStatusConfirmed => 'Confirmed';

  @override
  String get bookingsStatusCancel => 'Cancel';

  @override
  String get bookingsStatusFailed => 'Failed';

  @override
  String get bookingsStatusCompleted => 'Completed';

  @override
  String get bookingsPatientLabel => 'Patient';

  @override
  String get bookingsIssueLabel => 'Issue';

  @override
  String get bookingsBillingTitle => 'Billing';

  @override
  String get bookingsEInvoiceLabel => 'E-Invoice';

  @override
  String get bookingsConsultationFeeLabel => 'Consultation fee';

  @override
  String bookingsDiscountLabel(String percent) {
    return 'Discount ($percent%)';
  }

  @override
  String get bookingsJoinNowCta => 'Join Now';

  @override
  String get bookingsPatientsReviewTitle => 'Patient’s Review';

  @override
  String get bookingsDoctorsFeedbackTitle => 'Doctor’s Feedback';

  @override
  String get bookingsYourFeedbackLabel => 'Your Feedback';

  @override
  String get bookingsFeedbackHint => 'Write your feedback...';

  @override
  String get bookingsSubmitFeedbackCta => 'Submit Feedback';

  @override
  String get bookingsFeedbackSubmitSuccess => 'Thank you for your feedback.';

  @override
  String get bookingsFeedbackSelectRating => 'Please select a rating.';

  @override
  String get bookingsFeedbackMissingRef =>
      'Unable to submit feedback for this booking.';

  @override
  String get bookingsDocumentsTitle => 'Documents';

  @override
  String get bookingsPrescriptionsTitle => 'Prescription';

  @override
  String get bookingsDownloadCta => 'Download';

  @override
  String bookingsAttachmentFallback(int index) {
    return 'Document $index';
  }

  @override
  String get labTestSampleTypeBlood => 'Blood';

  @override
  String get securityGateAccessDenied => 'Access denied';

  @override
  String get securityGateFallbackMessage =>
      'Your device does not meet security requirements.';

  @override
  String securityGateWillCloseIn(int count) {
    return 'This app will close in $count seconds';
  }

  @override
  String get securityGateChecking => 'Checking device security…';

  @override
  String get proCatalogLoadError =>
      'Unable to load ApnaClinic Pro right now. Please try again.';

  @override
  String get proRetry => 'Retry';

  @override
  String get proMenuTitle => 'ApnaClinic Pro';

  @override
  String get proMenuYouAreMember => 'You are a Pro Member';

  @override
  String get proMemberBannerSubtitle =>
      'Avail Free Delivery on Pharmacy, Free Instant Doctor service and exclusive discounts on Doctor Consultations and lab tests';

  @override
  String get proShowInfoSectionTitle => 'Subscribe to Pro';

  @override
  String get proShowInfoSubscribeCta => 'Subscribe Now!';

  @override
  String get proShowInfoSubtitle =>
      'Become a pro member to get additional discount';

  @override
  String get proShowInfoConsultationTitle => 'Doctor Consultation Discount';

  @override
  String get proShowInfoConsultationDiscount => '20% OFF';

  @override
  String get proShowInfoLabTitle => 'Lab Test Discount';

  @override
  String get proShowInfoLabDiscount => '20% OFF';

  @override
  String get proShowInfoPharmacyTitle => 'Pharmacy Discount';

  @override
  String get proShowInfoPharmacyDiscount => 'Free Delivery';

  @override
  String get proSubscribeSuccessTitle =>
      'You\'re subscribed to the Pro version!';

  @override
  String get proSubscribeSuccessMessage =>
      'Enjoy exclusive discounts on pharmacy orders, consultations, labs and surgery';

  @override
  String get proSubscribeSuccessOk => 'OK';

  @override
  String get proSubscribeSuccessConsultation => 'Book Doctor Consultation';

  @override
  String get proSubscribeSuccessPharmacy => 'Order Pharmacy';

  @override
  String get proSubscribeSuccessLab => 'Book Lab Test';

  @override
  String get proPaymentPending => 'Payment is pending.';

  @override
  String get proHomeSectionTitle => 'Apna Clinic PRO';

  @override
  String get proHomeCardFallbackCta => 'Tap to Subscribe';

  @override
  String get proActiveMemberSubtitle =>
      'You are eligible for the following discounts on Apna Clinic';

  @override
  String get proActiveBenefitsSuffix => 'Benefits';

  @override
  String proPlanRenewsOn(String date) {
    return 'Plan renews on $date';
  }

  @override
  String proPlanExpiresOn(String date) {
    return 'Plan expires on $date';
  }

  @override
  String get proCancelSubscription => 'Cancel Subscription';

  @override
  String get proCancelSubscriptionTitle =>
      'Are you sure you want to cancel your Pro Subscription?';

  @override
  String get proCancelSubscriptionMessage =>
      'All the PRO discounts and free delivery will be removed from your account if you choose to cancel the subscription.';

  @override
  String get proCancelSubscriptionConfirm => 'Cancel Subscription';

  @override
  String get proCancelSubscriptionDiscard => 'Don\'t Cancel';

  @override
  String get proAvatarBadge => 'PRO';

  @override
  String get proCancelSubscriptionSuccess =>
      'Your Pro subscription has been cancelled.';

  @override
  String get proUnsubscribeSuccessTitle => 'Subscription Cancelled!';

  @override
  String get proUnsubscribeSuccessMessage =>
      'Your PRO subscription has been cancelled.';

  @override
  String get proUnsubscribeSuccessOk => 'Okay';

  @override
  String get jazzCashVerificationRequiredTitle => 'Verification Required';

  @override
  String get jazzCashVerificationRequiredDescription =>
      'Please enter your JazzCash MPIN for your registered number.';

  @override
  String get jazzCashWaitingForApproval => 'Waiting for approval...';

  @override
  String get jazzCashWaitingForPaymentConfirmationTitle =>
      'Waiting for payment\nconfirmation';

  @override
  String get jazzCashStatusTitle => 'Status';

  @override
  String get jazzCashStatusWaitingMessage =>
      'Waiting for JazzCash confirmation...';

  @override
  String jazzCashSecondsRemaining(int seconds) {
    return '$seconds seconds remaining';
  }

  @override
  String get jazzCashForJazzUsersTitle => 'For Jazz Users';

  @override
  String get jazzCashForJazzUsersDescription =>
      'Please unlock your phone and you will get a PIN input prompt. Enter your MPIN to confirm the payment';

  @override
  String get jazzCashForOtherNetworksTitle => 'For Other Networks';

  @override
  String get jazzCashForOtherNetworksSubtitle =>
      'Approve payment in your JazzCash App';

  @override
  String get jazzCashOtherNetworksStep1 =>
      'Login to JazzCash App and tap on profile picture to open the menu';

  @override
  String get jazzCashOtherNetworksStep2 =>
      'Then tap on “Payment Requests” and accept the payment request';

  @override
  String get jazzCashOtherNetworksStep3 =>
      'Then enter your MPIN to confirm the payment.';

  @override
  String get apnaClinicAiMenuTitle => 'Apna Clinic AI';

  @override
  String get apnaClinicAiTitle => 'Apna Clinic AI';

  @override
  String get apnaClinicAiBrandTag => 'CARE COMPANION';

  @override
  String get apnaClinicAiGreeting => 'Assalam-o-Alaikum';

  @override
  String get apnaClinicAiGuest => 'Guest';

  @override
  String get apnaClinicAiSignedIn => 'Signed in';

  @override
  String get apnaClinicAiConnecting => 'Connecting…';

  @override
  String get apnaClinicAiOnline => 'online';

  @override
  String get apnaClinicAiHeadline => 'How are you\nfeeling today?';

  @override
  String get apnaClinicAiLiveStats => 'Tell me what’s bothering you.';

  @override
  String get apnaClinicAiCommonConcerns => 'Common concerns';

  @override
  String get apnaClinicAiTapToStart => 'tap to start';

  @override
  String get apnaClinicAiWhatICanDo => 'What I can do';

  @override
  String get apnaClinicAiSosTitle =>
      'Chest pain, trouble breathing, heavy bleeding?';

  @override
  String get apnaClinicAiSosBody =>
      'Call Rescue 1122 now — don’t wait for chat.';

  @override
  String get apnaClinicAiFinePrint =>
      'Fees and prices in PKR. I don’t recommend medicines — I find the ones you name.';

  @override
  String get apnaClinicAiVoiceCta => 'Describe it out loud';

  @override
  String get apnaClinicAiVoiceLangs => 'English · اردو · Roman Urdu';

  @override
  String get apnaClinicAiContinue => 'Continue';

  @override
  String get apnaClinicAiStartNew => 'Start something new';

  @override
  String get apnaClinicAiStartTalkingTitle => 'I’ll describe how I feel';

  @override
  String get apnaClinicAiStartTalkingBody =>
      'Speak or type, in English or Urdu. No upload needed.';

  @override
  String get apnaClinicAiStartTalkingCta => 'Start talking';

  @override
  String get apnaClinicAiPrescriptionTitle =>
      'I have a prescription or lab report';

  @override
  String get apnaClinicAiPrescriptionBody =>
      'Describe what the report says. The assistant can still help from your words.';

  @override
  String get apnaClinicAiPrescriptionCta => 'Describe the report';

  @override
  String get apnaClinicAiPrescriptionHint =>
      'Describe the report in your own words, or say what the lab found.';

  @override
  String get apnaClinicAiDisclaimer =>
      'Medical disclaimer — This tool provides general informational guidance only and is not a medical diagnosis. Always consult a qualified healthcare professional. In an emergency call Rescue 1122.';

  @override
  String get apnaClinicAiChatSubtitle => 'online';

  @override
  String get apnaClinicAiHeroTitle =>
      'Ask about your health, your report, or your recommendation.';

  @override
  String get apnaClinicAiHeroBody =>
      'Speak or type in English or Urdu. If it looks like you need a specialist, the assistant will say which one.';

  @override
  String get apnaClinicAiPrompt =>
      'Tell me what’s troubling you, in your own words.';

  @override
  String get apnaClinicAiComposerHint =>
      'Describe a symptom or name a medicine…';

  @override
  String get apnaClinicAiChatComposerHint => 'Type, or tap the mic to speak…';

  @override
  String get apnaClinicAiEmergencyTitle =>
      'This may be urgent — call Rescue 1122';

  @override
  String get apnaClinicAiEmergencyBody =>
      'In Pakistan, Rescue 1122 is the ambulance / emergency number. If someone is in immediate danger, call now or go to the nearest emergency department.';

  @override
  String get apnaClinicAiEmergencyStep1 =>
      'Call 1122 (or local ER) and stay on the line.';

  @override
  String get apnaClinicAiEmergencyStep2 =>
      'Keep the person still, seated or lying down; loosen tight clothing.';

  @override
  String get apnaClinicAiEmergencyStep3 =>
      'Do not give food, drink, or medicines unless a clinician tells you to.';

  @override
  String get apnaClinicAiEmergencyCta => 'Call 1122';

  @override
  String get apnaClinicAiEmergencyNote =>
      'In Pakistan, call **Rescue 1122** for an ambulance, or go to the nearest ER now.';

  @override
  String get apnaClinicAiTapDoctor => 'Tap a doctor';

  @override
  String get apnaClinicAiViewSlots => 'View slots';

  @override
  String get apnaClinicAiAddToCart => 'Add to cart';

  @override
  String get apnaClinicAiDoctors => 'Doctors';

  @override
  String get apnaClinicAiMedicines => 'Medicines';

  @override
  String get apnaClinicAiSlots => 'Available slots';

  @override
  String get apnaClinicAiPickADay => 'Pick a day';

  @override
  String get apnaClinicAiPayment => 'Payment';

  @override
  String get apnaClinicAiNotConfigured =>
      'Apna Clinic AI is not configured. Add APNA_CLINIC_AI_BASE_URL and APNA_CLINIC_AI_SDK_KEY.';

  @override
  String get apnaClinicAiConnectFailed =>
      'Could not connect to Apna Clinic AI. Please try again.';

  @override
  String get apnaClinicAiUpstream =>
      'Booking didn’t go through just now. Tell me which doctor and a preferred time again. If this is urgent, call Rescue 1122.';

  @override
  String get apnaClinicAiBookingFailed =>
      'Something went wrong on the booking service. Please try again in a moment.';

  @override
  String get apnaClinicAiVoiceUnavailable =>
      'Microphone is unavailable. Allow microphone access, or type your message.';

  @override
  String get apnaClinicAiEmptyRecording =>
      'No speech heard. Hold the mic a little longer, or type your message.';

  @override
  String get apnaClinicAiSignInRequired =>
      'Sign in to book or use the cart. Symptom guidance works as a guest.';

  @override
  String get apnaClinicAiSignInCta => 'Sign in to continue';

  @override
  String get apnaClinicAiNewChat => 'New chat';

  @override
  String get apnaClinicAiSpeakReplies => 'Speak replies';

  @override
  String get apnaClinicAiHoldToTalk => 'Tap to talk';

  @override
  String get apnaClinicAiTapMicToSend => 'Tap the mic to send';

  @override
  String get apnaClinicAiVoiceEnglish => 'EN';

  @override
  String get apnaClinicAiVoiceUrdu => 'اردو';

  @override
  String get apnaClinicAiListening => 'Listening…';

  @override
  String get apnaClinicAiSuggestFever => 'I have fever and body ache';

  @override
  String get apnaClinicAiSuggestRash => 'I have a rash on my arm';

  @override
  String get apnaClinicAiSuggestDoctors => 'show general physician doctors';

  @override
  String get apnaClinicAiSuggestPanadol => 'do you have Panadol';

  @override
  String apnaClinicAiMinutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String apnaClinicAiHoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String apnaClinicAiDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get apnaClinicAiStageListening => 'Listening to your symptoms…';

  @override
  String get apnaClinicAiStageSpecialists => 'Checking specialists…';

  @override
  String get apnaClinicAiStageDoctors => 'Looking up live doctors…';

  @override
  String get apnaClinicAiStageClinic => 'Matching the right clinic…';

  @override
  String get apnaClinicAiStageReady => 'Almost ready…';

  @override
  String get apnaClinicAiStageTranscribing => 'Transcribing your voice…';

  @override
  String get apnaClinicAiStageRouter => 'Understanding your request…';

  @override
  String get apnaClinicAiStageCapability => 'Choosing the right path…';

  @override
  String get apnaClinicAiStageDispatch => 'Talking to ApnaClinic…';

  @override
  String get apnaClinicAiStageBrowse => 'Loading doctors…';

  @override
  String get apnaClinicAiStageTriage => 'Reviewing your symptoms…';

  @override
  String get apnaClinicAiStageTool => 'Fetching live availability…';

  @override
  String get apnaClinicAiStageWriting => 'Writing reply…';

  @override
  String get apnaClinicBotLabel => 'Apna Clinic Bot';

  @override
  String get apnaClinicBotBubble => 'Ask me';

  @override
  String get pharmacyScanPrescription => 'Scan prescription';

  @override
  String get pharmacyScanFabHint => 'Snap a photo';

  @override
  String get pharmacyScanPrescriptionHint =>
      'Take a photo or choose a prescription image';

  @override
  String get pharmacyScanSourceTitle => 'Prescription photo';

  @override
  String get pharmacyScanUseCamera => 'Use camera';

  @override
  String get pharmacyScanChooseGallery => 'Choose from gallery';

  @override
  String get pharmacyScanChangePhoto => 'Change photo';

  @override
  String get pharmacyScanExtract => 'Read prescription';

  @override
  String get pharmacyScanReading => 'Reading prescription…';

  @override
  String get pharmacyScanFailed =>
      'Could not read this prescription. Try a clearer photo.';

  @override
  String get pharmacyScanNotConfigured =>
      'Prescription reading is not set up yet.';

  @override
  String get pharmacyScanNoMedicines =>
      'No medicines were found on this prescription.';

  @override
  String get pharmacyScanTests => 'Tests';

  @override
  String get pharmacyScanMedicines => 'Medicines';

  @override
  String get pharmacyScanPatient => 'Patient';

  @override
  String get pharmacyScanDoctor => 'Doctor';

  @override
  String get pharmacyScanDate => 'Date';

  @override
  String get pharmacyScanInstitute => 'Institute';

  @override
  String get pharmacyScanLocation => 'Location';

  @override
  String get pharmacyScanLabReport => 'Lab report';

  @override
  String get pharmacyScanVisit => 'Visit';

  @override
  String get pharmacyScanMatching => 'Finding in pharmacy…';

  @override
  String get pharmacyScanNotInCatalog => 'Not available in pharmacy';

  @override
  String pharmacyScanPages(int count) {
    return '$count pages';
  }

  @override
  String pharmacyScanQuantity(int count) {
    return 'Qty $count';
  }

  @override
  String get pharmacyScanBannerTitle => 'Medicines ready when you are';

  @override
  String get pharmacyScanBannerSubtitle =>
      'Scan a clear prescription photo and we’ll match medicines from our pharmacy.';

  @override
  String get pharmacyScanUploadTitle => 'Upload prescription';

  @override
  String get pharmacyScanUploadSubtitle => 'Camera or gallery · JPEG / PNG';
}
