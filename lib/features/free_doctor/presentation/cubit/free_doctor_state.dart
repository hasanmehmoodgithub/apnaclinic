import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/free_doctor_entity.dart';

part 'free_doctor_state.freezed.dart';

@freezed
abstract class FreeDoctorState with _$FreeDoctorState {
  const factory FreeDoctorState({
    @Default(StateStatus.idle) StateStatus loadingStateStatus,
    FreeDoctorEntity? content,
    String? errorMessage,
    @Default(false) bool isOpeningApp,
  }) = _FreeDoctorState;
}
