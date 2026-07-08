import 'package:equatable/equatable.dart';

import '../../data/models/doctor_consultation_checkout_model.dart';

class DoctorConsultationCheckoutState extends Equatable {
  const DoctorConsultationCheckoutState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.data,
    this.selectedPaymentMethodId,
    this.errorMessage,
  });

  final bool isLoading;
  final bool isSubmitting;
  final DoctorConsultationCheckoutModel? data;
  final String? selectedPaymentMethodId;
  final String? errorMessage;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  DoctorConsultationCheckoutState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    DoctorConsultationCheckoutModel? data,
    String? selectedPaymentMethodId,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DoctorConsultationCheckoutState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      data: data ?? this.data,
      selectedPaymentMethodId:
          selectedPaymentMethodId ?? this.selectedPaymentMethodId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSubmitting,
        data,
        selectedPaymentMethodId,
        errorMessage,
      ];
}
