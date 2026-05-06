import 'package:equatable/equatable.dart';

import '../../data/models/doctor_consultation_booking_details_model.dart';

class DoctorConsultationBookingDetailsState extends Equatable {
  const DoctorConsultationBookingDetailsState({
    this.isLoading = false,
    this.data,
    this.errorMessage,
  });

  final bool isLoading;
  final DoctorConsultationBookingDetailsModel? data;
  final String? errorMessage;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  DoctorConsultationBookingDetailsState copyWith({
    bool? isLoading,
    DoctorConsultationBookingDetailsModel? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DoctorConsultationBookingDetailsState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, data, errorMessage];
}
