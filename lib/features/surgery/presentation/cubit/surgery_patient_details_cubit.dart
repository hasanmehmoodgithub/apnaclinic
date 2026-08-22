import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
import '../../domain/use_cases/get_surgery_provider_details_use_case.dart';
import '../../domain/use_cases/submit_surgery_booking_use_case.dart';
import '../widgets/surgery_option.dart';
import 'surgery_patient_details_state.dart';

class SurgeryPatientDetailsCubit extends Cubit<SurgeryPatientDetailsState> {
  SurgeryPatientDetailsCubit({
    required this.getSurgeryProviderDetailsUseCase,
    required this.submitSurgeryBookingUseCase,
    required this.appPref,
  }) : super(const SurgeryPatientDetailsState());

  final GetSurgeryProviderDetailsUseCase getSurgeryProviderDetailsUseCase;
  final SubmitSurgeryBookingUseCase submitSurgeryBookingUseCase;
  final AppPref appPref;

  String _surgeryId = '';
  String _cityId = '';
  String _doctorId = '';
  String _fallbackProcedureName = '';

  void initialize({
    required String surgeryId,
    required String cityId,
    required String doctorId,
    required SurgeryOption initialPackage,
  }) {
    _surgeryId = surgeryId;
    _cityId = cityId;
    _doctorId = doctorId;
    _fallbackProcedureName = initialPackage.name;

    emit(
      state.copyWith(
        selectedPackage: initialPackage,
        selectedGender: _genderFromPref(),
        bookingSubmitted: false,
        packagesLoadFailed: false,
        clearErrorMessage: true,
        clearValidationFailure: true,
      ),
    );
    loadPackages();
  }

  void selectGender(String gender) {
    emit(
      state.copyWith(
        selectedGender: gender,
        showGenderError: false,
        clearValidationFailure: true,
      ),
    );
  }

  void selectPackage(SurgeryOption package) {
    emit(state.copyWith(selectedPackage: package));
  }

  void clearTransientMessages() {
    emit(
      state.copyWith(
        clearErrorMessage: true,
        packagesLoadFailed: false,
        bookingSubmitted: false,
      ),
    );
  }

  Future<List<SurgeryOption>> loadPackages({
    bool notifyOnFailure = false,
  }) async {
    if (_surgeryId.isEmpty || _cityId.isEmpty || _doctorId.isEmpty) {
      return const [];
    }

    emit(
      state.copyWith(
        packagesStatus: StateStatus.loading,
        packagesLoadFailed: false,
        clearErrorMessage: true,
      ),
    );

    final result = await getSurgeryProviderDetailsUseCase(
      GetSurgeryProviderDetailsParams(
        surgeryId: _surgeryId,
        cityId: _cityId,
        doctorId: _doctorId,
      ),
    );
    if (isClosed) return const [];

    return result.fold(
      (error) {
        emit(
          state.copyWith(
            packagesStatus: StateStatus.error,
            packagesLoadFailed: notifyOnFailure,
            errorMessage: notifyOnFailure ? null : error,
          ),
        );
        return const [];
      },
      (details) {
        final options = details.packages
            .map(
              (item) => SurgeryOption(
                id: item.packageId,
                name: item.packageName,
                price: item.price,
                oldPrice: item.oldPrice,
                hospitalName: item.hospitalName,
              ),
            )
            .toList();

        if (options.isEmpty) {
          emit(
            state.copyWith(
              packages: const [],
              packagesStatus: StateStatus.empty,
              packagesLoadFailed: notifyOnFailure,
            ),
          );
          return const [];
        }

        emit(
          state.copyWith(
            packages: options,
            selectedPackage: _resolveSelectedPackage(options),
            packagesStatus: StateStatus.success,
            packagesLoadFailed: false,
          ),
        );
        return options;
      },
    );
  }

