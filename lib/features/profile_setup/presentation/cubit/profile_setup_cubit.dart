import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/profile_setup_data.dart';
import '../../domain/repositories/profile_setup_repository.dart';
import 'profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  ProfileSetupCubit(this._repository) : super(const ProfileSetupState());

  final ProfileSetupRepository _repository;

  void setGender(String? gender) {
    emit(state.copyWith(selectedGender: gender, clearError: true));
  }

  void setDateOfBirth(DateTime date) {
    emit(state.copyWith(dateOfBirth: date, clearError: true));
  }

  Future<bool> saveProfile(ProfileSetupData data) async {
    emit(state.copyWith(isSaving: true, clearError: true));
    try {
      await _repository.saveProfile(data);
      emit(state.copyWith(isSaving: false, clearError: true));
      return true;
    } catch (_) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: 'Failed to save profile. Please try again.',
        ),
      );
      return false;
    }
  }
}
