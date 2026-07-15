import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cities/domain/repositories/cities_repository.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/functional/functional_export.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/preference/app_pref_keys.dart';
import '../../domain/entities/surgery_procedure_entity.dart';
import '../../domain/entities/surgery_provider_details_entity.dart';
import '../../domain/use_cases/get_surgery_content_use_case.dart';
import '../../domain/use_cases/get_surgery_doctors_use_case.dart';
import '../../domain/use_cases/get_surgery_patient_form_use_case.dart';
import '../../domain/use_cases/get_surgery_provider_details_use_case.dart';
import '../../domain/use_cases/submit_surgery_booking_use_case.dart';
import 'surgery_state.dart';

class SurgeryCubit extends Cubit<SurgeryState> {
  SurgeryCubit({
    required this.getSurgeryContentUseCase,
    required this.getSurgeryDoctorsUseCase,
    required this.getSurgeryPatientFormUseCase,
    required this.getSurgeryProviderDetailsUseCase,
    required this.submitSurgeryBookingUseCase,
    required this.appPref,
    required this.citiesRepository,
  }) : super(const SurgeryState()) {
    loadSurgeryContent(city: _savedCity());
  }

  final GetSurgeryContentUseCase getSurgeryContentUseCase;
  final GetSurgeryDoctorsUseCase getSurgeryDoctorsUseCase;
  final GetSurgeryPatientFormUseCase getSurgeryPatientFormUseCase;
  final GetSurgeryProviderDetailsUseCase getSurgeryProviderDetailsUseCase;
  final SubmitSurgeryBookingUseCase submitSurgeryBookingUseCase;
  final AppPref appPref;
  final CitiesRepository citiesRepository;

  void _safeEmit(SurgeryState newState) {
    if (isClosed) return;
    emit(newState);
  }

  String? _savedCity() {
    final raw = appPref.getString(AppPrefKeys.surgerySelectedCity)?.trim();
    if (raw == null || raw.isEmpty) return null;
    return _resolveCityName(raw) ?? raw;
  }

  String? _resolveCityName(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final trimmed = raw.trim();
    if (citiesRepository.cityIdForName(trimmed) != null) {
      final normalized = trimmed.toLowerCase();
      for (final name in citiesRepository.cityNames) {
        if (name.trim().toLowerCase() == normalized) return name;
      }
      return trimmed;
    }
    return null;
  }

  Future<void> _persistCity(String city) async {
    final resolved = _resolveCityName(city) ?? city.trim();
    if (resolved.isEmpty) return;
    await appPref.setString(AppPrefKeys.surgerySelectedCity, resolved);
  }