  Future<void> submit({
    required String patientName,
    required String age,
    required String phone,
    required String emergencyPhone,
  }) async {
    final gender = state.selectedGender ?? '';
    final failure = _validate(
      name: patientName,
      age: age,
      gender: gender,
      phone: phone,
      emergencyPhone: emergencyPhone,
    );
    if (failure != null) return;

    var package = state.selectedPackage;
    if (package == null || package.id.trim().isEmpty) {
      emit(state.copyWith(submitStatus: StateStatus.loading));
      await loadPackages();
      if (isClosed) return;
      package = state.selectedPackage;
    }

    if (package == null || package.id.trim().isEmpty) {
      emit(
        state.copyWith(
          submitStatus: StateStatus.idle,
          packagesLoadFailed: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        showNameError: false,
        showAgeError: false,
        showGenderError: false,
        showContactError: false,
        showEmergencyError: false,
        clearValidationFailure: true,
        submitStatus: StateStatus.loading,
        packagesLoadFailed: false,
        clearErrorMessage: true,
        bookingSubmitted: false,
      ),
    );

    final result = await submitSurgeryBookingUseCase(
      SubmitSurgeryBookingParams(
        doctorId: _doctorId,
        surgeryId: _surgeryId,
        packageId: package.id,
        cityId: _cityId,
        patientName: patientName,
        age: age,
        gender: gender,
        phone: phone,
        emergencyPhone: emergencyPhone,
      ),
    );
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          submitStatus: StateStatus.error,
          errorMessage: error,
        ),
      ),
      (bookingId) => emit(
        state.copyWith(
          submitStatus: StateStatus.success,
          bookingSubmitted: true,
          bookingId: bookingId,
        ),
      ),
    );
  }

  SurgeryPatientValidationFailure? _validate({
    required String name,
    required String age,
    required String gender,
    required String phone,
    required String emergencyPhone,
  }) {
    final trimmedName = name.trim();
    final trimmedAge = age.trim();
    final trimmedPhone = phone.trim();
    final trimmedEmergency = emergencyPhone.trim();

    final nameMissing = trimmedName.isEmpty;
    final ageMissing = trimmedAge.isEmpty;
    final parsedAge = int.tryParse(trimmedAge);
    final ageInvalid =
        !ageMissing && (parsedAge == null || parsedAge <= 0);
    final genderMissing = gender.isEmpty;
    final contactMissing = trimmedPhone.isEmpty;
    final contactInvalid =
        !contactMissing && !_isValidContactPhone(trimmedPhone);
    final emergencyMissing = trimmedEmergency.isEmpty;
    final emergencyInvalid =
        !emergencyMissing && !_isValidContactPhone(trimmedEmergency);

    if (nameMissing ||
        ageMissing ||
        ageInvalid ||
        genderMissing ||
        contactMissing ||
        contactInvalid ||
        emergencyMissing ||
        emergencyInvalid) {
      final failure = nameMissing
          ? SurgeryPatientValidationFailure.requiredFields
          : emergencyMissing
              ? SurgeryPatientValidationFailure.emergencyRequired
              : (contactInvalid || emergencyInvalid)
                  ? SurgeryPatientValidationFailure.phoneInvalid
                  : ageInvalid || ageMissing
                      ? SurgeryPatientValidationFailure.ageInvalid
                      : SurgeryPatientValidationFailure.requiredFields;

      emit(
        state.copyWith(
          showNameError: nameMissing,
          showAgeError: ageMissing || ageInvalid,
          showGenderError: genderMissing,
          showContactError: contactMissing || contactInvalid,
          showEmergencyError: emergencyMissing || emergencyInvalid,
          validationFailure: failure,
          submitStatus: StateStatus.idle,
        ),
      );
      return failure;
    }
    return null;
  }

  SurgeryOption _resolveSelectedPackage(List<SurgeryOption> options) {
    final current = state.selectedPackage;
    final currentId = current?.id ?? '';
    if (currentId.isNotEmpty) {
      final match = options.where((item) => item.id == currentId);
      if (match.isNotEmpty) return match.first;
    }

    final targetName =
        (current?.name ?? _fallbackProcedureName).toLowerCase();
    final byName =
        options.where((item) => item.name.toLowerCase() == targetName);
    return byName.isNotEmpty ? byName.first : options.first;
  }

  String? _genderFromPref() {
    final raw = appPref.getUserLocalModel()?.gender ?? '';
    final normalized = raw.trim().toLowerCase();
    if (normalized == 'male' || normalized == 'm') return 'male';
    if (normalized == 'female' || normalized == 'f') return 'female';
    return null;
  }

  /// Contact / emergency: 10 digits (e.g. PTCL) or 11 digits (mobile). Max 11.
  bool _isValidContactPhone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return digits.length == 10 || digits.length == 11;
  }

  String? prefillFullName() {
    final user = appPref.getUserLocalModel();
    if (user == null) return null;
    final fullName = '${user.firstName} ${user.lastName}'.trim();
    return fullName.isEmpty ? null : fullName;
  }

  String? prefillPhone() {
    final phone = appPref.getUserLocalModel()?.phone.trim() ?? '';
    return phone.isEmpty ? null : phone;
  }

  String? prefillAge() {
    final rawDob = appPref.getUserLocalModel()?.dateOfBirth ?? '';
    final value = rawDob.trim();
    if (value.isEmpty) return null;
    final dob = DateTime.tryParse(value);
    if (dob == null) return null;
    final now = DateTime.now();
    var age = now.year - dob.year;
    final hasHadBirthday = now.month > dob.month ||
        (now.month == dob.month && now.day >= dob.day);
    if (!hasHadBirthday) age -= 1;
    if (age <= 0) return null;
    return age.toString();
  }
}
