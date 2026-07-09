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
  String get pharmacyMainSearchHint => 'Search medicine..';

  @override
  String get pharmacyCartTitle => 'Cart';

  @override
  String get pharmacyCartEmpty => 'Your cart is empty';

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
  String get pharmacyCheckoutSpecialInstructionsHint => '----';

  @override
  String get pharmacyCheckoutOrderDetailsTitle => 'Order Details';

  @override
  String get pharmacyCheckoutDeliveryChargesLabel => 'Delivery Charges';

  @override
  String get pharmacyCheckoutDiscountLabel => 'Discount (8%)';

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
  String get pharmacyCheckoutDeliveryInfoMessage =>
      'Orders will be delivered within 3 hours between 8:00 AM and 8:00 PM. Orders placed after 8:00 PM will be delivered by 12PM the following day.';

  @override
  String get pharmacyCheckoutDeliveryInfoFooter =>
      'Orders below Rs 2500 will include delivery charges of Rs 250.';

  @override
  String get pharmacyCheckoutConfirmCta => 'Confirm';

  @override
  String get pharmacyOrderPlacedTitle => 'Order Placed';

  @override
  String get pharmacyOrderPlacedMessage =>
      'Orders received b/w 8 AM - 8 PM will be delivered within 3 business hrs.';

  @override
  String get pharmacyOrderPlacedClose => 'Close';

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
      'Access reliable lab tests from reputable labs with accurate results.';

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
  String get instantDoctorTitle => 'Instant Doctor';

  @override
  String get instantDoctorOpenAppCta => 'Subscribe Now!';

  @override
  String get instantDoctorOpenAppError =>
      'Could not open subscription page right now.';

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
  String get instantDoctorCancelSubscriptionTitle => 'Cancel Subscription?';

  @override
  String instantDoctorCancelSubscriptionMessage(String providerName) {
    return 'Are you sure you want to cancel your $providerName subscription?';
  }

  @override
  String get instantDoctorCancelSubscriptionConfirm => 'Yes, Cancel';

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
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsRetryCta => 'Retry';

  @override
  String get notificationsEmptyTitle => 'No Notifications Yet!';

  @override
  String get notificationsLoadError =>
      'Unable to load notifications. Pull to refresh or try again.';

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
  String get labTestSelectCityPlaceholder => 'Select City';

  @override
  String get labTestCityFieldLabel => 'City';

  @override
  String get labTestChangeCityCta => 'Change';

  @override
  String get labTestSelectTestHeading => 'Select Test';

  @override
  String get labTestSearchFieldHint => 'Search';

  @override
  String get labTestSelectCitySheetTitle => 'Select a city';

  @override
  String get labTestSelectCitySheetSearchHint => 'Search by name';

  @override
  String get labTestRequirementLabel => 'Requirement';

  @override
  String get labTestSampleTypeLabel => 'Sample Type';

  @override
  String get labTestSampleTypeNotAvailable => 'N/A';

  @override
  String get labTestPleaseSelectCityFirst => 'Please select a city first.';

  @override
  String get labTestDataStillLoading => 'Lab test data is still loading.';

  @override
  String get labTestCatalogLoadFailed => 'Failed to load lab tests.';

  @override
  String get labTestNoTestsFound => 'No tests found';

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
  String get labTestCartProceedCheckout => 'Proceed Checkout';

  @override
  String get labTestViewDetailsLoadError =>
      'Unable to load details. Please try again.';

  @override
  String get labTestSomethingWentWrong => 'Something went wrong';

  @override
  String get commonRetry => 'Retry';

  @override
  String get labTestViewDetailsResultsTitle => 'Test Results';

  @override
  String get labTestViewDetailsOrderTitle => 'Order Details';

  @override
  String get labTestDiscountCodeCopied => 'Discount code copied';

  @override
  String get labTestOrderNoPrefix => 'Order no.';

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
  String get labTestCheckoutBookedTitle => 'Lab Test Booked Successfully';

  @override
  String get labTestCheckoutBookedMessage =>
      'A lab representative will contact you shortly.\nPresent your discount code to the lab representative.\nTo access your code later:';

  @override
  String get labTestCheckoutBookedPathHint => 'Menu > My Bookings > Lab Test';

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
  String get labTestEmergencyNumberHint => 'Enter Number here...';

  @override
  String get labTestPatientNameLabel => 'Patient Name';

  @override
  String get labTestContactNumberLabel => 'Contact Number';

  @override
  String get labTestAddressLabel => 'Address';

  @override
  String get labTestFullNameHint => 'Full name';

  @override
  String get labTestPhonebookHint => 'Type or select from phonebook';

  @override
  String get labTestAgeLabel => 'Age';

  @override
  String get labTestAddressHint => 'Type address here...';

  @override
  String get commonMale => 'Male';

  @override
  String get commonFemale => 'Female';

  @override
  String get labTestBookCta => 'Book Lab Test';

  @override
  String get consultationAiScreeningTitle => 'AI Screening';

  @override
  String get consultationAiWelcomePrefix => 'Hello, welcome to ';

  @override
  String get consultationAiWelcomeSuffix => ' , let\'s get started';

  @override
  String get consultationAiStartCta => 'Let\'s Start';

  @override
  String get consultationSelectCategoriesTitle => 'Select Categories';

  @override
  String get consultationSpecialistTitle => 'Specialist';

  @override
  String get consultationVideoBookingPrompt =>
      'Book your video consultation here!';

  @override
  String get consultationGetAppointmentCta => 'Get Appointment';

  @override
  String get consultationBookingConfirmedTitle => 'Appointment Confirmed!';

  @override
  String consultationBookingConfirmedMessage(Object doctorName) {
    return 'Your consultation has been booked with $doctorName. You can join the call from Appointments.';
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
  String get consultationPaymentMethodTitle => 'Payment Method';

  @override
  String get consultationVideoConsultationLabel => 'Video Consultation';

  @override
  String get consultationConsultationFeesLabel => 'Consultation Fees';

  @override
  String get consultationDiscountLabel => 'Discount';

  @override
  String get consultationTotalChargesLabel => 'Total Charges';

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
      'No appointment slots are available for this doctor right now.';

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
  String get bookingsTabDoctorConsultation => 'Doctor Consultation';

  @override
  String get bookingsTabSurgery => 'Surgery';

  @override
  String get bookingsTabLabTest => 'Lab Test';

  @override
  String get bookingsTabPharmacy => 'Pharmacy';

  @override
  String get bookingsLabTestEmptyDescription => 'No lab test bookings yet.';

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
  String get bookingsFeeLabel => 'Fee';

  @override
  String get bookingsTotalLabel => 'Total';

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
  String get bookingsDiscountLabel => 'Discount (100%)';

  @override
  String get bookingsJoinNowCta => 'Join Now';

  @override
  String get labTestSampleTypeBlood => 'Blood';
}
