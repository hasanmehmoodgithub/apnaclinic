import 'package:equatable/equatable.dart';

import '../../data/models/doctor_consultation_booking_details_model.dart';

class DoctorConsultationBookingDetailsState extends Equatable {
  const DoctorConsultationBookingDetailsState({
    this.isLoading = false,
    this.isSubmittingFeedback = false,
    this.data,
    this.errorMessage,
    this.feedbackErrorMessage,
    this.feedbackSuccessMessage,
  });

  final bool isLoading;
  final bool isSubmittingFeedback;
  final DoctorConsultationBookingDetailsModel? data;
  final String? errorMessage;
  final String? feedbackErrorMessage;
  final String? feedbackSuccessMessage;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  DoctorConsultationBookingDetailsState copyWith({
    bool? isLoading,
    bool? isSubmittingFeedback,
    DoctorConsultationBookingDetailsModel? data,
    String? errorMessage,
    String? feedbackErrorMessage,
    String? feedbackSuccessMessage,
    bool clearError = false,
    bool clearFeedbackError = false,
    bool clearFeedbackSuccess = false,
  }) {
    return DoctorConsultationBookingDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isSubmittingFeedback: isSubmittingFeedback ?? this.isSubmittingFeedback,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      feedbackErrorMessage: clearFeedbackError
          ? null
          : (feedbackErrorMessage ?? this.feedbackErrorMessage),
      feedbackSuccessMessage: clearFeedbackSuccess
          ? null
          : (feedbackSuccessMessage ?? this.feedbackSuccessMessage),
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSubmittingFeedback,
        data,
        errorMessage,
        feedbackErrorMessage,
        feedbackSuccessMessage,
      ];
}
