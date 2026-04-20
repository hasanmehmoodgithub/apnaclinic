import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_setup_state.freezed.dart';

@freezed
abstract class ProfileSetupState with _$ProfileSetupState {
  const factory ProfileSetupState({
    @Default(false) bool isSaving,
    String? errorMessage,
    String? selectedGender,
    DateTime? dateOfBirth,
  }) = _ProfileSetupState;
}
