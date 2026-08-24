import 'package:equatable/equatable.dart';

import '../../../instant_doctor/domain/entities/instant_doctor_booking_entity.dart';

class InstantDoctorBookingsState extends Equatable {
  const InstantDoctorBookingsState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.items = const [],
    this.errorMessage,
    this.page = 1,
    this.hasMore = false,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final List<InstantDoctorBookingEntity> items;
  final String? errorMessage;
  final int page;
  final bool hasMore;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  InstantDoctorBookingsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<InstantDoctorBookingEntity>? items,
    String? errorMessage,
    int? page,
    bool? hasMore,
    bool clearError = false,
  }) {
    return InstantDoctorBookingsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
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
        items,
        errorMessage,
        page,
        hasMore,
      ];
}
