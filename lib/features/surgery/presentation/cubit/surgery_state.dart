import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/surgery_doctor_entity.dart';
import '../../domain/entities/surgery_patient_form_entity.dart';
import '../../domain/entities/surgery_procedure_entity.dart';

part 'surgery_state.freezed.dart';

@freezed
abstract class SurgeryState with _$SurgeryState {
  const factory SurgeryState({
    @Default(StateStatus.idle) StateStatus loadingStateStatus,
    @Default(SurgeryContentEntity(cities: [], defaultCity: '', procedures: []))
    SurgeryContentEntity content,
    @Default('') String selectedCity,
    @Default('') String searchQuery,
    @Default({}) Set<String> selectedProcedureIds,
    String? errorMessage,
    @Default(StateStatus.idle) StateStatus doctorsLoadingStateStatus,
    @Default(SurgeryDoctorsEntity(
      procedureName: '',
      city: '',
      hospitals: [],
      specialties: [],
      doctors: [],
    ))
    SurgeryDoctorsEntity doctorsContent,
    String? doctorsErrorMessage,
    @Default(StateStatus.idle) StateStatus patientFormLoadingStateStatus,
    @Default(SurgeryPatientFormEntity.empty)
    SurgeryPatientFormEntity patientForm,
    String? patientFormErrorMessage,
  }) = _SurgeryState;
}
