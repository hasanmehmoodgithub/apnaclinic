import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../consultation/domain/use_cases/get_consultation_booking_use_case.dart';
import '../../../consultation/domain/use_cases/submit_consultation_feedback_use_case.dart';
import '../../../../core/analytics/analytics_event_keys.dart';
import '../../data/mappers/doctor_consultation_booking_mapper.dart';
import '../../data/models/doctor_consultation_booking_details_model.dart';
import '../bookings_analytics.dart';
import 'doctor_consultation_booking_details_state.dart';

class DoctorConsultationBookingDetailsCubit
    extends Cubit<DoctorConsultationBookingDetailsState> {
  DoctorConsultationBookingDetailsCubit({
    required GetConsultationBookingUseCase getBookingUseCase,
    required SubmitConsultationFeedbackUseCase submitFeedbackUseCase,
    required String bookingId,
    DoctorConsultationBookingDetailsModel? booking,
  }) : _getBookingUseCase = getBookingUseCase,
       _submitFeedbackUseCase = submitFeedbackUseCase,
       _bookingId = bookingId,
       super(
         booking != null
             ? DoctorConsultationBookingDetailsState(
                 isLoading: true,
                 data: booking,
               )
             : const DoctorConsultationBookingDetailsState(isLoading: true),
       );

  final GetConsultationBookingUseCase _getBookingUseCase;
  final SubmitConsultationFeedbackUseCase _submitFeedbackUseCase;
  final String _bookingId;

  String get bookingId => _bookingId;

  Future<void> load({bool refresh = false}) async {
    final appointmentId = int.tryParse(_bookingId.trim());
    if (appointmentId == null || appointmentId <= 0) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'load_error',
        ),
      );
      return;
    }

    final keepExisting = refresh && state.data != null;
    emit(
      state.copyWith(
        isLoading: !keepExisting,
        clearError: true,
      ),
    );
    final result = await _getBookingUseCase(
      GetConsultationBookingParams(appointmentId: appointmentId),
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: keepExisting
                ? null
                : (error.isNotEmpty ? error : 'load_error'),
          ),
        );
      },
      (entity) {
        final data = DoctorConsultationBookingMapper.fromEntity(entity);
        emit(
          state.copyWith(
            isLoading: false,
            data: data,
            clearError: true,
          ),
        );
        if (refresh) return;
        BookingsAnalytics.logBookingViewed(
          AnalyticsBookingTypeKeys.consultancy,
        );
        if (data.doctorPrescriptions.isNotEmpty) {
          BookingsAnalytics.logPrescriptionAvailable(
            bookingId: data.bookingId,
            service: AnalyticsBookingTypeKeys.consultancy,
          );
        }
      },
    );
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
