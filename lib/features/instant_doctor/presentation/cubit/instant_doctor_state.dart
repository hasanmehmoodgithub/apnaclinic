import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/instant_doctor_entity.dart';

part 'instant_doctor_state.freezed.dart';

@freezed
abstract class InstantDoctorState with _$InstantDoctorState {
  const factory InstantDoctorState({
    @Default(StateStatus.idle) StateStatus loadingStateStatus,
    InstantDoctorEntity? content,
    String? errorMessage,
    @Default(false) bool isOpeningApp,
  }) = _InstantDoctorState;
}
