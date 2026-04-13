import '../../domain/entities/free_doctor_entity.dart';

class FreeDoctorState {
  const FreeDoctorState({
    this.content,
    this.isLoading = false,
    this.errorMessage,
    this.isOpeningApp = false,
  });

  final FreeDoctorEntity? content;
  final bool isLoading;
  final String? errorMessage;
  final bool isOpeningApp;

  FreeDoctorState copyWith({
    FreeDoctorEntity? content,
    bool? isLoading,
    String? errorMessage,
    bool? isOpeningApp,
  }) {
    return FreeDoctorState(
      content: content ?? this.content,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isOpeningApp: isOpeningApp ?? this.isOpeningApp,
    );
  }
}
