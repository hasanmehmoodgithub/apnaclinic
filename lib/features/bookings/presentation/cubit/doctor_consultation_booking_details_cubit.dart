import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../consultation/domain/use_cases/submit_consultation_feedback_use_case.dart';
import '../../data/mock/doctor_consultation_bookings_mock_api.dart';
import '../../data/models/doctor_consultation_booking_details_model.dart';
import 'doctor_consultation_booking_details_state.dart';

class DoctorConsultationBookingDetailsCubit
    extends Cubit<DoctorConsultationBookingDetailsState> {
  DoctorConsultationBookingDetailsCubit({
    required DoctorConsultationBookingsMockApi api,
    required SubmitConsultationFeedbackUseCase submitFeedbackUseCase,
    required String bookingId,
    DoctorConsultationBookingDetailsModel? booking,
  })  : _api = api,
        _submitFeedbackUseCase = submitFeedbackUseCase,
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
  final SubmitConsultationFeedbackUseCase _submitFeedbackUseCase;
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

  Future<bool> submitFeedback({
    required double rating,
    required String review,
  }) async {
    final data = state.data;
    if (data == null || state.isSubmittingFeedback) return false;

    final refNo = data.feedbackRefNo;
    if (refNo.isEmpty) {
      emit(
        state.copyWith(
          feedbackErrorMessage: 'missing_ref',
          clearFeedbackSuccess: true,
        ),
      );
      return false;
    }

    if (rating < 1 || rating > 5) {
      emit(
        state.copyWith(
          feedbackErrorMessage: 'invalid_rating',
          clearFeedbackSuccess: true,
        ),
      );
      return false;
    }

    final trimmedReview = review.trim();
    emit(
      state.copyWith(
        isSubmittingFeedback: true,
        clearFeedbackError: true,
        clearFeedbackSuccess: true,
      ),
    );

    final result = await _submitFeedbackUseCase(
      SubmitConsultationFeedbackParams(
        refNo: refNo,
        rating: rating,
        review: trimmedReview,
      ),
    );

    return result.fold(
      (error) {
        emit(
          state.copyWith(
            isSubmittingFeedback: false,
            feedbackErrorMessage: error,
          ),
        );
        return false;
      },
      (_) {
        emit(
          state.copyWith(
            isSubmittingFeedback: false,
            data: data.copyWith(
              patientReview: DoctorConsultationBookingPatientReview(
                rating: rating,
                review: trimmedReview,
                dateLabel: DateFormat('dd/MM/yyyy').format(DateTime.now()),
              ),
            ),
            feedbackSuccessMessage: 'submitted',
            clearFeedbackError: true,
          ),
        );
        return true;
      },
    );
  }
}