  Future<void> loadSurgeryContent({bool refresh = false, String? city}) async {
    final resolvedCity = (city ?? state.selectedCity).trim();
    final cityForRequest =
        _resolveCityName(resolvedCity) ??
        (resolvedCity.isNotEmpty ? resolvedCity : null);
    _safeEmit(
      state.copyWith(
        loadingStateStatus: refresh
            ? StateStatus.refreshing
            : StateStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await getSurgeryContentUseCase(
      GetSurgeryContentParams(
        city: cityForRequest,
      ),
    );
    if (isClosed) return;

    result.fold(
      (error) => _safeEmit(
        state.copyWith(
          loadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      ),
      (content) {
        final nextCity = (cityForRequest != null && cityForRequest.isNotEmpty)
            ? (_resolveCityName(cityForRequest) ?? cityForRequest)
            : (content.defaultCity.isNotEmpty
                ? content.defaultCity
                : state.selectedCity);
        _safeEmit(
          state.copyWith(
            loadingStateStatus: StateStatus.success,
            content: content,
            selectedCity: nextCity,
            searchQuery: refresh ? '' : state.searchQuery,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> loadSurgeryDoctors({
    required String surgeryId,
    required String procedureName,
    bool refresh = false,
  }) async {
    _safeEmit(
      state.copyWith(
        doctorsLoadingStateStatus: refresh
            ? StateStatus.refreshing
            : StateStatus.loading,
        doctorsErrorMessage: null,
      ),
    );

    final result = await getSurgeryDoctorsUseCase(
      GetSurgeryDoctorsParams(
        surgeryId: surgeryId,
        procedureName: procedureName,
        city: state.selectedCity,
      ),
    );
    if (isClosed) return;

    result.fold(
      (error) => _safeEmit(
        state.copyWith(
          doctorsLoadingStateStatus: StateStatus.error,
          doctorsErrorMessage: error,
        ),
      ),
      (doctorsContent) => _safeEmit(
        state.copyWith(
          doctorsLoadingStateStatus: doctorsContent.doctors.isEmpty
              ? StateStatus.empty
              : StateStatus.success,
          doctorsContent: doctorsContent,
          doctorsErrorMessage: null,
        ),
      ),
    );
  }

  Future<Either<ErrorMsg, SurgeryProviderDetailsEntity>>
      loadSurgeryProviderDetails({
    required String surgeryId,
    required String cityId,
    required String doctorId,
  }) async {
    _safeEmit(
      state.copyWith(
        providerDetailsLoadingStateStatus: StateStatus.loading,
        providerDetailsErrorMessage: null,
      ),
    );

    final result = await getSurgeryProviderDetailsUseCase(
      GetSurgeryProviderDetailsParams(
        surgeryId: surgeryId,
        cityId: cityId,
        doctorId: doctorId,
      ),
    );
    if (isClosed) return result;

    result.fold(
      (error) => _safeEmit(
        state.copyWith(
          providerDetailsLoadingStateStatus: StateStatus.error,
          providerDetailsErrorMessage: error,
        ),
      ),
      (providerDetails) => _safeEmit(
        state.copyWith(
          providerDetailsLoadingStateStatus:
              providerDetails.packages.isEmpty
                  ? StateStatus.empty
                  : StateStatus.success,
          providerDetails: providerDetails,
          providerDetailsErrorMessage: null,
        ),
      ),
    );

    return result;
  }

  Future<void> loadSurgeryPatientForm({required String doctorId}) async {
    _safeEmit(
      state.copyWith(
        patientFormLoadingStateStatus: StateStatus.loading,
        patientFormErrorMessage: null,
      ),
    );

    final result = await getSurgeryPatientFormUseCase(
      GetSurgeryPatientFormParams(doctorId: doctorId),
    );
    if (isClosed) return;

    result.fold(
      (error) => _safeEmit(
        state.copyWith(
          patientFormLoadingStateStatus: StateStatus.error,
          patientFormErrorMessage: error,
        ),
      ),
      (patientForm) => _safeEmit(
        state.copyWith(
          patientFormLoadingStateStatus: patientForm.surgeryOptions.isEmpty
              ? StateStatus.empty
              : StateStatus.success,
          patientForm: patientForm,
          patientFormErrorMessage: null,
        ),
      ),
    );
  }

  Future<void> changeCity(String city) async {
    final resolved = _resolveCityName(city) ?? city.trim();
    if (resolved.isEmpty || resolved == state.selectedCity) return;
    await _persistCity(resolved);
    _safeEmit(state.copyWith(selectedCity: resolved, searchQuery: ''));
    await loadSurgeryContent(refresh: true, city: resolved);
  }

  void updateSearchQuery(String query) {
    _safeEmit(state.copyWith(searchQuery: query));
  }

  void toggleProcedure(String id) {
    final selected = {...state.selectedProcedureIds};
    if (selected.contains(id)) {
      selected.remove(id);
    } else {
      selected.add(id);
    }
    _safeEmit(state.copyWith(selectedProcedureIds: selected));
  }

  List<SurgeryProcedureEntity> get filteredProcedures {
    final query = state.searchQuery.trim().toLowerCase();
    if (query.isEmpty) return state.content.procedures;
    return state.content.procedures
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  Future<Either<ErrorMsg, void>> submitSurgeryBooking({
    required String doctorId,
    required String surgeryId,
    required String packageId,
    required String cityId,
    required String patientName,
    required String age,
    required String gender,
    required String phone,
    required String emergencyPhone,
  }) async {
    return await submitSurgeryBookingUseCase(
      SubmitSurgeryBookingParams(
        doctorId: doctorId,
        surgeryId: surgeryId,
        packageId: packageId,
        cityId: cityId,
        patientName: patientName,
        age: age,
        gender: gender,
        phone: phone,
        emergencyPhone: emergencyPhone,
      ),
    );
  }
}
