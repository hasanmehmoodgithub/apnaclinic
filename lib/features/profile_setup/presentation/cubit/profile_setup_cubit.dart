import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/profile_setup_entity.dart';
import '../../domain/models/profile_setup_data.dart';
import '../../domain/use_cases/get_profile_setup_content_use_case.dart';
import '../../domain/use_cases/save_profile_setup_use_case.dart';
import 'profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  ProfileSetupCubit({
    required GetProfileSetupContentUseCase getProfileSetupContentUseCase,
    required SaveProfileSetupUseCase saveProfileSetupUseCase,
  }) : _getProfileSetupContentUseCase = getProfileSetupContentUseCase,
       _saveProfileSetupUseCase = saveProfileSetupUseCase,
       super(const ProfileSetupState());

  final GetProfileSetupContentUseCase _getProfileSetupContentUseCase;
  final SaveProfileSetupUseCase _saveProfileSetupUseCase;

  Future<void> loadProfile() async {
    emit(
      state.copyWith(
        loadingStateStatus: StateStatus.loading,
        errorMessage: null,
      ),
    );
    final result = await _getProfileSetupContentUseCase.call();
    result.fold(
      (error) => emit(
        state.copyWith(
          loadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      ),
      (profile) => emit(
        state.copyWith(
          loadingStateStatus: StateStatus.success,
          profile: profile,
          selectedGender: profile.gender.isEmpty ? null : profile.gender,
          dateOfBirth: profile.dateOfBirth,
          errorMessage: null,
        ),
      ),
    );
  }

  void setGender(String? gender) {
    emit(state.copyWith(selectedGender: gender, errorMessage: null));
  }

  void setDateOfBirth(DateTime date) {
    emit(state.copyWith(dateOfBirth: date, errorMessage: null));
  }

  Future<bool> saveProfile(ProfileSetupData data) async {
    emit(state.copyWith(isSaving: true, errorMessage: null));
    final result = await _saveProfileSetupUseCase.call(data);
    return result.fold((error) {
      emit(state.copyWith(isSaving: false, errorMessage: error));
      return false;
    }, (_) {
      final updatedProfile =
          state.profile?.copyWith(
            firstName: data.firstName,
            lastName: data.lastName,
            gender: data.gender,
            email: data.email,
            address: data.address,
            dateOfBirth: data.dateOfBirth,
          ) ??
          ProfileSetupEntity(
            firstName: data.firstName,
            lastName: data.lastName,
            gender: data.gender,
            email: data.email,
            address: data.address,
            dateOfBirth: data.dateOfBirth,
          );
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: null,
          profile: updatedProfile,
        ),
      );
      return true;
    });
  }
}
