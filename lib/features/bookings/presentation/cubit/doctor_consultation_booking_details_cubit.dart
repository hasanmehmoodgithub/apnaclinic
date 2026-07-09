import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/mock/doctor_consultation_bookings_mock_api.dart';
import '../../data/models/doctor_consultation_booking_details_model.dart';
import 'doctor_consultation_booking_details_state.dart';

class DoctorConsultationBookingDetailsCubit
    extends Cubit<DoctorConsultationBookingDetailsState> {
  DoctorConsultationBookingDetailsCubit({
    required DoctorConsultationBookingsMockApi api,
    required String bookingId,
    DoctorConsultationBookingDetailsModel? booking,
  })  : _api = api,
        _bookingId = bookingId,
        super(
          booking != null
              ? DoctorConsultationBookingDetailsState(
                  isLoading: false,
                  data: booking,
                )
              : const DoctorConsultationBookingDetailsState(isLoading: true),
        );

  final DoctorConsultationBookingsMockApi _api;
  final String _bookingId;

  Future<void> load() async {
    if (state.data != null) return;

    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final result = await _api.getBookingDetails(bookingId: _bookingId);
      emit(
        state.copyWith(
          isLoading: false,
          data: result,
          clearError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'load_error',
        ),
      );
    }
  }
}
