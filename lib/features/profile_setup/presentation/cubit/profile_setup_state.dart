import 'package:equatable/equatable.dart';

class ProfileSetupState extends Equatable {
  const ProfileSetupState({
    this.isSaving = false,
    this.errorMessage,
    this.selectedGender,
    this.dateOfBirth,
  });

  final bool isSaving;
  final String? errorMessage;
  final String? selectedGender;
  final DateTime? dateOfBirth;

  ProfileSetupState copyWith({
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
    String? selectedGender,
    DateTime? dateOfBirth,
  }) {
    return ProfileSetupState(
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedGender: selectedGender ?? this.selectedGender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  @override
  List<Object?> get props => [
    isSaving,
    errorMessage,
    selectedGender,
    dateOfBirth,
  ];
}
