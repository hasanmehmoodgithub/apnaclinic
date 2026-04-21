import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/functional/functional_export.dart';
import '../../../../core/enums/state_status.dart';
import '../../domain/entities/surgery_procedure_entity.dart';
import '../../domain/use_cases/get_surgery_content_use_case.dart';
import '../../domain/use_cases/submit_surgery_booking_use_case.dart';
import 'surgery_state.dart';

class SurgeryCubit extends Cubit<SurgeryState> {
  SurgeryCubit({
    required this.getSurgeryContentUseCase,
    required this.submitSurgeryBookingUseCase,
  }) : super(const SurgeryState()) {
    loadSurgeryContent();
  }

  final GetSurgeryContentUseCase getSurgeryContentUseCase;
  final SubmitSurgeryBookingUseCase submitSurgeryBookingUseCase;

  void _safeEmit(SurgeryState newState) {
    if (isClosed) return;
    emit(newState);
  }

  Future<void> loadSurgeryContent({bool refresh = false}) async {
    _safeEmit(
      state.copyWith(
        loadingStateStatus: refresh
            ? StateStatus.refreshing
            : StateStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await getSurgeryContentUseCase(
      const GetSurgeryContentParams(),
    );
    if (isClosed) return;

    result.fold(
      (error) => _safeEmit(
        state.copyWith(
          loadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      ),
      (content) => _safeEmit(
        state.copyWith(
          loadingStateStatus: content.procedures.isEmpty
              ? StateStatus.empty
              : StateStatus.success,
          content: content,
          selectedCity: content.defaultCity.isNotEmpty
              ? content.defaultCity
              : state.selectedCity,
          errorMessage: null,
        ),
      ),
    );
  }

  void changeCity(String city) {
    _safeEmit(state.copyWith(selectedCity: city));
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
    required String patientName,
    required String age,
    required String contactNumber,
    required String emergencyContact,
    required String surgeryName,
    required String doctorName,
    required String hospitalName,
  }) async {
    return await submitSurgeryBookingUseCase(
      SubmitSurgeryBookingParams(
        patientName: patientName,
        age: age,
        contactNumber: contactNumber,
        emergencyContact: emergencyContact,
        surgeryName: surgeryName,
        doctorName: doctorName,
        hospitalName: hospitalName,
      ),
    );
  }
}
