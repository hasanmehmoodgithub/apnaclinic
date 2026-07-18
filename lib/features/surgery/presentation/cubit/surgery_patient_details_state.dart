import '../../../../core/enums/state_status.dart';
import '../widgets/surgery_option.dart';

enum SurgeryPatientValidationFailure {
  emergencyRequired,
  phoneInvalid,
  ageInvalid,
  requiredFields,
}

class SurgeryPatientDetailsState {
  const SurgeryPatientDetailsState({
    this.selectedGender,
    this.showNameError = false,
    this.showAgeError = false,
    this.showGenderError = false,
    this.showContactError = false,
    this.showEmergencyError = false,
    this.validationFailure,
    this.selectedPackage,
    this.packages = const [],
    this.packagesStatus = StateStatus.idle,
    this.submitStatus = StateStatus.idle,
    this.errorMessage,
    this.packagesLoadFailed = false,
    this.bookingSubmitted = false,
  });

  final String? selectedGender;
  final bool showNameError;
  final bool showAgeError;
  final bool showGenderError;
  final bool showContactError;
  final bool showEmergencyError;
  final SurgeryPatientValidationFailure? validationFailure;
  final SurgeryOption? selectedPackage;
  final List<SurgeryOption> packages;
  final StateStatus packagesStatus;
  final StateStatus submitStatus;
  final String? errorMessage;
  final bool packagesLoadFailed;
  final bool bookingSubmitted;

  bool get isLoadingPackages => packagesStatus == StateStatus.loading;
  bool get isSubmitting => submitStatus == StateStatus.loading;

  SurgeryPatientDetailsState copyWith({
    String? selectedGender,
    bool clearSelectedGender = false,
    bool? showNameError,
    bool? showAgeError,
    bool? showGenderError,
    bool? showContactError,
    bool? showEmergencyError,
    SurgeryPatientValidationFailure? validationFailure,
    bool clearValidationFailure = false,
    SurgeryOption? selectedPackage,
    bool clearSelectedPackage = false,
    List<SurgeryOption>? packages,
    StateStatus? packagesStatus,
    StateStatus? submitStatus,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? packagesLoadFailed,
    bool? bookingSubmitted,
  }) {
    return SurgeryPatientDetailsState(
      selectedGender:
          clearSelectedGender ? null : (selectedGender ?? this.selectedGender),
      showNameError: showNameError ?? this.showNameError,
      showAgeError: showAgeError ?? this.showAgeError,
      showGenderError: showGenderError ?? this.showGenderError,
      showContactError: showContactError ?? this.showContactError,
      showEmergencyError: showEmergencyError ?? this.showEmergencyError,
      validationFailure: clearValidationFailure
          ? null
          : (validationFailure ?? this.validationFailure),
      selectedPackage: clearSelectedPackage
          ? null
          : (selectedPackage ?? this.selectedPackage),
      packages: packages ?? this.packages,
      packagesStatus: packagesStatus ?? this.packagesStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      packagesLoadFailed: packagesLoadFailed ?? this.packagesLoadFailed,
      bookingSubmitted: bookingSubmitted ?? this.bookingSubmitted,
    );
  }
}
