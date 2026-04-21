import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/profile_setup_entity.dart';

part 'profile_setup_state.freezed.dart';

@freezed
abstract class ProfileSetupState with _$ProfileSetupState {
  const factory ProfileSetupState({
    @Default(StateStatus.idle) StateStatus loadingStateStatus,
    @Default(false) bool isSaving,
    String? errorMessage,
    ProfileSetupEntity? profile,
    String? selectedGender,
    DateTime? dateOfBirth,
  }) = _ProfileSetupState;
}
