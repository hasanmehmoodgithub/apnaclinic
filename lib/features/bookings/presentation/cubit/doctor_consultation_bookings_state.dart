import 'package:equatable/equatable.dart';

import '../../data/models/doctor_consultation_booking_details_model.dart';

class DoctorConsultationBookingsState extends Equatable {
  const DoctorConsultationBookingsState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasLoaded = false,
    this.items = const [],
    this.errorMessage,
    this.page = 1,
    this.hasMore = false,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasLoaded;
  final List<DoctorConsultationBookingDetailsModel> items;
  final String? errorMessage;
  final int page;
  final bool hasMore;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  DoctorConsultationBookingsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasLoaded,
    List<DoctorConsultationBookingDetailsModel>? items,
    String? errorMessage,
    int? page,
    bool? hasMore,
    bool clearError = false,
  }) {
    return DoctorConsultationBookingsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLoadingMore,
        hasLoaded,
        items,
        errorMessage,
        page,
        hasMore,
      ];
}
