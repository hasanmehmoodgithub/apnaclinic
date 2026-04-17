import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
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
  }) = _SurgeryState;
}
