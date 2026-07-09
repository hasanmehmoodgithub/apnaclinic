import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/instant_doctor_provider_entity.dart';
import '../../domain/enums/instant_doctor_otp_action.dart';

part 'instant_doctor_state.freezed.dart';

@freezed
abstract class InstantDoctorState with _$InstantDoctorState {
  const factory InstantDoctorState({
    @Default(StateStatus.idle) StateStatus loadingStateStatus,
    @Default(<InstantDoctorProviderEntity>[]) List<InstantDoctorProviderEntity> providers,
    String? errorMessage,
    int? openingProviderId,
    InstantDoctorProviderEntity? activeOtpProvider,
    InstantDoctorOtpAction? otpAction,
    String? subscriptionUuid,
    @Default(StateStatus.idle) StateStatus sendOtpStatus,
    @Default(StateStatus.idle) StateStatus verifyOtpStatus,
    @Default(30) int otpSecondsRemaining,
    String? otpErrorMessage,
  }) = _InstantDoctorState;

  const InstantDoctorState._();

  bool get canResendOtp => otpSecondsRemaining <= 0;

  bool isProviderBusy(int providerId) {
    return openingProviderId == providerId ||
        (sendOtpStatus == StateStatus.loading &&
            activeOtpProvider?.providerId == providerId);
  }
}
